terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {}

data "digitalocean_ssh_keys" "keys" {}

variable "region" {
  type    = string
  default = "sfo3"
}

variable "droplet_size" {
  type        = string
  description = "The droplet size's slug"
  default     = "s-2vcpu-4gb-amd"
}

resource "digitalocean_droplet" "valheim_server" {
  image    = "docker-20-04"
  name     = "valheim-server"
  region   = var.region
  size     = var.droplet_size
  ssh_keys = toset([for k in data.digitalocean_ssh_keys.keys.ssh_keys : k.fingerprint])
}

resource "null_resource" "bootstrap" {
  provisioner "local-exec" {
    command = "./scripts/bootstrap.sh ${digitalocean_droplet.valheim_server.ipv4_address}"
  }
}

resource "digitalocean_reserved_ip" "valheim_ip" {
  region = var.region
}

resource "digitalocean_reserved_ip_assignment" "valheim_ip" {
  droplet_id = digitalocean_droplet.valheim_server.id
  ip_address = digitalocean_reserved_ip.valheim_ip.ip_address
}

output "ip_address" {
  value = digitalocean_reserved_ip.valheim_ip.ip_address
}
