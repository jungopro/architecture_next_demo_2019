## Query ##

data "azurerm_client_config" "current" {}

## Create

resource "azurerm_resource_group" "resource_group" {
  name     = "aks"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "aks-vnet"
  location            = "${azurerm_resource_group.resource_group.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  address_space       = ["10.0.0.0/8"]

  tags = {
    environment = "aks"
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = "aks-subnet"
  resource_group_name  = "${azurerm_resource_group.resource_group.name}"
  address_prefix       = "10.240.0.0/24"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "demo-aks"
  location            = "${azurerm_resource_group.resource_group.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  dns_prefix          = "demo-aks"
  kubernetes_version  = "1.13.5"

  agent_pool_profile {
    name            = "default"
    count           = 2
    vm_size         = "Standard_B2ms"
    os_type         = "Linux"
    os_disk_size_gb = 30
    vnet_subnet_id  = "${azurerm_subnet.subnet.id}"
  }

  network_profile {
    network_plugin = "azure"
  }

  service_principal {
    client_id     = "${data.azurerm_client_config.current.client_id}"
    client_secret = "${var.client_secret}"
  }

  role_based_access_control {
    enabled = true
  }

  tags = {
    Environment = "aks"
  }
}
