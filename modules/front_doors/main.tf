resource "azurerm_dns_zone" "env_dns" {
  name                = "${var.front_door.env}.${var.front_door.domain}"
  resource_group_name = var.front_door.resource_group_name
}


resource "azurerm_cdn_frontdoor_profile" "env_profile" {
  count               = length(var.profiles)
  name                = var.profiles[count.index].name
  resource_group_name = var.profiles[count.index].resource_group_name
  sku_name            = var.profiles[count.index].sku_name
}


resource "azurerm_cdn_frontdoor_custom_domain" "domain" {
  count = length(var.profiles)

  name                     = var.front_door.project_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.env_profile[0].id
  dns_zone_id              = azurerm_dns_zone.env_dns.id
  host_name                = var.profiles[count.index].domains.host_name

  tls {
    certificate_type    = "ManagedCertificate"
    minimum_tls_version = "TLS12"
  }
}

resource "azurerm_cdn_frontdoor_origin_group" "origin_group" {

  count                    = length(var.origin_groups)
  name                     = var.profiles[count.index].name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.env_profile[0].id

  load_balancing {}
}

resource "azurerm_cdn_frontdoor_origin" "origin_source" {

  count = length(var.origin_groups)

  name                          = var.origin_groups[count.index].origins.name
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group[count.index].id
  enabled                       = true

  certificate_name_check_enabled = false

  host_name          = var.origin_groups[count.index].origins.host_name
  http_port          = var.origin_groups[count.index].origins.http_port
  https_port         = var.origin_groups[count.index].origins.https_port
  origin_host_header = var.origin_groups[count.index].origins.origin_host_header
  priority           = var.origin_groups[count.index].origins.priority
  weight             = var.origin_groups[count.index].origins.weight
}

resource "azurerm_cdn_frontdoor_endpoint" "env_endpoint" {
  count = length(var.endpoint)

  name = var.endpoint[count.index].name

  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.env_profile[0].id

  tags = {
    ENV = var.front_door.env
    RG  = var.front_door.resource_group_name

  }
}

resource "azurerm_cdn_frontdoor_route" "example" {
  count = length(var.endpoint)

  name                          = var.endpoint[count.index].route.name
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.env_endpoint[0].id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group[0].id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.origin_source[0].id]
  enabled                       = true

  forwarding_protocol    = "HttpsOnly"
  https_redirect_enabled = true
  patterns_to_match      = ["/*", "/api"]
  supported_protocols    = ["Http", "Https"]

  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.domain[0].id]
  link_to_default_domain          = false

  cache {
    query_string_caching_behavior = "IgnoreSpecifiedQueryStrings"
    query_strings                 = ["account", "settings"]
    compression_enabled           = true
    content_types_to_compress     = ["text/html", "text/javascript", "text/xml"]
  }
}

resource "azurerm_dns_txt_record" "example" {
  count               = length(var.profiles)
  name                = join(".", ["_dnsauth", var.profiles[count.index].domains.record_dns])
  zone_name           = azurerm_dns_zone.env_dns.name
  ttl                 = 3600
  resource_group_name = var.front_door.resource_group_name

  record {
    value = azurerm_cdn_frontdoor_custom_domain.domain[0].validation_token
  }
}

resource "azurerm_dns_cname_record" "example" {
  count               = length(var.profiles)
  name                = var.profiles[count.index].domains.record_dns
  zone_name           = azurerm_dns_zone.env_dns.name
  resource_group_name = var.front_door.resource_group_name
  ttl                 = 3600
  record              = azurerm_cdn_frontdoor_endpoint.env_endpoint[0].host_name
}
