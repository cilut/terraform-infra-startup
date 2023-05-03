resource "azurerm_resource_group" "my-resource-group" {
  count = length(var.rg)

  name     = var.rg[count.index].name
  location = var.rg[count.index].region
}
