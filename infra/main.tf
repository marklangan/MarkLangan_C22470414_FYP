# 1. Resource group
resource "azurerm_resource_group" "fyp" {
  name     = "rg-fyp-cicd-fr"
  location = "francecentral"
}

# 2. Azure Container Registry
resource "azurerm_container_registry" "fyp" {
  name                = "fypcicdregistrymarkl"         
  resource_group_name = azurerm_resource_group.fyp.name
  location            = azurerm_resource_group.fyp.location
  sku                 = "Basic"
  admin_enabled       = true
}

# 3. AKS cluster
resource "azurerm_kubernetes_cluster" "fyp" {
  name                = "aks-fyp-fr"
  location            = azurerm_resource_group.fyp.location
  resource_group_name = azurerm_resource_group.fyp.name
  dns_prefix          = "fypaksdns"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }
}
