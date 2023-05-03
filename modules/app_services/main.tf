resource "azurerm_service_plan" "example" {
  count = length(var.app_service_plan)

  name                = "${var.app_service_plan[count.index].name}-plan"
  location            = var.app_service_plan[count.index].location
  resource_group_name = var.app_service_plan[count.index].resource_group_name
  sku_name            = var.app_service_plan[count.index].sku_name
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "example" {
  count = length(azurerm_service_plan.example)

  name                = "${var.app_service_plan[count.index].name}-app"
  location            = var.app_service_plan[count.index].location
  resource_group_name = var.app_service_plan[count.index].resource_group_name
  service_plan_id     = azurerm_service_plan.example[count.index].id

  site_config {}
}

resource "azurerm_app_service_virtual_network_swift_connection" "example" {

  count = length(azurerm_service_plan.example)

  app_service_id = azurerm_linux_web_app.example[count.index].id
  subnet_id      = var.subnet_output[var.app_service_plan[count.index].subnet_name]
}
