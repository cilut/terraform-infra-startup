# Terraform Block
terraform {
  required_version = ">= 1.1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.50.0"
    }
  }
  # backend "azurerm" {
  #   resource_group_name   = "terraform-storage-rg"
  #   storage_account_name  = "terraformstate201"
  #   container_name        = "tfstatefiles"
  #   key                   = "terraform.tfstate"
  # }
}

# Provider Block
provider "azurerm" {
  features {}
}



