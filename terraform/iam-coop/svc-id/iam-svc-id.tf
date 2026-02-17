# Create Access Group
resource "ibm_iam_access_group" "ag-admin" {
  name = format("%s-%s", local.basename, "ag-admin")
  tags = var.tags
}

resource "ibm_iam_service_id" "svc-id" {
  name        = format("%s-%s", local.basename, "svc-id")
  description = "New ServiceID"
}

# Service: All Account Management Services
resource "ibm_iam_service_policy" "policy-account-management" {
  iam_id = ibm_iam_service_id.svc-id.iam_id
  roles          = ["Administrator"]
  resource_attributes {
    name     = "serviceType"
    operator = "stringEquals"
    value    = "platform_service"
  }
}

# Service: IAM Identity Service
resource "ibm_iam_service_policy" "identity-service" {
  iam_id = ibm_iam_service_id.svc-id.iam_id
  roles          = ["Administrator", "User API key creator", "Service ID creator"]
  resource_attributes {
    name     = "serviceName"
    operator = "stringEquals"
    value    = "iam-identity"
  }
}
