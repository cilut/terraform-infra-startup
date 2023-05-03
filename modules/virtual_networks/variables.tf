variable "vnet" {
  type = list(object({
    name                = string
    address_space       = list(string)
    location            = string
    resource_group_name = string
  }))
}

variable "subnet" {
  type = list(object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
    address_prefixes     = list(string)
  }))
}

