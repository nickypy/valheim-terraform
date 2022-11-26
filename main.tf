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

resource "digitalocean_droplet" "valheim_server" {
  image    = "docker-20-04"
  name     = "valheim-server"
  region   = "sfo3"
  size     = "s-2vcpu-4gb-amd"
  ssh_keys = toset([for k in data.digitalocean_ssh_keys.keys.ssh_keys : k.fingerprint])
}

resource "null_resource" "bootstrap" {
  provisioner "local-exec" {
    command = "./scripts/bootstrap.sh ${digitalocean_droplet.valheim_server.ipv4_address}"
  }
}

output "ip_address" {
  value = digitalocean_droplet.valheim_server.ipv4_address
}
