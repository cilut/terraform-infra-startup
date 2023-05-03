output "subnet_output" {
  value = {
    for subnet in azurerm_subnet.subnet : subnet.name => subnet.id
  }
}
output "vnet_output" {
  value = {
    for vnet in azurerm_virtual_network.vnet : vnet.name => vnet.id
  }
}
