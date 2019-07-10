output "dns_zone_name_servers" {
  value = azurerm_dns_zone.jungo.name_servers
}

output "kube_config_raw" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw 
}