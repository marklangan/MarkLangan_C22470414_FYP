output "resource_group_name" {
  value = azurerm_resource_group.fyp.name
}

output "acr_login_server" {
  value = azurerm_container_registry.fyp.login_server
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.fyp.name
}

output "aks_kubelet_object_id" {
  description = "Object ID of the AKS kubelet managed identity"
  value       = azurerm_kubernetes_cluster.fyp.kubelet_identity[0].object_id
}