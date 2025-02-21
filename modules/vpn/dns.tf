data "cloudflare_zones" "zone" {
  filter {
    name = "120water.com"
  }
}

resource "cloudflare_record" "vpn_dns" {
  zone_id = data.cloudflare_zones.zone.zones[0].id
  name    = "${var.environment_name}.vpn.120water.com"
  value   = aws_eip.vpn.public_ip
  type    = "A"
  ttl     = 60
}