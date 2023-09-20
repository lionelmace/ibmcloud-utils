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
    resource      = ibm_resource_group.group.id
  }
}

# Authorization policy between SCC (Source) and COS Bucket (Target)
# Requires by the new SCC to store SCC evaluation results into a COS bucket
resource "ibm_iam_authorization_policy" "iam-auth-scc-cos" {
  source_service_name         = "compliance"
  target_service_name         = "cloud-object-storage"
  target_resource_instance_id = ibm_resource_instance.cos.guid
  roles                       = ["Writer"]
}

