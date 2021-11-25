provider "ibm" {
  ibmcloud_api_key   = "${var.ibmcloud_api_key}"
  region             = "${var.location}"
}

data "ibm_resource_group" "sysDig_group" {
  name = "${var.rg_name}"
}

resource "ibm_resource_instance" "sys_dig" {
  name              = "${var.instance_name}"
  service           = "sysdig-monitor"
  plan              = "graduated-tier"
  location          = "${var.location}"
  resource_group_id = "${data.ibm_resource_group.id}"

  //User can increase timeouts 
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}