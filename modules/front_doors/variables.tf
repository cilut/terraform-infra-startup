
variable "front_door" {
  type = object({
    project_name        = string
    env                 = string
    domain_name         = string
    domain              = string
    resource_group_name = string
  })
}

variable "profiles" {
  type = list(object({
    name                = string
    resource_group_name = string
    sku_name            = string
    domains = object({
      name       = string
      host_name  = string
      record_dns = string
    })
  }))
}


variable "origin_groups" {
  type = list(object({
    name = string
    origins = object({
      name               = string
      host_name          = string
      http_port          = string
      https_port         = string
      origin_host_header = string
      priority           = string
      weight             = string
    })

  }))
}


variable "endpoint" {
  type = list(object({
    name = string
    env  = string
    route = object({
      name = string
      patterns_to_match = object({
        p1 = string
      })

      supported_protocols = object({
        p1 = string
        p2 = string
      })
    })
  }))
}
