resource "ibm_iam_access_group" "accgrp" {
  name = "${var.prefix}-ag"
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

# DevOps - Continuous Delivery
resource "ibm_iam_access_group_policy" "iam-continuous-delivery" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Manager", "Writer", "Editor", "Operator", "Viewer"]

  resources {
    service           = "continuous-delivery"
    resource_group_id = ibm_resource_group.resource_group.id
  }
}

# DevOps - Toolchain
resource "ibm_iam_access_group_policy" "iam-toochain" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Editor", "Operator", "Viewer"]

  resources {
    service           = "toolchain"
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

resource "ibm_iam_access_group_policy" "iam-logdna" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Writer", "Editor"]

  resources {
    service           = "sysdig-monitor"
    resource_group_id = ibm_resource_group.resource_group.id
  }
}