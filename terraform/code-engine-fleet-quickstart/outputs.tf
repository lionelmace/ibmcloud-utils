########################################################################################################################
# Outputs
########################################################################################################################

output "resource_group_name" {
  description = "Resource group name."
  value       = module.resource_group.resource_group_name
}

output "code_engine_project_name" {
  description = "Code engine project name."
  value       = module.project.name
}

output "code_engine_project_id" {
  description = "Created code engine project identifier."
  value       = module.project.id
}

output "tasks_state_store_name" {
  description = "Name of the task state store."
  value       = local.bucket_store_map[local.taskstore_bucket_name]
}

output "cloud_logs_name" {
  description = "Name of the cloud logs instance."
  value       = var.enable_cloud_logs ? module.cloud_logs[0].name : null
}

output "cloud_logs_crn" {
  description = "CRN of the cloud logs instance."
  value       = var.enable_cloud_logs ? module.cloud_logs[0].crn : null
}

output "cloud_monitoring_crn" {
  description = "CRN of the cloud monitoring instance."
  value       = local.enable_cloud_monitoring ? module.cloud_monitoring[0].crn : null
}

output "cloud_monitoring_name" {
  description = "Name of the cloud monitoring instance."
  value       = local.enable_cloud_monitoring ? module.cloud_monitoring[0].name : null
}

output "cloud_object_storage_crn" {
  description = "Name of the cloud object storage instance."
  value       = module.cos.cos_instance_name
}

output "vpc_crn" {
  description = "CRN of the VPC."
  value       = module.vpc.vpc_crn
}

output "vpc_name" {
  description = "Name of the VPC."
  value       = module.vpc.vpc_name
}

output "next_steps_text" {
  value       = "Check your Code Engine project configuration."
  description = "Next steps text"
}

output "next_step_secondary_label" {
  value       = "Get Started – Serverless Fleet Docs"
  description = "Secondary label"
}

output "next_step_secondary_url" {
  value       = "https://cloud.ibm.com/docs/codeengine?topic=codeengine-cefleets"
  description = "Secondary url"
}

output "next_step_primary_label" {
  value       = "Go to Code Engine Project"
  description = "Primary label"
}

output "next_step_primary_url" {
  value       = "https://cloud.ibm.com/containers/serverless/project/${var.region}/${module.project.id}/overview"
  description = "primary url"
}