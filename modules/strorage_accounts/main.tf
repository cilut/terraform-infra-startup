resource "azurerm_storage_account" "storage" {
  count = length(var.storage_account)

  name                          = var.storage_account[count.index].name
  resource_group_name           = var.storage_account[count.index].resource_group_name
  location                      = var.storage_account[count.index].location
  account_tier                  = var.storage_account[count.index].account_tier
  account_replication_type      = var.storage_account[count.index].account_replication_type
  public_network_access_enabled = false

  tags = {
    environment = "staging"
  }
}

