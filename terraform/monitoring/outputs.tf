output "monitoring_instance_id" {
  description = "The ID of the Cloud Monitoring instance"
  value       = ibm_resource_instance.monitoring_instance.id
}