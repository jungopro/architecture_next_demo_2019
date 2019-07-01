## Vars

variable "client_secret" {
}

variable "location" {
  description = "Azure Location"
  default = "West Europe"
}


variable "kubeconfig_path" {
  description = "full path to save the kubeconfig in (e.g. /root/.kube/mycluster.yaml). make sure to add this file to KUBECONFIG (e.g. export KUBECONFIG=$KUBECONFIG:/root/.kube/mycluster.yaml) in order to add it to your list of clusters"
}

variable "node_count" {
  description = "the number of worker nodes in the pool"
  default     = 2
}

variable "gpu_node_count" {
  description = "the number of worker nodes in the pool"
  default     = 2
}

variable "max_pods" {
  description = "The maximum number of pods that can run on each agent"
  default     = 30
}

variable "aks_vnet_name" {
  description = "the name of the vnet for the aks cluster"
  default     = "aks"
}

variable "aks_subnet_name" {
  description = "the name of the subnet for the aks nodes"
  default     = "aks-subnet"
}

variable "vk_subnet_name" {
  description = "the name of the subnet for the virtual kubelet"
  default     = "vk-subnet"
}

variable "vnet_name" {
  description = "the name of the vnet"
  default     = "aks-vnet"
}

variable "vnet_address_space" {
  description = "list of address spaces for the vnet"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable "aks_subnet_address" {
  description = "the network address for the aks subnet"
  default     = "10.240.0.0/24"
}

variable "vk_subnet_address" {
  description = "the network address for the aks subnet"
  default     = "10.241.0.0/24"
}

variable "cluster_name" {
  description = "the name of the aks cluster. also the dns prefix"
  default     = "playks"
}

variable "kubernetes_version" {
  description = "the kubernetes version to use"
  default     = "1.13.5"
}

