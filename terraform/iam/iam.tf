resource "ibm_iam_access_group" "ag-test" {
  name = "ag-test"
  tags = var.tags
}

# give access to account management we need to show to customers
# all need to handle that with care
# resource ibm_iam_access_group_policy account_management_policies {
#   access_group_id    = ibm_iam_access_group.ag-test.id
#   account_management = true
#   roles              = ["Administrator"]
# }

# Create access-group IAM policies
resource "ibm_iam_access_group_policy" "iam_create_user_api_key_service_id" {
  access_group_id = ibm_iam_access_group.ag-test.id
  roles           = ["User API key creator", "Service ID creator"]
  resources {
    service = "iam-identity"
  }
}

# Add visibility to the Resource Group
resource "ibm_iam_access_group_policy" "rg-visibility" {
  access_group_id = ibm_iam_access_group.ag-test.id
  roles           = ["Viewer"]
  resources {
    resource_type = "resource-group"
    resource      = ibm_resource_group.group.id
  }
}

# Service: Workspace for Power Virtual Server
# Role Editor is required to be able to create a PowerVS Workspace
# Platform Roles: Viewer, Editor
# Service  Roles: Reader, Manager 
resource "ibm_iam_access_group_policy" "policy-power-vs" {
  access_group_id = ibm_iam_access_group.ag-test.id
  resource_attributes {
    name     = "serviceName"
    operator = "stringEquals"
    value    = "power-iaas"
  }
  resource_attributes {
    name     = "resourceGroupId"
    operator = "stringEquals"
    value    = ibm_resource_group.group.id
  }
  roles = ["Reader", "Manager", "Viewer", "Editor"]
}


# Service: All Identity and Access enabled services
resource "ibm_iam_access_group_policy" "policy-all-iam-services" {
  access_group_id = ibm_iam_access_group.ag-test.id
  resource_attributes {
    name     = "serviceType"
    operator = "stringEquals"
    value    = "service"
  }
  # roles = ["Administrator", "Manager"]
  roles = ["Viewer"]
}
