

## SCC Profile Attachment
##############################################################################
resource "ibm_scc_profile_attachment" "scc_profile_attachment_fs" {
  name        = format("%s-%s", local.basename, "fs")
  depends_on  = [ibm_scc_instance_settings.scc_instance_settings]
  profile_id  = "bfacb71d-4b84-41ac-9825-e8a3a3eb7405" # FS Cloud Profile v1.6.0
  instance_id = ibm_resource_instance.scc_instance.guid
  description = "scc-profile-attachment"
  scope {
    environment = "ibm-cloud"
    properties {
      name = "scope_id"
      # value = local.account_id
      value = ibm_resource_group.group.id
    }
    properties {
      name = "scope_type"
      # value = "account"
      value = "account.resource_group"
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
  attachment_parameters {
    parameter_name         = "check_enforced"
    parameter_display_name = "check for cbr enforcement"
    parameter_type         = "string_list"
    parameter_value        = "['cbr', 'service']"
    assessment_type        = "automated"
    assessment_id          = "rule-9eb7b514-5c27-43ba-83fc-26d75e0bf695"
  }
  attachment_parameters {
    parameter_name         = "allowed_ip"
    parameter_display_name = "IP allowlist for COS"
    parameter_type         = "ip_list"
    parameter_value        = "['192.168.1.0/24']"
    assessment_type        = "automated"
    assessment_id          = "rule-3027fd86-72c5-4c81-8ccd-ff556a922ec1"
  }
  attachment_parameters {
    parameter_name         = "check_enforced"
    parameter_display_name = "check for cbr enforcement"
    parameter_type         = "string_list"
    parameter_value        = "['cbr', 'service']"
    assessment_type        = "automated"
    assessment_id          = "rule-56c515ef-4d2b-42e2-aa62-df4b37eab801"
  }
  attachment_parameters {
    parameter_name         = "check_enforced"
    parameter_display_name = "check for cbr enforcement"
    parameter_type         = "string_list"
    parameter_value        = "['cbr', 'service']"
    assessment_type        = "automated"
    assessment_id          = "rule-c9dfee2f-6283-43ce-9337-4eaacaa3313c"
  }
  attachment_parameters {
    parameter_name         = "check_enforced"
    parameter_display_name = "check for cbr enforcement"
    parameter_type         = "string_list"
    parameter_value        = "['cbr', 'service']"
    assessment_type        = "automated"
    assessment_id          = "rule-315c8bb3-3eb8-4186-85bc-e66d68ba9dd0"
  }
  attachment_parameters {
    parameter_name         = "vm_nic_count"
    parameter_display_name = "IBM Cloud Network Interfaces count"
    parameter_type         = "numeric"
    parameter_value        = "1"
    assessment_type        = "automated"
    assessment_id          = "rule-c0314fad-f377-465e-9f16-fa5aa3d5ebbe"
  }
  attachment_parameters {
    parameter_name         = "exclude_floating_ip_list"
    parameter_display_name = "Exclude exclude the IP spoofing"
    parameter_type         = "string_list"
    parameter_value        = "['my_f5_server']"
    assessment_type        = "automated"
    assessment_id          = "rule-7cf9deab-b418-4374-9e10-a13d217166bb"
  }
  attachment_parameters {
    parameter_name         = "exclude_ip_spoofing_check"
    parameter_display_name = "Exclude interfaces with IP-spoofing from VPC"
    parameter_type         = "string_list"
    parameter_value        = "['vm-qa-automation-prod']"
    assessment_type        = "automated"
    assessment_id          = "rule-898ff49d-1979-4b70-9a79-d303c88dea63"
  }
  attachment_parameters {
    parameter_name         = "exclude_load_balancers"
    parameter_display_name = "Exclude Application Load Balancers that have public access"
    parameter_type         = "string_list"
    parameter_value        = "['public-access-load-balancer', 'public-access-edge-node-load-balancer']"
    assessment_type        = "automated"
    assessment_id          = "rule-ce6dff83-7280-4d25-a032-e5ff893e2fce"
  }
  attachment_parameters {
    parameter_name         = "public_gateway_permitted_zones"
    parameter_display_name = "IBM Cloud Public Gateway permitted zones"
    parameter_type         = "string_list"
    parameter_value        = "['us-south-1', 'us-south-2', 'us-south-3', 'us-east-1', 'us-east-2', 'us-east-3', 'au-syd-1', 'au-syd-2', 'au-syd-3', 'eu-de-1', 'eu-de-2', 'eu-de-3', 'eu-gb-1', 'eu-gb-2']"
    assessment_type        = "automated"
    assessment_id          = "rule-d42bbc4b-932f-4ffe-9b2b-8d64fe9cf63f"
  }
  attachment_parameters {
    parameter_name         = "dns_port"
    parameter_display_name = "Security group rule for allowed port numbers to DNS"
    parameter_type         = "numeric"
    parameter_value        = "53"
    assessment_type        = "automated"
    assessment_id          = "rule-0f7e7e60-a05c-43a7-be74-70615f14a342"
  }
  attachment_parameters {
    parameter_name         = "inbound_allowed_list"
    parameter_display_name = "Enter the IP/CIDR list allowed for VPC inbound"
    parameter_type         = "ip_list"
    parameter_value        = "['0.0.0.0/0']"
    assessment_type        = "automated"
    assessment_id          = "rule-28271605-31bb-4efa-b0ef-5f51adc77d90"
  }
  attachment_parameters {
    parameter_name         = "outbound_allowed_list"
    parameter_display_name = "Enter the IP/CIDR list allowed for VPC Outbound"
    parameter_type         = "ip_list"
    parameter_value        = "['0.0.0.0/0']"
    assessment_type        = "automated"
    assessment_id          = "rule-c981bedc-1526-448c-836c-10b0e3a2b812"
  }
  attachment_parameters {
    parameter_name         = "exclude_security_groups"
    parameter_display_name = "Exclude the security groups"
    parameter_type         = "string_list"
    parameter_value        = "['Update the parameter']"
    assessment_type        = "automated"
    assessment_id          = "rule-a1fff3f6-6428-4ad4-9be2-2171ce09fb8f"
  }
  attachment_parameters {
    parameter_name         = "excluded_subnets"
    parameter_display_name = "Subnet(s) name"
    parameter_type         = "string_list"
    parameter_value        = "['dummy-subnet-1', 'dummy-subnet-2']"
    assessment_type        = "automated"
    assessment_id          = "rule-c92a1ac3-6f9a-4fb1-9cb8-57d312679020"
  }
  attachment_parameters {
    parameter_name         = "number_of_vpcs"
    parameter_display_name = "At least one VPC created"
    parameter_type         = "numeric"
    parameter_value        = "1"
    assessment_type        = "automated"
    assessment_id          = "rule-857646d8-23b8-4495-82a4-295ab399266e"
  }
  attachment_parameters {
    parameter_name         = "platform_logs_enabled_locations"
    parameter_display_name = "Platform logs enabled locations of IBM Log Analysis instances"
    parameter_type         = "string_list"
    parameter_value        = "['us-south']"
    assessment_type        = "automated"
    assessment_id          = "rule-ba79b984-ec18-4fc1-965d-82cf701eb94f"
  }
  attachment_parameters {
    parameter_name         = "check_enforced"
    parameter_display_name = "check for cbr enforcement"
    parameter_type         = "string_list"
    parameter_value        = "['cbr', 'service']"
    assessment_type        = "automated"
    assessment_id          = "rule-762180a3-95e1-462b-a7ca-7995ca0dfb7c"
  }
  attachment_parameters {
    parameter_name         = "check_enforced"
    parameter_display_name = "check for cbr enforcement"
    parameter_type         = "string_list"
    parameter_value        = "['cbr', 'service']"
    assessment_type        = "automated"
    assessment_id          = "rule-c26980c7-5fae-47b7-ad2a-e96e87cf28fc"
  }
  attachment_parameters {
    parameter_name         = "number_of_transit_gateways"
    parameter_display_name = "Number of transit gateways"
    parameter_type         = "numeric"
    parameter_value        = "1"
    assessment_type        = "automated"
    assessment_id          = "rule-8c28c15e-c38f-410a-a883-a5f22a839176"
  }
  attachment_parameters {
    parameter_name         = "lockout_policy_config_minutes"
    parameter_display_name = "Lockout duration policy setting in minutes"
    parameter_type         = "numeric"
    parameter_value        = "15"
    assessment_type        = "automated"
    assessment_id          = "rule-df5ef7fa-0ded-4f18-9555-02c399227693"
  }
  attachment_parameters {
    parameter_name         = "session_invalidation_in_seconds"
    parameter_display_name = "Sign out due to inactivity in seconds"
    parameter_type         = "numeric"
    parameter_value        = "7200"
    assessment_type        = "automated"
    assessment_id          = "rule-a637949b-7e51-46c4-afd4-b96619001bf1"
  }
  attachment_parameters {
    parameter_name         = "scan_interval_max"
    parameter_display_name = "Maximum number of days between vulnerability scans"
    parameter_type         = "numeric"
    parameter_value        = "3"
    assessment_type        = "automated"
    assessment_id          = "rule-51e15d43-3946-4898-b593-02e16a988d8e"
  }
  attachment_parameters {
    parameter_name         = "allowed_tool_integration_services"
    parameter_display_name = "List of allowed tool integration services for toolchains"
    parameter_type         = "string_list"
    parameter_value        = "['artifactory', 'customtool', 'draservicebroker', 'githubconsolidated', 'gitlab', 'hashicorpvault', 'hostedgit', 'keyprotect', 'pagerduty', 'pipeline', 'private_worker', 'saucelabs', 'secretsmanager', 'security_compliance', 'slack', 'sonarqube']"
    assessment_type        = "automated"
    assessment_id          = "rule-e208d1c0-8ede-49f0-b4a3-4da3da738733"
  }
  attachment_parameters {
    parameter_name         = "defined_images"
    parameter_display_name = "VPC provisioned from list of customer-defined images"
    parameter_type         = "string_list"
    parameter_value        = "['Update the parameter']"
    assessment_type        = "automated"
    assessment_id          = "rule-709caded-75d6-4481-b9cd-de20851a9b19"
  }
  attachment_parameters {
    parameter_name         = "fs_cloud_regions"
    parameter_display_name = "Hyper Protect Crypto Services regions"
    parameter_type         = "string_list"
    parameter_value        = "['au-syd', 'br-sao', 'ca-tor', 'eu-de', 'eu-gb', 'jp-osa', 'jp-tok', 'us-east', 'us-south']"
    assessment_type        = "automated"
    assessment_id          = "rule-574143f9-befe-4da1-a15e-af9437ed9ae7"
  }
  attachment_parameters {
    parameter_name         = "worker_node_min_zones"
    parameter_display_name = "Minimum number of Worker node zones"
    parameter_type         = "numeric"
    parameter_value        = "3"
    assessment_type        = "automated"
    assessment_id          = "rule-88f25dca-0e62-43c1-939e-f6637d23847f"
  }
  attachment_parameters {
    parameter_name         = "number_of_direct_links"
    parameter_display_name = "Number of Direct Links"
    parameter_type         = "numeric"
    parameter_value        = "2"
    assessment_type        = "automated"
    assessment_id          = "rule-c0f15737-b451-44d0-a0b6-649013a155bc"
  }
  attachment_parameters {
    parameter_name         = "hpcs_crypto_units"
    parameter_display_name = "Number of IBM Cloud Hyper Protect Crypto Service units"
    parameter_type         = "string_list"
    parameter_value        = "['2', '3']"
    assessment_type        = "automated"
    assessment_id          = "rule-064d9004-8728-4988-b19a-1805710466f6"
  }
  attachment_parameters {
    parameter_name         = "loadbalancer_min_lb_zones"
    parameter_display_name = "Minimal number of loadbalancer zones"
    parameter_type         = "numeric"
    parameter_value        = "3"
    assessment_type        = "automated"
    assessment_id          = "rule-0be41446-a0e7-46fb-8cbb-37bf413e0286"
  }
  attachment_parameters {
    parameter_name         = "vpc_min_zones"
    parameter_display_name = "Minimum number of VPC zones"
    parameter_type         = "numeric"
    parameter_value        = "3"
    assessment_type        = "automated"
    assessment_id          = "rule-f47c1c7d-cead-4f21-aa71-4fe7a307ae9b"
  }
  attachment_parameters {
    parameter_name         = "no_pre_shared_key_characters"
    parameter_display_name = "Enough characters in pre-shared key"
    parameter_type         = "numeric"
    parameter_value        = "24"
    assessment_type        = "automated"
    assessment_id          = "rule-d8d13c3e-5ca0-46c5-a055-2475852c4ec6"
  }
  attachment_parameters {
    parameter_name         = "min_hours_change_password"
    parameter_display_name = "Mininum number of hours between App ID password changes"
    parameter_type         = "numeric"
    parameter_value        = "0"
    assessment_type        = "automated"
    assessment_id          = "rule-250c3e07-0d2d-48c6-9de6-cbf5ba0d22ed"
  }
  attachment_parameters {
    parameter_name         = "hpcs_rotation_policy"
    parameter_display_name = "Hyper Protect Crypto Services key rotation policy"
    parameter_type         = "string_list"
    parameter_value        = "['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12']"
    assessment_type        = "automated"
    assessment_id          = "rule-caf5e45d-ccc8-4e35-b124-e1b4c8bcab71"
  }
  attachment_parameters {
    parameter_name         = "arbitrary_secret_min_rotation_period"
    parameter_display_name = "Minimum rotation period of Secrets Manager arbitrary secrets"
    parameter_type         = "numeric"
    parameter_value        = "90"
    assessment_type        = "automated"
    assessment_id          = "rule-88ff070b-3a8d-4d66-a943-3b2fa28630ea"
  }
  attachment_parameters {
    parameter_name         = "user_credential_min_rotation_period"
    parameter_display_name = "Minimum rotation period of Secrets Manager user credentials"
    parameter_type         = "numeric"
    parameter_value        = "90"
    assessment_type        = "automated"
    assessment_id          = "rule-28e20137-3350-4d51-9abc-4dae8fee9e04"
  }
  attachment_parameters {
    parameter_name         = "access_tokens_expiration_minutes"
    parameter_display_name = "Expiration in minutes of App ID access tokens"
    parameter_type         = "numeric"
    parameter_value        = "120"
    assessment_type        = "automated"
    assessment_id          = "rule-91734f9f-b8ff-4bfd-afb3-db4f789ac38f"
  }
  attachment_parameters {
    parameter_name         = "session_expiration_in_seconds"
    parameter_display_name = "Session expiration in seconds for the account"
    parameter_type         = "numeric"
    parameter_value        = "86400"
    assessment_type        = "automated"
    assessment_id          = "rule-846058ff-dbf1-4ab6-864f-1be009618759"
  }
  attachment_parameters {
    parameter_name         = "diffie_hellman_group"
    parameter_display_name = "Diffie-Hellman group number set"
    parameter_type         = "numeric"
    parameter_value        = "14"
    assessment_type        = "automated"
    assessment_id          = "rule-a8a69cd6-a902-4144-b652-8be68600a029"
  }
}
