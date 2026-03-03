terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Remote state backend (Azure Storage) 
  
   backend "azurerm" {
     resource_group_name  = "rg-fyp-tfstate"
     storage_account_name = "fyptfstatemarkl"
     container_name       = "tfstate"
     key                  = "fyp.terraform.tfstate"
   }
}

provider "azurerm" {
  features {}

  use_cli         = true
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}


