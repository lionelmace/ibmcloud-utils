
##############################################################################
# COS Service for OpenShift Internal Registry
##############################################################################

module "cos" {
  source = "terraform-ibm-modules/cos/ibm//modules/instance"

  resource_group_id = ibm_resource_group.resource_group.id
  service_name      = "${var.prefix}-openshift-registry"
  plan              = var.cos_plan
  region            = var.cos_region
  tags              = var.tags
  key_tags          = var.tags
  # service_endpoints = var.service_endpoints
  # resource_key_name = var.resource_key_name
  # role              = var.role
  # bind_resource_key = var.bind_resource_key
  # key_parameters    = var.key_parameters
}

output "cos_instance_crn" {
  description = "The CRN of the COS instance"
  value       = module.cos.cos_instance_id
}