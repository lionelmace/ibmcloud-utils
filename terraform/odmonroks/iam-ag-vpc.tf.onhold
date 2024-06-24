
# Name of the Access Group
resource "ibm_iam_access_group" "ag-vpc" {
  name = format("%s-%s", local.basename, "ag-vpc")
  tags = var.tags
}

# Visibility on the Resource Group
resource "ibm_iam_access_group_policy" "application1_policy" {
  access_group_id = ibm_iam_access_group.ag-vpc.id
  roles           = ["Viewer"]
  resources {
    resource_type = "resource-group"
    resource      = ibm_resource_group.group.id
  }
}

# ------------------------------------------------------------
# VPC Infrastructure (is) resources (i.e. vpc)
# List of Resource Attributes:
# https://cloud.ibm.com/docs/vpc?topic=vpc-resource-attributes
# All IAM roles and actions
# https://cloud.ibm.com/docs/account?topic=account-iam-service-roles-actions
# -------------------------------------------------------------
locals {
  # types of resources that both the network team
  is_network_service_types = {
    "vpcId"           = "*"
    "subnetId"        = "*"
    "securityGroupId" = "*"
    "networkAclId"    = "*"
    # "loadBalancerId"  = "*" # not used, included for completeness
    # "publicGatewayId"    = "*" # not used, included for completeness
    # "flowLogCollectorId" = "*" # not used, included for completeness
    # "vpnGatewayId"       = "*" # not used, included for completeness
  }
  # Types of resources required to be able to create a VSI
  is_instance_service_types = {
    "imageId"      = "*"
    "instanceId"   = "*"
    "floatingIpId" = "*"
    "keyId"        = "*"
    "volumeId"     = "*"
    # "instanceGroupId" = "*" # not used, included for completeness
    # "dedicatedHostId" = "*" # not used, included for completeness
  }
}

# Operator role is required on VPC/Subnet to be able 
# to select a VPC while creating a VSI.
# Replace role Editor by Operator to prevent users from creating
# VPC/Subnet networks
resource "ibm_iam_access_group_policy" "policy_vpc" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Editor"]

  for_each = local.is_network_service_types
  resource_attributes {
    name     = each.key
    operator = "stringEquals"
    value    = each.value
  }
  resource_attributes {
    name     = "serviceName"
    operator = "stringEquals"
    value    = "is"
  }
  resource_attributes {
    name     = "resourceGroupId"
    operator = "stringEquals"
    value    = ibm_resource_group.group.id
  }
  resource_attributes {
    name     = "region"
    operator = "stringEquals"
    value    = "eu-de"
  }
}

# Editor role is required to create a VSI or Block Storage.
# Viewer/Operator can only list VSI.
resource "ibm_iam_access_group_policy" "policy_vsi" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Editor"]

  for_each = local.is_instance_service_types
  resource_attributes {
    name     = each.key
    operator = "stringEquals"
    value    = each.value
  }
  resource_attributes {
    name     = "serviceName"
    operator = "stringEquals"
    value    = "is"
  }
  resource_attributes {
    name     = "resourceGroupId"
    operator = "stringEquals"
    value    = ibm_resource_group.group.id
  }
  resource_attributes {
    name     = "region"
    operator = "stringEquals"
    value    = "eu-de"
  }

}