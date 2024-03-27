output "azapi_resource_sql_instance_pool_id" {
  value       = azapi_resource.this.id
  description = "The full ID of the SQL Instance Pool."
}

output "azapi_resource_sql_instance_pool_name" {
  value       = azapi_resource.this.name
  description = "The name of the SQL Instance Pool."
}
