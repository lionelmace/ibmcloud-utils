

## SCC Profile Attachment
##############################################################################

module "create_profile_attachment_fs" {
  source                 = "terraform-ibm-modules/scc/ibm//modules/attachment"
  profile_name           = "IBM Cloud Framework for Financial Services"
  profile_version        = "latest"
  scc_instance_id        = ibm_resource_instance.scc_instance.guid
  attachment_name        = format("%s-%s", local.basename, "attachment-fs")
  attachment_description = "profile-attachment-description"
  attachment_schedule    = "daily"
  # scope the attachment to a specific resource group
  scope = [{
    environment = "ibm-cloud"
    properties = [
      {
        name  = "scope_type"
        value = "account.resource_group"
      },
      {
        name  = "scope_id"
        value = local.resource_group_id
      }
    ]
  }]
}

module "create_profile_attachment_cis" {
  source                 = "terraform-ibm-modules/scc/ibm//modules/attachment"
  profile_name           = "CIS IBM Cloud Foundations Benchmark v1.1.0"
  profile_version        = "latest"
  scc_instance_id        = ibm_resource_instance.scc_instance.guid
  attachment_name        = format("%s-%s", local.basename, "attachment-cis")
  attachment_description = "profile-attachment-description"
  attachment_schedule    = "daily"
  # scope the attachment to the account
  scope = [{
    environment = "ibm-cloud"
    properties = [
      {
        name  = "scope_type"
        value = "account"
      },
      {
        name  = "scope_id"
        value = local.account_id
      }
    ]
  }]
}

