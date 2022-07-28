
##############################################################################
# Monitoring Services
##############################################################################

module "monitoring_instance" {
  source = "terraform-ibm-modules/observability/ibm//modules/monitoring-sysdig"

  resource_group_id       = ibm_resource_group.resource_group.id
  name                    = "${var.prefix}-monitoring"
  plan                    = var.sysdig_plan
  service_endpoints       = var.sysdig_service_endpoints
  enable_platform_metrics = var.sysdig_enable_platform_metrics
  bind_key                = var.sysdig_bind_key
  key_name                = var.sysdig_key_name
  region                  = var.region
  tags                    = var.tags
  key_tags                = var.tags
}

output "monitoring_instance_id" {
  description = "The ID of the Cloud Monitoring instance"
  value       = module.monitoring_instance.id
}