resource "ibm_cr_namespace" "container-registry-namespace" {
  name              = format("%s-%s", local.basename, "registry")
  resource_group_id = local.resource_group_id
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
  resource_group = local.resource_group_id
  vpc            = ibm_is_vpc.vpc.id

  target {
    crn           = "crn:v1:bluemix:public:container-registry:${var.region}:::endpoint:${var.icr_region}"
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
    resource_group_id = local.resource_group_id
    resource_type     = "namespace"
    resource          = ibm_cr_namespace.container-registry-namespace.name
  }
}