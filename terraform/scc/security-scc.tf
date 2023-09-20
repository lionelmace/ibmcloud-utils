## SCC Profile Attachment
##############################################################################
resource "ibm_scc_profile_attachment" "scc_profile_attachment_instance" {
  # CIS IBM Foundations Benchmark v1.0.0
  name       = format("%s-%s", local.basename, "cis")
  profile_id = "a0bd1ee2-1ed3-407e-a2f4-ce7a1a38f54d"
  scope {
    environment = ""
    properties {
      name = ""
      value = ""
    }
  }
  notifications {
    controls {
      failed_control_ids = [""]
      threshold_limit = 0
    }
    enabled = false
  }
  schedule = "daily"
  status   = "enabled"
}


## IAM
##############################################################################
resource "ibm_iam_access_group_policy" "iam-scc" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Reader", "Viewer"]

  resources {
    service           = "compliance"
    resource_group_id = ibm_resource_group.group.id
  }
}
