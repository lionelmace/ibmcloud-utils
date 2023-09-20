# Account ID is required for CBR Rule and Zone
data "ibm_iam_account_settings" "account_settings" {
}

locals {
  account_id = data.ibm_iam_account_settings.account_settings.account_id
}

## SCC Instance
##############################################################################
resource "ibm_resource_instance" "scc_instance" {
  name              = format("%s-%s", local.basename, "scc")
  service           = "compliance"
  plan              = "security-compliance-center-standard-plan"
  location          = var.region
  resource_group_id = ibm_resource_group.group.id
}

## SCC Profile Attachment
##############################################################################
resource "ibm_scc_profile_attachment" "scc_profile_attachment_instance" {
  name       = format("%s-%s", local.basename, "cis")
  profile_id = "a0bd1ee2-1ed3-407e-a2f4-ce7a1a38f54d" # CIS IBM Foundations v1.0.0
  scope {
    environment = "ibm-cloud"
    properties {
      name = "scope_id"
      value = local.account_id
    }
    properties {
      name  = "scope_type"
      value = "account"
    }
    # properties {
    #   name = "exclusions"
    #   value = []
    # }
  }
  schedule = "daily"
  status   = "enabled"
  notifications {
    enabled = false
    controls {
      failed_control_ids = []
      threshold_limit    = 14
    }
  }
}


## IAM
##############################################################################
# resource "ibm_iam_access_group_policy" "iam-scc" {
#   access_group_id = ibm_iam_access_group.accgrp.id
#   roles           = ["Reader", "Viewer"]

#   resources {
#     service           = "compliance"
#     resource_group_id = ibm_resource_group.group.id
#   }
# }
