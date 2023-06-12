module "resource_group" {
  source = "./modules/resource_groups"

  rg = local.rg
}


module "virtual_networks" {
  depends_on = [
    module.resource_group
  ]
  source = "./modules/virtual_networks"

  vnet   = local.vnet
  subnet = local.subnet
}

# module "virtual_machine" {

#   depends_on = [
#     module.resource_group, module.virtual_networks
#   ]
#   source = "./modules/virtual_machines"

# }

module "app_service" {

  depends_on = [
    module.resource_group
  ]
  source           = "./modules/app_services"
  app_service_plan = local.app_service_plan
  subnet_output    = module.virtual_networks.subnet_output

}

# module "database" {

#   depends_on = [
#     module.resource_group
#   ]
#   source             = "./modules/databases"
#   postgre_sql_server = local.postgre_sql_server
#   postgre_sql_db     = local.postgre_sql_db
#   subnet_output      = module.virtual_networks.subnet_output
#   vnet_output        = module.virtual_networks.vnet_output
# }

module "storage_accounts" {
  depends_on = [
    module.virtual_networks
  ]
  source          = "./modules/strorage_accounts"
  storage_account = local.storage_account
  subnet_output   = module.virtual_networks.subnet_output
  vnet_output     = module.virtual_networks.vnet_output
}

module "front_door" {

  depends_on = [
    module.resource_group
  ]
  source        = "./modules/front_doors"
  front_door    = local.front_door
  endpoint      = local.endpoint
  origin_groups = local.origin_groups
  profiles      = local.profiles

}


