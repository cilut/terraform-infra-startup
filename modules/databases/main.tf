resource "azurerm_private_dns_zone" "example" {
  name                = "asdhfkljhasdkfljhaskdljfhaskjd.postgres.database.azure.com"
  resource_group_name = var.postgre_sql_server[0].resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  name                  = "exampleVnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.example.name
  virtual_network_id    = var.vnet_output[var.postgre_sql_server[0].vnet_name]
  resource_group_name   = var.postgre_sql_server[0].resource_group_name
}

# Define el servidor de Azure Database for PostgreSQL
resource "azurerm_postgresql_flexible_server" "example" {
  depends_on = [azurerm_private_dns_zone_virtual_network_link.example]
  count      = length(var.postgre_sql_server)

  name                   = var.postgre_sql_server[count.index].name
  resource_group_name    = var.postgre_sql_server[count.index].resource_group_name
  location               = var.postgre_sql_server[count.index].location
  version                = var.postgre_sql_server[count.index].version
  administrator_login    = var.postgre_sql_server[count.index].administrator_login
  administrator_password = var.postgre_sql_server[count.index].administrator_login_password
  private_dns_zone_id    = azurerm_private_dns_zone.example.id
  delegated_subnet_id    = var.subnet_output[var.postgre_sql_server[count.index].subnet_name]
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"
  zone                   = "1"
}

# Define la base de datos Azure Database for PostgreSQL
resource "azurerm_postgresql_flexible_server_database" "example" {
  count = length(var.postgre_sql_db)

  name      = var.postgre_sql_db[count.index].name
  server_id = azurerm_postgresql_flexible_server.example[0].id
  charset   = var.postgre_sql_db[count.index].charset
  collation = var.postgre_sql_db[count.index].collation
  depends_on = [
    azurerm_postgresql_flexible_server.example
  ]
}
