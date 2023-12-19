resource "ibm_cr_namespace" "container-registry-namespace" {
  name              = format("%s-%s", local.basename, "registry")
  resource_group_id = ibm_resource_group.group.id
  tags              = var.tags
}

variable "icr_use_vpe" { default = true }

# locals {
#   endpoints = [
#     {
#       name     = "mongo",
#       crn      = ibm_cr_namespace.container-registry-namespace.id
#       hostname = ibm_resource_key.icd_mongo_key.credentials["connection.mongodb.hosts.0.hostname"]
#     }
#   ]
# }

# output "endpoints" {
#   sensitive = true
#   value     = local.endpoints
# }

# VPE (Virtual Private Endpoint) for Container Registry
##############################################################################

resource "ibm_is_virtual_endpoint_gateway" "vpe_icr" {
  # for_each = { for target in local.endpoints : target.name => target if tobool(var.icr_use_vpe) }

  name           = "${local.basename}-icr-vpe"
  resource_group = ibm_resource_group.group.id
  vpc            = ibm_is_vpc.vpc.id

  target {
    crn           = ibm_cr_namespace.container-registry-namespace.crn
    resource_type = "provider_cloud_service"
  }

  # one Reserved IP for per zone in the VPC
  dynamic "ips" {
    for_each = { for subnet in ibm_is_subnet.subnet : subnet.id => subnet }
    content {
      subnet = ips.key
      name   = "${ips.value.name}-ip"
    }
  }

  tags = var.tags
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