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
  depends_on = [
    null_resource.set-scc-api-endpoint
  ]
}

resource "null_resource" "set-scc-api-endpoint" {
  provisioner "local-exec" {
   command = "IBMCLOUD_SCC_API_ENDPOINT=https://${var.region}.compliance.cloud.ibm.com/instances/${ibm_resource_instance.scc_instance.guid}/v3/"
  }
  depends_on = [
    ibm_resource_instance.scc_instance
  ]
}

output "IBMCLOUD_SCC_API_ENDPOINT" {
  description = "The SCC API ENDPOINT"
  value       = "export IBMCLOUD_SCC_API_ENDPOINT=https://${var.region}.compliance.cloud.ibm.com/instances/${ibm_resource_instance.scc_instance.guid}/v3/"
}

## Workaround to connect a COS bucket to the SCC instance
##############################################################################
data "ibm_iam_auth_token" "tokendata" {}

data "http" "scc_update_settings" {
  provider = http-full

  url    = "https://${ibm_resource_instance.scc_instance.location}.compliance.cloud.ibm.com/instances/${ibm_resource_instance.scc_instance.guid}/v3/settings"
  method = "PATCH"

  request_headers = {
    Authorization = data.ibm_iam_auth_token.tokendata.iam_access_token
    content-type  = "application/json"
  }

  request_body = jsonencode(
    {
      # event_notifications = {
      #   instance_crn = ibm_resource_instance.event_notifications.crn
      #   source_name  = "${ibm_resource_instance.compliance.name}-notifications"
      # },
      object_storage = {
        instance_crn = ibm_resource_instance.cos.crn
        bucket       = ibm_cos_bucket.scc-bucket.bucket_name
      }
    }
  )
}

data "http" "scc_get_settings" {
  provider = http-full

  url = "https://${ibm_resource_instance.scc_instance.location}.compliance.cloud.ibm.com/instances/${ibm_resource_instance.scc_instance.guid}/v3/settings"

  request_headers = {
    Authorization = data.ibm_iam_auth_token.tokendata.iam_access_token
    content-type  = "application/json"
  }

  depends_on = [data.http.scc_update_settings]
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
