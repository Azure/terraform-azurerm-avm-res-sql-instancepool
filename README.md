<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-avm-res-sql-instancepool

Module to deploy a SQL Managed Instance Pool in Azure. Note this module does not deploy a managed instance, just the instance pool.

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.0.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.71.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 3.5.0)

## Providers

The following providers are used by this module:

- <a name="provider_azapi"></a> [azapi](#provider\_azapi)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 3.71.0)

- <a name="provider_random"></a> [random](#provider\_random) (>= 3.5.0)

## Resources

The following resources are used by this module:

- [azapi_resource.this](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) (resource)
- [azurerm_network_security_rule.allow_health_probe_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) (resource)
- [azurerm_network_security_rule.allow_management_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) (resource)
- [azurerm_network_security_rule.allow_management_outbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) (resource)
- [azurerm_network_security_rule.allow_misubnet_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) (resource)
- [azurerm_network_security_rule.allow_misubnet_outbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) (resource)
- [azurerm_network_security_rule.allow_tds_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) (resource)
- [azurerm_network_security_rule.deny_all_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) (resource)
- [azurerm_network_security_rule.deny_all_outbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) (resource)
- [azurerm_resource_group_template_deployment.telemetry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) (resource)
- [azurerm_route_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) (resource)
- [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) (resource)
- [azurerm_subnet_route_table_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) (resource)
- [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)
- [random_id.telem](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) (resource)
- [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: The location/region where the database and server are created. Changing this forces a new resource to be created.

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: The name of SQL Instance Pool to be created.

Type: `string`

### <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id)

Description: The resource group id the resources will be deployed.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource group where the resources will be deployed.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_azurerm_network_security_group_name"></a> [azurerm\_network\_security\_group\_name](#input\_azurerm\_network\_security\_group\_name)

Description: The name of the network security group.

Type: `string`

Default: `"mi-security-group"`

### <a name="input_azurerm_route_table_name"></a> [azurerm\_route\_table\_name](#input\_azurerm\_route\_table\_name)

Description: The name of route table to be created.

Type: `string`

Default: `"routetable-mi"`

### <a name="input_azurerm_sql_instance_pool_family"></a> [azurerm\_sql\_instance\_pool\_family](#input\_azurerm\_sql\_instance\_pool\_family)

Description: The compute hardware that will run your Azure SQL Managed Instances in the pool.

Type: `string`

Default: `"Gen5"`

### <a name="input_azurerm_sql_instance_pool_license_type"></a> [azurerm\_sql\_instance\_pool\_license\_type](#input\_azurerm\_sql\_instance\_pool\_license\_type)

Description: The licence type for the SQL Instance Pool.

Type: `string`

Default: `"BasePrice"`

### <a name="input_azurerm_sql_instance_pool_service_tier"></a> [azurerm\_sql\_instance\_pool\_service\_tier](#input\_azurerm\_sql\_instance\_pool\_service\_tier)

Description: Select from the latest vCore service tiers available for Azure SQL Managed Instances in the pool.

Type: `string`

Default: `"GeneralPurpose"`

### <a name="input_azurerm_sql_instance_pool_sku_name"></a> [azurerm\_sql\_instance\_pool\_sku\_name](#input\_azurerm\_sql\_instance\_pool\_sku\_name)

Description: The SKU name for the SQL Instance Pool

Type: `string`

Default: `"GP_Gen5"`

### <a name="input_azurerm_sql_instance_pool_subnet_address_prefixes"></a> [azurerm\_sql\_instance\_pool\_subnet\_address\_prefixes](#input\_azurerm\_sql\_instance\_pool\_subnet\_address\_prefixes)

Description: The IP address range of the instance pool subnet.

Type: `string`

Default: `"10.0.0.0/24"`

### <a name="input_azurerm_sql_instance_pool_subnet_name"></a> [azurerm\_sql\_instance\_pool\_subnet\_name](#input\_azurerm\_sql\_instance\_pool\_subnet\_name)

Description: The name of subnet in which the instance poll will be created.

Type: `string`

Default: `"subnet-mi"`

### <a name="input_azurerm_sql_instance_pool_vcores"></a> [azurerm\_sql\_instance\_pool\_vcores](#input\_azurerm\_sql\_instance\_pool\_vcores)

Description: The number of vCores for the SQL Instance Pool.

Type: `number`

Default: `8`

### <a name="input_azurerm_virtual_network_address_space"></a> [azurerm\_virtual\_network\_address\_space](#input\_azurerm\_virtual\_network\_address\_space)

Description: The IP address range of the virtual network.

Type: `string`

Default: `"10.0.0.0/16"`

### <a name="input_azurerm_virtual_network_name"></a> [azurerm\_virtual\_network\_name](#input\_azurerm\_virtual\_network\_name)

Description: The name of the virtual network.

Type: `string`

Default: `"vnet-mi"`

### <a name="input_create_new_subnet"></a> [create\_new\_subnet](#input\_create\_new\_subnet)

Description: Flag to indicate whether to create a new VNet or reference an existing one.

Type: `bool`

Default: `true`

### <a name="input_create_new_vnet"></a> [create\_new\_vnet](#input\_create\_new\_vnet)

Description: Flag to indicate whether to create a new VNet or reference an existing one.

Type: `bool`

Default: `true`

### <a name="input_diagnostic_settings"></a> [diagnostic\_settings](#input\_diagnostic\_settings)

Description:   A map of diagnostic settings to create on the SQL Instance Pool. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

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

Type:

```hcl
map(object({
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
```

Default: `{}`

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description:   This variable controls whether or not telemetry is enabled for the module.  
  For more information see https://aka.ms/avm/telemetryinfo.  
  If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_existing_subnet_id"></a> [existing\_subnet\_id](#input\_existing\_subnet\_id)

Description: Pass in the id of the existing subnet.

Type: `string`

Default: `""`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: (Optional) A mapping of tags to assign to the resource.

Type: `map(string)`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_azapi_resource_sql_instance_pool_id"></a> [azapi\_resource\_sql\_instance\_pool\_id](#output\_azapi\_resource\_sql\_instance\_pool\_id)

Description: The full ID of the SQL Instance Pool.

### <a name="output_azapi_resource_sql_instance_pool_name"></a> [azapi\_resource\_sql\_instance\_pool\_name](#output\_azapi\_resource\_sql\_instance\_pool\_name)

Description: The name of the SQL Instance Pool.

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->
