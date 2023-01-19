resource "ibm_iam_access_group" "accgrp" {
  name = format("%s-%s", var.prefix, "ag")
  tags = var.tags
}

# Visibility on the Resource Group
resource "ibm_iam_access_group_policy" "iam-rg-viewer" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Viewer"]
  resources {
    resource_type = "resource-group"
    resource      = ibm_resource_group.resource_group.id
  }
}

# AUTHORIZATIONS

# Authorization policy between DBaaS and Key Protect
# Require to encrypt DBaaS with Key in Key Protect
# https://github.com/IBM-Cloud/vpc-scaling-dedicated-host/blob/master/modules/create_services/main.tf
resource "ibm_iam_authorization_policy" "posgresql-kms" {
  source_service_name         = "databases-for-postgresql"
  target_service_name         = "kms"
  target_resource_instance_id = ibm_resource_instance.key-protect.guid
  roles                       = ["Reader", "Authorization Delegator"]
}