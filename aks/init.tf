## Init ##

provider "azurerm" {
  version = "~> 1.28"
}

provider "random" {
  version = "~> 2.0"
}

provider "null" {
  version = "~> 2.1.2"
}

provider "local" {
  version = "~> 1.2"
}

provider "template" {
  version = "~> 2.1"
}

terraform {
  backend "azurerm" {}
}
