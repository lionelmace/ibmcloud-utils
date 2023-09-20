
## SCC Profiles
##############################################################################

# data "ibm_scc_profile" "list_profiles" {
# }

data "ibm_scc_profile" "profile_security_bestpractices" {
  profile_name = "IBM Cloud Security Best Practices v1.2.0"
  profile_type = "predefined"
}

# data "ibm_scc_profile" "profile_fscloud" {
#   profile_id   = data.ibm_scc_profile.list_profiles.profiles[index(data.ibm_scc_profile.list_profiles.profiles.*.name, "IBM Cloud for Financial Services v1.4.0")].id
#   profile_type = "predefined"
# }


## SCC Profile Attachment
##############################################################################
resource "ibm_scc_profile_attachment" "scc_profile_attachment_instance" {
  # profiles_id = ibm_scc_profile.scc_profile_instance.id
  profile_id = data.ibm_scc_profile.profile_security_bestpractices.id
}

## SCC XX
##############################################################################


## SCC Scope
##############################################################################

# resource "ibm_scc_posture_scope" "scc_scope" {
#   collector_ids   = [ibm_scc_posture_collector.scc_collector.id]
#   credential_id   = ibm_scc_posture_credential.scc_credential.id
#   credential_type = "ibm"
#   description     = "IBMSchema"
#   #   interval = 10
#   #   is_discovery_scheduled = true
#   name = format("%s-%s", var.prefix, "scope")
# }

## SCC Scan
##############################################################################

# resource "ibm_scc_posture_scan_initiate_validation" "scc_scan" {
#   scope_id = ibm_scc_posture_scope.scc_scope.id
#   # IBM Cloud Security Best Practices (profile_id=19)
#   profile_id = data.ibm_scc_posture_profile.profile_security_bestpractices.profile_id
#   name       = format("%s-%s", var.prefix, "scan")
#   # For On-Demand scan, comment the frequency
#   # Minimum scan frequency limit is 1 hour (= 3600 msec)
#   # frequency = 3600
#   #   no_of_occurrences = 1
# }

# resource "ibm_scc_posture_scan_initiate_validation" "scc_scan_fscloud" {
#   scope_id   = ibm_scc_posture_scope.scc_scope.id
#   profile_id = data.ibm_scc_posture_profile.profile_fscloud.profile_id
#   name       = format("%s-%s", var.prefix, "scan-fscloud")
#   # For On-Demand scan, comment the frequency
#   # Minimum scan frequency limit is 1 hour (= 3600 msec)
#   # frequency = 3600
#   #   no_of_occurrences = 1
# }

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
