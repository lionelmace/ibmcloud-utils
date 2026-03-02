########################################################################################################################
# Resource group
########################################################################################################################

module "resource_group" {
  source                       = "terraform-ibm-modules/resource-group/ibm"
  version                      = "1.4.8"
  resource_group_name          = var.resource_group == null ? "${var.prefix}-rg" : null
  existing_resource_group_name = var.resource_group
}

########################################################################################################################
# App Config with config aggregator enabled
########################################################################################################################

module "app_config" {
  source                                                     = "terraform-ibm-modules/app-configuration/ibm"
  version                                                    = "1.15.10"
  region                                                     = var.region
  resource_group_id                                          = module.resource_group.resource_group_id
  app_config_plan                                            = "basic"
  app_config_name                                            = "${var.prefix}-app-config"
  app_config_tags                                            = var.resource_tags
  enable_config_aggregator                                   = true
  config_aggregator_trusted_profile_name                     = "${var.prefix}-app-config-tp"
  config_aggregator_resource_collection_regions              = ["all"] # supports passing list of regions, or "all" for all regions
#   config_aggregator_enterprise_id                            = var.enterprise_id
#   config_aggregator_enterprise_trusted_profile_template_name = "${var.prefix}-app-config-tp-template"
#   config_aggregator_enterprise_account_group_ids_to_assign   = ["all"] # supports passing list of account groups. Use 'config_aggregator_enterprise_account_ids_to_assign' to pass individual accounts
}

########################################################################################################################
# SCC Workload Protection with CSPM enabled
########################################################################################################################

module "scc_wp" {
#   source = "../.."
  # remove the above line and uncomment the below 2 lines to consume the module from the registry
  source            = "terraform-ibm-modules/scc-workload-protection/ibm"
  # version           = "X.Y.Z" # Replace "X.Y.Z" with a release version to lock into a specific release
  name                                         = var.prefix
  region                                       = var.region
  resource_group_id                            = module.resource_group.resource_group_id
  resource_tags                                = var.resource_tags
  access_tags                                  = var.access_tags
  scc_wp_service_plan                          = "graduated-tier"
  cspm_enabled                                 = true
  app_config_crn                               = module.app_config.app_config_crn
  scc_workload_protection_trusted_profile_name = "${var.prefix}-scc-wp-tp"
}

########################################################################################################################
# SCC WP Zone (https://cloud.ibm.com/docs/workload-protection?topic=workload-protection-posture-zones)
# - create a new zone which only contains FedRAMP policies
########################################################################################################################

# lookup all posture policies
data "sysdig_secure_posture_policies" "all" {
  # explicit depends_on required as data lookup can only occur after SCC-WP instance has been created
  depends_on = [module.scc_wp]
}

# extract out all FedRAMP policies
locals {
  fedramp_policies = [
    for p in data.sysdig_secure_posture_policies.all.policies :
    p if length(regexall(".*FedRAMP.*", p.name)) > 0
  ]
}

# create a new zone and add the FedRAMP policies to it
resource "sysdig_secure_posture_zone" "example" {
  name        = "${var.prefix}-zone"
  description = "Zone description"
  policy_ids  = [for p in local.fedramp_policies : p.id]

  # you can use a scope to only target a set of sub-accounts by uncommenting the below code and updating the account IDs

  # scopes {
  #   scope {
  #     target_type = "ibm"
  #     rules       = "account in (\"nbac0df06b644a9cabc6e44f55b3880h\", \"5f9af00a96104f49b6509aa715f9d6a4\")"
  #   }
  # }
}