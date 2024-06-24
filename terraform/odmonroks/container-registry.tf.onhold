resource "ibm_cr_namespace" "container-registry-namespace" {
  name              = format("%s-%s", local.basename, "registry")
  resource_group_id = ibm_resource_group.group.id
  tags              = var.tags
}

output "icr-namespace" {
  value = ibm_cr_namespace.container-registry-namespace.crn
}

variable "icr_use_vpe" { default = true }

# VPE (Virtual Private Endpoint) for Container Registry
##############################################################################

resource "ibm_is_virtual_endpoint_gateway" "vpe_icr" {

  name           = "${local.basename}-icr-vpe"
  resource_group = ibm_resource_group.group.id
  vpc            = ibm_is_vpc.vpc.id

  target {
    crn           = local.icr_target.crn
    resource_type = local.icr_target.resource_type
  }

  # one Reserved IP for per zone in the VPC
  dynamic "ips" {
    for_each = { for subnet in ibm_is_subnet.subnet : subnet.id => subnet }
    content {
      subnet = ips.key
      name   = "${ips.value.name}-ip-icr"
    }
  }

  tags = var.tags
}

# A VPE gateway requires a target. See the resource above.
# The data source for targets provides a set of targets that are available 
# based on your provider region configuration.
data "ibm_is_endpoint_gateway_targets" "example" {
}

locals {
  icr_target = data.ibm_is_endpoint_gateway_targets.example.resources[
  index(data.ibm_is_endpoint_gateway_targets.example.resources.*.name, "registry-eu-de-v2")]
}

output "icr_target_crn" {
  value = local.icr_target.crn
}

## IAM
##############################################################################
# Role Writer supports both Pull and Push
resource "ibm_iam_access_group_policy" "iam-registry" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Viewer", "Writer"]

  resources {
    service           = "container-registry"
    resource_group_id = ibm_resource_group.group.id
    resource_type     = "namespace"
    resource          = ibm_cr_namespace.container-registry-namespace.name
  }
}