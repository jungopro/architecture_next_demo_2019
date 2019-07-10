location = "west europe"

node_count = 2

gpu_node_count = 2

max_pods = 30

aks_rg_name = "aks"

aks_subnet_name = "aks-subnet"

vk_subnet_name = "vk-subnet"

vnet_name = "aks-vnet"

vnet_address_space = ["10.0.0.0/8"]

aks_subnet_address = "10.240.0.0/24"

vk_subnet_address = "10.241.0.0/24"

cluster_name = "playks"

kubernetes_version = "1.13.5"