provider "azurerm" {
  features {}
}

# We need the tenant id for the key vault.
data "azurerm_client_config" "this" {}

# This allows us to randomize the region for the resource group.
module "regions" {
  source  = "Azure/regions/azurerm"
  version = ">= 0.3.0"
}

# This allows us to randomize the region for the resource group.
resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.0"
}

resource "azurerm_resource_group" "this" {
  location = module.regions.regions[random_integer.region_index.result].name
  name     = module.naming.resource_group.name_unique
}

resource "azurerm_virtual_network" "this" {
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.this.location
  name                = module.naming.virtual_network.name_unique
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "this" {
  address_prefixes     = ["10.0.0.0/24"]
  name                 = module.naming.subnet.name_unique
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name

  delegation {
    name = "managedinstancedelegation"

    service_delegation {
      name    = "Microsoft.Sql/managedInstances"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
    }
  }
}

# This is the module call
module "sql_instance_pool" {
  source                                = "../../"
  name                                  = module.naming.mssql_managed_instance.name_unique
  enable_telemetry                      = true
  location                              = azurerm_resource_group.this.location
  resource_group_name                   = azurerm_resource_group.this.name
  resource_group_id                     = azurerm_resource_group.this.id
  create_new_vnet                       = false
  create_new_subnet                     = false
  existing_subnet_id                    = azurerm_subnet.this.id
  azurerm_sql_instance_pool_subnet_name = azurerm_subnet.this.name
  azurerm_virtual_network_name          = azurerm_virtual_network.this.name
}
