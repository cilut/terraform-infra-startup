locals {
  rg = [
    {
      name   = "rg-${var.env}"
      region = "${var.region_primaria}"
    }
  ]

  vnet = [
    {
      name                = "${var.env}-vnet"
      address_space       = ["10.0.0.0/16"]
      location            = "${var.region_primaria}"
      resource_group_name = "rg-${var.env}"
    }
  ]

  subnet = [
    {
      name                 = "${var.env}-afd-subnet"
      resource_group_name  = "rg-${var.env}"
      virtual_network_name = "${var.env}-vnet"
      address_prefixes     = ["10.0.0.0/24"]
    },
    {
      name                 = "${var.env}-web-subnet"
      resource_group_name  = "rg-${var.env}"
      virtual_network_name = "${var.env}-vnet"
      address_prefixes     = ["10.0.1.0/24"]
    },
    {
      name                 = "${var.env}-api-subnet"
      resource_group_name  = "rg-${var.env}"
      virtual_network_name = "${var.env}-vnet"
      address_prefixes     = ["10.0.2.0/24"]
    },
    {
      name                 = "${var.env}-crm-subnet"
      resource_group_name  = "rg-${var.env}"
      virtual_network_name = "${var.env}-vnet"
      address_prefixes     = ["10.0.3.0/24"]
    },
    {
      name                 = "${var.env}-storage-subnet"
      resource_group_name  = "rg-${var.env}"
      virtual_network_name = "${var.env}-vnet"
      address_prefixes     = ["10.0.4.0/24"]
    }
  ]


  app_service_plan = [
    # {
    #   name                = "${var.env}-${var.nombre_proyecto}-web"
    #   location            = "${var.region_primaria}"
    #   resource_group_name = "rg-${var.env}"
    #   tier                = "Basic"
    #   sku_name            = "B1"
    #   subnet_name         = "${var.env}-web-subnet"
    # },
    {
      name                = "${var.env}-${var.nombre_proyecto}-api"
      location            = "${var.region_primaria}"
      resource_group_name = "rg-${var.env}"
      sku_name            = "B1"
      subnet_name         = "${var.env}-api-subnet"
    }
  ]

  postgre_sql_server = [{

    name                         = "${var.env}-${var.nombre_proyecto}-sql-server"
    resource_group_name          = "rg-${var.env}"
    location                     = "${var.region_primaria}"
    version                      = "14"
    administrator_login          = "admin"
    administrator_login_password = "+94a3+Azasdgfasdfasdfa"
    sku_name                     = "B_Gen5_2"
    subnet_name                  = "${var.env}-storage-subnet"
    vnet_name                    = "${var.env}-vnet"
    }
  ]

  postgre_sql_db = [{
    name                = "${var.env}-${var.nombre_proyecto}-sql-db"
    resource_group_name = "rg-${var.env}"
    server_name         = "${var.env}-${var.nombre_proyecto}-sql-server"
    charset             = "UTF8"
    collation           = "en_US.UTF8"
    sku_name            = "B_Gen5_1"

    }
  ]
  storage_account = [{
    name                     = "${var.env}${var.nombre_proyecto}sa"
    resource_group_name      = "rg-${var.env}"
    location                 = "${var.region_primaria}"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    subnet_name              = "${var.env}-storage-subnet"

    }
  ]
  front_door = {
    project_name        = "${var.nombre_proyecto}"
    env                 = "${var.env}"
    resource_group_name = "rg-${var.env}"
    domain_name         = "${var.domain}"
    domain              = "${var.domain}"

  }

  profiles = [{
    name                = "${var.env}-${var.nombre_proyecto}-afd"
    resource_group_name = "rg-${var.env}"
    sku_name            = "Standard_AzureFrontDoor"
    domains = {
      name       = "${var.env}-${var.nombre_proyecto}-domain"
      host_name  = "api.${var.env}.${var.domain}"
      record_dns = "api"
    }


    }
  ]

  origin_groups = [{
    name = "${var.env}-${var.nombre_proyecto}-api"
    origins = {
      name               = "${var.env}-${var.nombre_proyecto}-api"
      host_name          = "${var.env}-${var.nombre_proyecto}-api-app.azurewebsites.net"
      http_port          = 80
      https_port         = 443
      origin_host_header = "${var.env}-${var.nombre_proyecto}-api-app.azurewebsites.net"
      priority           = 1
      weight             = 1000

    }


    }
  ]

  endpoint = [{

    name = "${var.env}-${var.nombre_proyecto}-api"
    env  = "${var.env}"
    route = {
      name = "${var.env}-${var.nombre_proyecto}-api"
      patterns_to_match = {
        p1 = "/*"
      }


      supported_protocols = {
        p1 = "http"
        p2 = "https"
      }

    }

    }
  ]

}
