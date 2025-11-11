output "resource_group_name" {
  value = azurerm_resource_group.fyp.name
}

output "acr_login_server" {
  value = azurerm_container_registry.fyp.login_server
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.fyp.name
}
