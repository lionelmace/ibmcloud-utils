
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
}

output "cos_instance_crn" {
  description = "The CRN of the COS instance"
  value       = module.cos.cos_instance_id
}