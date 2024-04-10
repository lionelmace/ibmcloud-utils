# Create Access Group
resource "ibm_iam_access_group" "accgrp" {
  name = format("%s-%s", local.basename, "ag")
  tags = var.tags
}

# Visibility on the Resource Group
resource "ibm_iam_access_group_policy" "iam-rg-viewer" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Viewer"]
  resources {
    resource_type = "resource-group"
    resource      = local.resource_group_id
  }
}

# Create a policy to all Kubernetes/OpenShift clusters within the Resource Group
resource "ibm_iam_access_group_policy" "policy-k8s" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Manager", "Writer", "Editor", "Operator", "Viewer", "Administrator"]

  resources {
    service           = "containers-kubernetes"
    resource_group_id = local.resource_group_id
  }
}

# Assign Administrator platform access role to enable the creation of API Key
# Pre-Req to provision IKS/ROKS clusters within a Resource Group
resource "ibm_iam_access_group_policy" "policy-k8s-identity-administrator" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Administrator", "User API key creator", "Service ID creator"]

  resources {
    service = "iam-identity"
  }
}


# SERVICE ID
# Equivalent to CLI commands in this tutorial
# https://cloud.ibm.com/docs/secrets-manager?topic=secrets-manager-tutorial-kubernetes-secrets#tutorial-external-kubernetes-secrets-access
# resource "ibm_iam_service_id" "kubernetes-secrets" {
#   name        = "kubernetes-secrets"
#   description = "A service ID for testing Secrets Manager and Kubernetes Service."
#   tags        = var.tags
# }

# resource "ibm_iam_service_policy" "secrets-policy" {
#   iam_service_id = ibm_iam_service_id.kubernetes-secrets.id
#   roles          = ["SecretsReader"]

#   resources {
#     service              = "secrets-manager"
#     resource_instance_id = ibm_iam_service_id.kubernetes-secrets.id
#   }
# }

# resource "ibm_iam_service_api_key" "secrets_apikey" {
#   name           = "secrets_apikey"
#   description    = "An API key for testing Secrets Manager."
#   iam_service_id = ibm_iam_service_id.kubernetes-secrets.iam_id
# }


# AUTHORIZATIONS
##############################################################################

# Authorization policy between OpenShift and Secrets Manager
# resource "ibm_iam_authorization_policy" "roks-sm" {
#   source_service_name         = "containers-kubernetes"
#   source_resource_instance_id = module.vpc_openshift_cluster.vpc_openshift_cluster_id
#   target_service_name         = "secrets-manager"
#   target_resource_instance_id = ibm_resource_instance.secrets-manager.guid
#   roles                       = ["Manager"]
# }