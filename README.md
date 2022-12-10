# Valheim DigitalOcean Terraform Template
Provisions a DigitalOcean droplet to run a Valheim server.

## Requirements
+ Terraform
+ [A DigitalOcean personal access token in an environment variable](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs)
+ An [SSH key](https://cloud.digitalocean.com/account/security) in your DigitalOcean account. Note that this by default will grant any SSH key under your account access to the droplet that this script provisions.

## Steps
Create a Valheim config. Make sure to update the file to your preferences:
```
cp ./server/valheim.sample.env ./server/valheim.env
```

### Variables
* `region` - For best performance, select one that is physically closest to you.
* `droplet_size` - This is the `slug` property coming from the API. The default is set based on this [recommendation](https://github.com/lloesche/valheim-server-docker#system-requirements).

A full list of slugs are available from the `/v2/sizes` API:
```
curl -XGET \
  -H "Authorization: Bearer $DIGITALOCEAN_TOKEN" \
  "https://api.digitalocean.com/v2/sizes?per_page=100"
```


Finally, run `terraform apply`. You'll need to type "yes" when SSHing into your droplet for the first time.
