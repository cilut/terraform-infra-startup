variable "app_service_plan" {
  type = list(object({
    name                = string
    location            = string
    resource_group_name = string
    sku_name            = string
    subnet_name         = string
  }))
}


variable "subnet_output" {
  type = map(string)
}
