##############################################################################
## Key Protect
##############################################################################
resource "ibm_resource_instance" "key-protect" {
  resource_group_id = local.resource_group_id
  name              = format("%s-%s", local.basename, "key-protect")
  service           = "kms"
  plan              = "tiered-pricing"
  location          = var.region
  tags              = var.tags
  service_endpoints = "private"
}

resource "ibm_kms_instance_policies" "instance_policy" {
  instance_id = ibm_resource_instance.key-protect.guid
  rotation {
    enabled        = true
    interval_month = 3
  }
  # A instance with dual authorization policy enabled cannot be destroyed by using Terraform.
  dual_auth_delete {
    enabled = false
  }
  metrics {
    enabled = true
  }
  key_create_import_access {
    enabled = true
  }
}

resource "ibm_kms_key" "key" {
  instance_id  = ibm_resource_instance.key-protect.guid
  key_name     = "${local.basename}-root-key"
  standard_key = false
  force_delete = true
}

resource "ibm_kms_key_policies" "key_policy" {
  instance_id = ibm_resource_instance.key-protect.guid
  key_id      = ibm_kms_key.key.key_id
  rotation {
    enabled        = true
    interval_month = 3
  }
  # A instance with dual authorization policy enabled cannot be destroyed by using Terraform.
  dual_auth_delete {
    enabled = false
  }
}


## IAM
##############################################################################

resource "ibm_iam_access_group_policy" "iam-kms" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Reader", "Viewer"]

  resources {
    service           = "kms"
    resource_group_id = local.resource_group_id
  }
}
