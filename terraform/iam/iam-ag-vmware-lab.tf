resource "ibm_iam_access_group" "ag-vmware-lab" {
  name = "ag-vmware-lab"
  tags = var.tags
}

# Add visibility to the Resource Group
resource "ibm_iam_access_group_policy" "rg-vmware-lab-visibility" {
  access_group_id = ibm_iam_access_group.ag-vmware-lab.id
  roles           = ["Viewer"]
  resources {
    resource_type = "resource-group"
    resource      = ibm_resource_group.rg-vmware-lab.id
  }
}

# Service: VCF as a Service
# 
# Platform Roles: Viewer
# Service  Roles: Reader, Viewer, VCFaaS Director Console User, 
# VCFaaS Director Backup User, VCFaaS Director Security Admin, 
# VCFaaS Director Network Admin, VCFaaS Director Catalog Author, 
# VCFaaS Director vApp User, VCFaaS Director vApp Author, 
# VCFaaS Director Full Viewer
resource "ibm_iam_access_group_policy" "policy-vcf-vmware-all" {
  access_group_id = ibm_iam_access_group.ag-vmware-lab.id
  resource_attributes {
    name     = "serviceName"
    operator = "stringEquals"
    value    = "vmware"
  }
  roles = ["Reader", "Viewer", "VCFaaS Director Console User", "VCFaaS Director Backup User", "VCFaaS Director Security Admin", "VCFaaS Director Network Admin", "VCFaaS Director Catalog Author", "VCFaaS Director vApp User", "VCFaaS Director vApp Author", "VCFaaS Director Full Viewer"]
}

# Service: VCF as a Service
resource "ibm_iam_access_group_policy" "policy-vcf-vmware-rg" {
  access_group_id = ibm_iam_access_group.ag-vmware-lab.id
  resource_attributes {
    name     = "serviceName"
    operator = "stringEquals"
    value    = "vmware"
  }
  resource_attributes {
    name     = "resourceGroupId"
    operator = "stringEquals"
    value    = ibm_resource_group.rg-vmware-lab.id
  }
  roles = ["Viewer", "Administrator", "Editor", "Operator", "Service Configuration Reader", "Key Manager"]
}

# Service: VMware Solutions
# 
# Platform Roles: Viewer
# Service  Roles: Reader
resource "ibm_iam_access_group_policy" "policy-vmware-solutions" {
  access_group_id = ibm_iam_access_group.ag-vmware-lab.id
  resource_attributes {
    name     = "serviceName"
    operator = "stringEquals"
    value    = "vmware-solutions"
  }
  resource_attributes {
    name     = "resourceGroupId"
    operator = "stringEquals"
    value    = ibm_resource_group.rg-vmware-lab.id
  }
  roles = ["Viewer", "Reader"]
}
