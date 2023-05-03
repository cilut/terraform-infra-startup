variable "postgre_sql_server" {
  type = list(object({
    name                         = string
    resource_group_name          = string
    location                     = string
    version                      = string
    administrator_login          = string
    administrator_login_password = string
    sku_name                     = string
    subnet_name                  = string
    vnet_name                    = string
  }))
}

variable "postgre_sql_db" {
  type = list(object({
    name                = string
    resource_group_name = string
    server_name         = string
    charset             = string
    collation           = string
    sku_name            = string
  }))
}

variable "subnet_output" {
  type = map(string)
}
variable "vnet_output" {
  type = map(string)
}
