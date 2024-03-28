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

# This is the module call
module "sql_instance_pool" {
  source              = "../../"
  name                = module.naming.mssql_managed_instance.name_unique
  enable_telemetry    = true
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  resource_group_id   = azurerm_resource_group.this.id
  create_new_vnet     = true
  create_new_subnet   = true
}
