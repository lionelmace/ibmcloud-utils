##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "Redis instance id"
  value       = module.icd_redis.id
}

output "version" {
  description = "Redis instance version"
  value       = module.icd_redis.version
}

output "guid" {
  description = "Redis instance guid"
  value       = module.icd_redis.guid
}

output "service_credentials_json" {
  description = "Service credentials json map"
  value       = module.icd_redis.service_credentials_json
  sensitive   = true
}

output "service_credentials_object" {
  description = "Service credentials object"
  value       = module.icd_redis.service_credentials_object
  sensitive   = true
}

output "hostname" {
  description = "Redis instance hostname"
  value       = module.icd_redis.hostname
}

output "port" {
  description = "Redis instance port"
  value       = module.icd_redis.port
}