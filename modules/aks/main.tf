# resource
# data
# locals [local]
# variables
# resource "<tipo_de_recurso>" "<id-que-le-damos>"
resource "azurerm_resource_group" "default" {
  name = var.app_name
  location = var.location
  tags = {}
}

resource "azurerm_virtual_network" "vnet" {
  address_space       = ["10.0.0.0/8"]
  location            = var.location
  name                = "default"
  resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_subnet" "private" {
  name                 = "${local.new_name}-private"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "public" {
  name                 = "${local.new_name}-public-subnet"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.2.0.0/16"]
}

resource "azurerm_public_ip" "ingress" {
  allocation_method   = "Static"
  location            = var.location
  sku = "Standard"
  name                = "${local.new_name}-ingress-lb"
  resource_group_name = azurerm_resource_group.default.name
  availability_zone = "No-Zone"
}

resource "azurerm_public_ip" "egress" {
  allocation_method   = "Static"
  location            = var.location
  sku = "Standard"
  name                = "${local.new_name}-egress-lb"
  resource_group_name = azurerm_resource_group.default.name
  availability_zone = "No-Zone"
}


resource "azurerm_kubernetes_cluster" "default" {
  location            = var.location
  name                = "${local.new_name}-aks"
  resource_group_name = azurerm_resource_group.default.name
  node_resource_group = "${azurerm_resource_group.default.name}-nodes"
  kubernetes_version = var.aks.version
  dns_prefix = local.new_name

  default_node_pool {
    name    = "default"
    vm_size = var.aks.size
    node_count = var.aks.node_count
    availability_zones = var.aks.availability_zones
    orchestrator_version = var.aks.version
    vnet_subnet_id = azurerm_subnet.private.id
  }

  network_profile {
    network_plugin = "kubenet"
    load_balancer_sku = "Standard"

    load_balancer_profile {
      outbound_ip_address_ids = [azurerm_public_ip.egress.id]
      ## Si se requiere alocar más que el default de puertos por nodo. No debe superar los 64k.
#      outbound_ports_allocated = floor(64000 / (var.aks.node_count + 2) / 8) * 8
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

# Nginx y service requirement
resource "azurerm_role_assignment" "aks_identity_networking" {
  principal_id = azurerm_kubernetes_cluster.default.identity.0.principal_id
  scope        = azurerm_resource_group.default.id
  role_definition_name = "Network Contributor"
}

# ACR Permissions
#resource "azurerm_role_assignment" "aks_identity_acr" {
#  principal_id = azurerm_kubernetes_cluster.default.identity.0.principal_id
#  scope        = azurerm_container_registry.<name>.id
#  role_definition_name = "AcrPull"
#}
