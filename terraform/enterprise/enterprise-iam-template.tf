# Service ID
resource "ibm_iam_service_id" "service_id_for_child_account" {
  name        = "svc-id-child-account"
  description = "ServiceID to create Child Account in Enterprise"
  tags        = var.tags
}

# API Key for Service ID
resource "ibm_iam_service_api_key" "testacc_apiKey" {
  name = "apikey-for-child-account"
  iam_service_id = ibm_iam_service_id.service_id_for_child_account.iam_id
}

# Policy Template for "All Identity and Access enabled services"
# Role: Administrator, Manager
resource "ibm_iam_policy_template" "all_iam_services_policy_template" {
	name = "template-policy-all-iam-services"
	description = "Grant Administrator to all IAM Services"
	committed = "true"
	policy {
		type = "access"
		resource {
			attributes {
				key = "serviceType"
				operator = "stringEquals"
				value = "service"
			}
		}
		roles = ["Administrator", "Manager"]
	}
}

# Policy Template for "All Account Management Services"
# Role: Administrator
resource "ibm_iam_policy_template" "account_management_policy_template" {
	name = "template-policy-account-management"
	description = "Grant Administrator to Account Management Servcie"
	committed = "true"
  policy {
		type = "access"
		resource {
			attributes {
				key = "serviceType"
				operator = "stringEquals"
				value = "platform_service"
			}
		}
		roles = ["Administrator"]
	}
}

# Access Group Template with Policies Templates
resource "ibm_iam_access_group_template" "iam_ag_admin_template" {
  description = "This access group template allows admin access to all IAM platform services in the account."
  group {
	name = "name"
	description = "description"
	members {
		# users = [ "users" ]
		services = [ ibm_iam_service_id.service_id_for_child_account.id ]
	}
  }
  name = "IAM Admin Group template"
  policy_template_references {
    id = split("/", ibm_iam_policy_template.all_iam_services_policy_template.id)[0]
    version = "1"
  }
  policy_template_references {
	id = split("/", ibm_iam_policy_template.account_management_policy_template.id)[0]
	version = "1"
  }
}

# Assing Access Group Template to Child Account or Account Group
resource "ibm_iam_access_group_template_assignment" "iam_ag_template_assignment" {
  target = ibm_enterprise_account.coreit.account_id
  target_type = "Account"   // or "AccountGroup"
  template_id = split("/", ibm_iam_access_group_template.iam_ag_admin_template.id)[0]
  template_version = "1"
}