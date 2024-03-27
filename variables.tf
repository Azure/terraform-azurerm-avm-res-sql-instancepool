variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}

variable "resource_group_id" {
  type        = string
  description = "The resource group id the resources will be deployed."
}

variable "location" {
  type        = string
  description = "The location/region where the database and server are created. Changing this forces a new resource to be created."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) A mapping of tags to assign to the resource."
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
  This variable controls whether or not telemetry is enabled for the module.
  For more information see https://aka.ms/avm/telemetryinfo.
  If it is set to false, then no telemetry will be collected.
  DESCRIPTION
}

variable "diagnostic_settings" {
  type = map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
  A map of diagnostic settings to create on the SQL Instance Pool. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

  - `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources.
  - `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
  - `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
  - `metric_categories` - (Optional) A set of metric categories to send to the log analytics workspace. Defaults to `["AllMetrics"]`.
  - `log_analytics_destination_type` - (Optional) The destination type for the diagnostic setting. Possible values are `Dedicated` and `AzureDiagnostics`. Defaults to `Dedicated`.
  - `workspace_resource_id` - (Optional) The resource ID of the log analytics workspace to send logs and metrics to.
  - `storage_account_resource_id` - (Optional) The resource ID of the storage account to send logs and metrics to.
  - `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the event hub authorization rule to send logs and metrics to.
  - `event_hub_name` - (Optional) The name of the event hub. If none is specified, the default event hub will be selected.
  - `marketplace_partner_resource_id` - (Optional) The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic LogsLogs.
  DESCRIPTION
  nullable    = false

  validation {
    condition     = alltrue([for _, v in var.diagnostic_settings : contains(["Dedicated", "AzureDiagnostics"], v.log_analytics_destination_type)])
    error_message = "Log analytics destination type must be one of: 'Dedicated', 'AzureDiagnostics'."
  }
  validation {
    condition = alltrue(
      [
        for _, v in var.diagnostic_settings :
        v.workspace_resource_id != null || v.storage_account_resource_id != null || v.event_hub_authorization_rule_resource_id != null || v.marketplace_partner_resource_id != null
      ]
    )
    error_message = "At least one of `workspace_resource_id`, `storage_account_resource_id`, `marketplace_partner_resource_id`, or `event_hub_authorization_rule_resource_id`, must be set."
  }
}

variable "azurerm_network_security_group_name" {
  type        = string
  default     = "mi-security-group"
  description = "The name of the network security group."
}

variable "create_new_vnet" {
  type        = bool
  default     = true
  description = "Flag to indicate whether to create a new VNet or reference an existing one."
}

variable "azurerm_virtual_network_name" {
  type        = string
  default     = "vnet-mi"
  description = "The name of the virtual network."
}

variable "azurerm_virtual_network_address_space" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The IP address range of the virtual network."
}

variable "create_new_subnet" {
  type        = bool
  default     = true
  description = "Flag to indicate whether to create a new VNet or reference an existing one."
}

variable "existing_subnet_id" {
  type        = string
  default     = ""
  description = "Pass in the id of the existing subnet."
}

variable "azurerm_sql_instance_pool_subnet_name" {
  type        = string
  default     = "subnet-mi"
  description = "The name of subnet in which the instance poll will be created."
}

variable "azurerm_sql_instance_pool_subnet_address_prefixes" {
  type        = string
  default     = "10.0.0.0/24"
  description = "The IP address range of the instance pool subnet."
}

variable "azurerm_route_table_name" {
  type        = string
  default     = "routetable-mi"
  description = "The name of route table to be created."
}

variable "name" {
  type        = string
  description = "The name of SQL Instance Pool to be created."

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9\\-]{0,61}[a-z0-9]$", var.name))
    error_message = "The name must only contain lowercase letters, numbers and hyphen (no hyphen at the start)."
  }
}

variable "azurerm_sql_instance_pool_sku_name" {
  type        = string
  default     = "GP_Gen5"
  description = "The SKU name for the SQL Instance Pool"
  validation {
    condition     = can(contains(["GP_Gen5", "GP_G8IM", "GP_G8IH", "BC_Gen5", "BC_G8IM", "BC_G8IH"], var.azurerm_sql_instance_pool_sku_name))
    error_message = "Wrong value for the SQL Instance Pool SKU name."
  }
}

variable "azurerm_sql_instance_pool_license_type" {
  type        = string
  default     = "BasePrice"
  description = "The licence type for the SQL Instance Pool."
  validation {
    condition     = can(contains(["BasePrice", "LicenseIncluded"], var.azurerm_sql_instance_pool_license_type))
    error_message = "Wrong value for the SQL Instance Pool license type."
  }
}

variable "azurerm_sql_instance_pool_vcores" {
  type        = number
  default     = 8
  description = "The number of vCores for the SQL Instance Pool."
  validation {
    condition     = can(contains([8, 16, 24, 32, 40, 64, 80], var.azurerm_sql_instance_pool_vcores))
    error_message = "Wrong value for numbe of vCore. Allowed values: 8, 16, 24, 32, 40, 64, 80."
  }
}

variable "azurerm_sql_instance_pool_family" {
  type        = string
  default     = "Gen5"
  description = "The compute hardware that will run your Azure SQL Managed Instances in the pool."
}

variable "azurerm_sql_instance_pool_service_tier" {
  type        = string
  default     = "GeneralPurpose"
  description = "Select from the latest vCore service tiers available for Azure SQL Managed Instances in the pool."
}

