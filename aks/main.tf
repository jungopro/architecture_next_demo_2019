## Query ##

data "azurerm_client_config" "current" {
}

## Create

resource "azurerm_resource_group" "resource_group" {
  name     = "aks"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet_name}-${terraform.workspace}"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = var.vnet_address_space

  tags = {
    environment = "aks"
  }
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "${var.aks_subnet_name}-${terraform.workspace}"
  resource_group_name  = azurerm_resource_group.resource_group.name
  address_prefix       = var.aks_subnet_address
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_subnet" "vk_subnet" {
  name                 = "${var.vk_subnet_name}-${terraform.workspace}"
  resource_group_name  = azurerm_resource_group.resource_group.name
  address_prefix       = var.vk_subnet_address
  virtual_network_name = azurerm_virtual_network.vnet.name

  delegation {
    name = "aciDelegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.cluster_name}-${terraform.workspace}"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  dns_prefix          = var.cluster_name
  kubernetes_version  = var.kubernetes_version

  agent_pool_profile {
    name            = "default"
    count           = var.node_count
    vm_size         = "Standard_DS2_v2"
    os_type         = "Linux"
    os_disk_size_gb = 30
    max_pods        = var.max_pods
    vnet_subnet_id  = azurerm_subnet.aks_subnet.id
  }

  network_profile {
    network_plugin = "azure"
  }

  service_principal {
    client_id     = data.azurerm_client_config.current.client_id
    client_secret = var.client_secret
  }

  role_based_access_control {
    enabled = true
  }

  addon_profile {
    aci_connector_linux {
      enabled     = true
      subnet_name = azurerm_subnet.vk_subnet.name
    }
  }

  tags = {
    Environment = "aks"
  }
}

