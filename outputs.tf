output "azapi_resource_sql_instance_pool_id" {
  description = "The full ID of the SQL Instance Pool."
  value       = azapi_resource.this.id
}

output "azapi_resource_sql_instance_pool_name" {
  description = "The name of the SQL Instance Pool."
  value       = azapi_resource.this.name
}
