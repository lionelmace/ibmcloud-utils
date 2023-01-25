resource "ibm_cr_namespace" "cr-namespace" {
  name              = format("%s-%s", var.prefix, "registry")
  resource_group_id = ibm_resource_group.resource_group.id
  tags              = var.tags
}

## IAM
##############################################################################
# Role Writer supports both Pull and Push
resource "ibm_iam_access_group_policy" "iam-registry" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Viewer", "Writer"]

  resources {
    service           = "container-registry"
    resource_group_id = ibm_resource_group.resource_group.id
    resource_type     = "namespace"
    resource          = ibm_cr_namespace.cr-namespace.name
  }
}