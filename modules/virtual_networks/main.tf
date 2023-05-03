# Creación de la VNET
resource "azurerm_virtual_network" "vnet" {
  count = length(var.vnet)

  name                = var.vnet[count.index].name
  address_space       = var.vnet[count.index].address_space
  location            = var.vnet[count.index].location
  resource_group_name = var.vnet[count.index].resource_group_name
}

resource "azurerm_subnet" "subnet" {
  depends_on = [azurerm_virtual_network.vnet]
  count      = length(var.subnet)

  name                 = var.subnet[count.index].name
  resource_group_name  = var.subnet[count.index].resource_group_name
  virtual_network_name = var.subnet[count.index].virtual_network_name
  address_prefixes     = var.subnet[count.index].address_prefixes

  dynamic "delegation" {
    for_each = endswith(var.subnet[count.index].name, "-storage-subnet") ? [1] : []
    content {
      name = "fs"

      dynamic "service_delegation" {
        for_each = [1]
        content {
          name    = "Microsoft.DBforPostgreSQL/flexibleServers"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
        }
      }
    }
  }
  dynamic "delegation" {
    for_each = endswith(var.subnet[count.index].name, "-web-subnet") || endswith(var.subnet[count.index].name, "-api-subnet") ? [1] : []
    content {
      name = "fs"

      dynamic "service_delegation" {
        for_each = [1]
        content {
          name    = "Microsoft.Web/serverFarms"
          actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      }
    }
  }

}





