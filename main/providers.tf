terraform {
  required_version = "1.1.9"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "= 2.89.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  subscription_id = var.subscription_id
  environment = var.environment

  features {}
}
