terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}

  use_cli         = true
  subscription_id = "2f30cf7a-f59c-4acc-b5fa-1229dece5528"
  tenant_id       = "766317cb-e948-4e5f-8cec-dabc8e2fd5da"
}


