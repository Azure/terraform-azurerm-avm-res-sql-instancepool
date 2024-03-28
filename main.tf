resource "azurerm_network_security_group" "this" {
  location            = var.location
  name                = var.azurerm_network_security_group_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "allow_management_inbound" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "allow_management_inbound"
  network_security_group_name = azurerm_network_security_group.this.name
  priority                    = 106
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  destination_address_prefix  = "*"
  destination_port_ranges     = ["9000", "9003", "1438", "1440", "1452"]
  source_address_prefix       = "*"
  source_port_range           = "*"
}

resource "azurerm_network_security_rule" "allow_misubnet_inbound" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "allow_misubnet_inbound"
  network_security_group_name = azurerm_network_security_group.this.name
  priority                    = 200
  protocol                    = "*"
  resource_group_name         = var.resource_group_name
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/24"
  source_port_range           = "*"
}

resource "azurerm_network_security_rule" "allow_health_probe_inbound" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "allow_health_probe_inbound"
  network_security_group_name = azurerm_network_security_group.this.name
  priority                    = 300
  protocol                    = "*"
  resource_group_name         = var.resource_group_name
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  source_port_range           = "*"
}

resource "azurerm_network_security_rule" "allow_tds_inbound" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "allow_tds_inbound"
  network_security_group_name = azurerm_network_security_group.this.name
  priority                    = 1000
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  destination_address_prefix  = "*"
  destination_port_range      = "1433"
  source_address_prefix       = "VirtualNetwork"
  source_port_range           = "*"
}

resource "azurerm_network_security_rule" "deny_all_inbound" {
  access                      = "Deny"
  direction                   = "Inbound"
  name                        = "deny_all_inbound"
  network_security_group_name = azurerm_network_security_group.this.name
  priority                    = 4096
  protocol                    = "*"
  resource_group_name         = var.resource_group_name
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  source_port_range           = "*"
}

resource "azurerm_network_security_rule" "allow_management_outbound" {
  access                      = "Allow"
  direction                   = "Outbound"
  name                        = "allow_management_outbound"
  network_security_group_name = azurerm_network_security_group.this.name
  priority                    = 102
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  destination_address_prefix  = "*"
  destination_port_ranges     = ["80", "443", "12000"]
  source_address_prefix       = "*"
  source_port_range           = "*"
}

resource "azurerm_network_security_rule" "allow_misubnet_outbound" {
  access                      = "Allow"
  direction                   = "Outbound"
  name                        = "allow_misubnet_outbound"
  network_security_group_name = azurerm_network_security_group.this.name
  priority                    = 200
  protocol                    = "*"
  resource_group_name         = var.resource_group_name
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/24"
  source_port_range           = "*"
}

resource "azurerm_network_security_rule" "deny_all_outbound" {
  access                      = "Deny"
  direction                   = "Outbound"
  name                        = "deny_all_outbound"
  network_security_group_name = azurerm_network_security_group.this.name
  priority                    = 4096
  protocol                    = "*"
  resource_group_name         = var.resource_group_name
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  source_port_range           = "*"
}

resource "azurerm_virtual_network" "this" {
  count = var.create_new_vnet ? 1 : 0

  address_space       = [var.azurerm_virtual_network_address_space]
  location            = var.location
  name                = var.azurerm_virtual_network_name
  resource_group_name = var.resource_group_name
}

data "azurerm_virtual_network" "this" {
  count = var.create_new_vnet ? 0 : 1

  name                = var.azurerm_virtual_network_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "this" {
  count = var.create_new_subnet ? 1 : 0

  address_prefixes     = [var.azurerm_sql_instance_pool_subnet_address_prefixes]
  name                 = var.azurerm_sql_instance_pool_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.azurerm_virtual_network_name

  delegation {
    name = "managedinstancedelegation"

    service_delegation {
      name    = "Microsoft.Sql/managedInstances"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  network_security_group_id = azurerm_network_security_group.this.id
  subnet_id                 = local.subnet_id
}

resource "azurerm_route_table" "this" {
  location                      = var.location
  name                          = var.azurerm_route_table_name
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = false
}

resource "azurerm_subnet_route_table_association" "this" {
  route_table_id = azurerm_route_table.this.id
  subnet_id      = local.subnet_id
}

resource "azapi_resource" "this" {
  type = "Microsoft.Sql/instancePools@2023-05-01-preview"
  body = jsonencode({
    properties = {
      licenseType = var.azurerm_sql_instance_pool_license_type
      subnetId    = local.subnet_id
      vCores      = var.azurerm_sql_instance_pool_vcores
    }
    sku = {
      family = var.azurerm_sql_instance_pool_family
      name   = var.azurerm_sql_instance_pool_sku_name
      tier   = var.azurerm_sql_instance_pool_service_tier
    }
  })
  location  = var.location
  name      = var.name
  parent_id = var.resource_group_id
  tags      = var.tags

  timeouts {
    create = "1h30m"
    delete = "1h30m"
    update = "60m"
  }
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = var.diagnostic_settings

  name                           = each.value.name != null ? each.value.name : "diag-${var.name}"
  target_resource_id             = azapi_resource.this.id
  eventhub_authorization_rule_id = each.value.event_hub_authorization_rule_resource_id
  eventhub_name                  = each.value.event_hub_name
  log_analytics_destination_type = each.value.log_analytics_destination_type
  log_analytics_workspace_id     = each.value.workspace_resource_id
  partner_solution_id            = each.value.marketplace_partner_resource_id
  storage_account_id             = each.value.storage_account_resource_id

  dynamic "enabled_log" {
    for_each = each.value.log_categories
    content {
      category = enabled_log.value
    }
  }
  dynamic "enabled_log" {
    for_each = each.value.log_groups
    content {
      category_group = enabled_log.value
    }
  }
  dynamic "metric" {
    for_each = each.value.metric_categories
    content {
      category = metric.value
    }
  }
}

locals {
  subnet_id = var.create_new_subnet ? azurerm_subnet.this[0].id : var.existing_subnet_id
}

