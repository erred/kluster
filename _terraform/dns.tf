resource "cloudflare_record" "cluster" {
  provider = cloudflare

  zone_id = var.cloudflare_zone_id
  name    = var.cluster
  type    = "A"
  value   = var.instance_ip
  proxied = false
}

resource "cloudflare_record" "apex" {
  provider = cloudflare

  zone_id = var.cloudflare_zone_id
  name    = "seankhliao.com"
  type    = "CNAME"
  value   = "${var.cluster}.seankhliao.com"
  proxied = false
}

resource "cloudflare_record" "default" {
  provider = cloudflare

  zone_id = var.cloudflare_zone_id
  name    = "*"
  type    = "CNAME"
  value   = "${var.cluster}.seankhliao.com"
  proxied = false
}

# resource "cloudflare_record" "vanity" {
#   provider = cloudflare
#
#   zone_id = var.cloudflare_zone_id
#   name    = "go"
#   type    = "CNAME"
#   value   = "${var.cluster}.seankhliao.com"
#   proxied = false
# }
#
# resource "cloudflare_record" "statslogger" {
#   provider = cloudflare
#
#   zone_id = var.cloudflare_zone_id
#   name    = "statslogger"
#   type    = "CNAME"
#   value   = "${var.cluster}.seankhliao.com"
#   proxied = false
# }
#
# resource "cloudflare_record" "ghdefaults" {
#   provider = cloudflare
#
#   zone_id = var.cloudflare_zone_id
#   name    = "ghdefaults"
#   type    = "CNAME"
#   value   = "${var.cluster}.seankhliao.com"
#   proxied = false
# }
