resource "ibm_iam_access_group" "accgrp" {
  name = format("%s-%s", var.prefix, "ag")
  tags = var.tags
}

resource "ibm_iam_access_group_policy" "policy-cos" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Viewer"]
 
  resources {
    service           = "cloud-object-storage"
    resource_group_id = ibm_resource_group.resource_group.id
  }
}


# Create a policy to all Kubernetes instances within the Resource Group
resource "ibm_iam_access_group_policy" "policy-k8s" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Manager", "Writer", "Editor", "Operator", "Viewer"]

  resources {
    service           = "containers-kubernetes"
    resource_group_id = ibm_resource_group.resource_group.id
  }
}

resource "ibm_iam_access_group_policy" "iam-logdna" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Manager", "Viewer", "Standard Member"]

  resources {
    service           = "logdna"
    resource_group_id = ibm_resource_group.resource_group.id
  }
}

resource "ibm_iam_access_group_policy" "iam-sysdig" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Writer", "Editor"]

  resources {
    service           = "sysdig-monitor"
    resource_group_id = ibm_resource_group.resource_group.id
  }
}

resource "ibm_iam_access_group_policy" "iam-key-protect" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Writer", "Editor"]

  resources {
    service           = "key-protect"
    resource_group_id = ibm_resource_group.resource_group.id
  }
}



# AUTHORIZATIONS

# Authorization policy between DBaaS and Key Protect
# Require to encrypt DBaaS with Key in Key Protect
# https://github.com/IBM-Cloud/vpc-scaling-dedicated-host/blob/master/modules/create_services/main.tf
resource "ibm_iam_authorization_policy" "posgresql-kms" {
  source_service_name         = "databases-for-postgresql"
  target_service_name         = "kms"
  target_resource_instance_id = ibm_resource_instance.key-protect.guid
  roles                       = ["Reader", "Authorization Delegator"]
}