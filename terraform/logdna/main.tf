provider "ibm" {
  ibmcloud_api_key   = "${var.ibmcloud_api_key}"
  region             = "${var.region}"
}

data "ibm_resource_group" "logDNA_group" {
  name = "${var.rg_name}"
}

resource "ibm_resource_instance" "logDNA" {
  name              = "${var.instance_name}"
  service           = "logdna"
  plan              = "${var.plan}"
  location          = "${var.region}"
  resource_group_id = "${data.ibm_resource_group.logDNA_group.id}"  
  
  parameters = {
    "service_supertenant" = "${var.service_name}"
    "provision_key" = "${var.provision_key}"
  }
  
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}