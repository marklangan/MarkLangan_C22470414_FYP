# 1. Resource group
resource "azurerm_resource_group" "fyp" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# 2. Azure Container Registry
resource "azurerm_container_registry" "fyp" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.fyp.name
  location            = azurerm_resource_group.fyp.location
  sku                 = "Basic"
  admin_enabled       = false  # AKS uses managed identity (AcrPull) — no admin credentials needed
  tags                = var.tags
}

# 3. AKS cluster
resource "azurerm_kubernetes_cluster" "fyp" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.fyp.location
  resource_group_name = azurerm_resource_group.fyp.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = var.aks_node_count
    vm_size    = var.aks_vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# 4. Grant AKS kubelet identity the AcrPull role on ACR
#  Replaces the manual `az aks update --attach-acr` step
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.fyp.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.fyp.id
  skip_service_principal_aad_check = true
}
