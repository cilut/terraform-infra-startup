variable "storage_account" {
  type = list(object({
    name                     = string
    resource_group_name      = string
    location                 = string
    account_tier             = string
    account_replication_type = string
    subnet_name              = string
  }))
}

variable "subnet_output" {
  type = map(string)
}
variable "vnet_output" {
  type = map(string)
}
