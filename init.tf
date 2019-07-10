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

provider "template" {
  version = "~> 2.1"
}

provider "local" {
  version = "~> 1.3"
}

provider "kubernetes" {
  version = "~> 1.8"
  config_path            = var.kubeconfig_path
}

provider "godaddy" {
  key = var.godaddy_key
  secret = var.godaddy_secret
}

provider "helm" {
  debug = true
  version = "~> 0.10"
  namespace       = "kube-system"
  service_account = "tiller"
  install_tiller  = "true"
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

terraform {
  required_version = ">= 0.12"
  backend          "azurerm"        {}
}
