data "ibm_resource_group" "group" {
  name = "default"
}

resource "ibm_resource_instance" "hp-postgres" {
  name = "hp-dbaas-postgresql"
  service = "hyperp-dbaas-postgresql"
  plan = "postgresql-flexible"
  location = "eu-de"
  resource_group_id = data.local.resource_group_id

  //User can increase timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }

  parameters = {
    name: "cluster01",
    admin_name: "admin",
    password: "Hyperprotectdbaas0001"
    confirm_password: "Hyperprotectdbaas0001",
    db_version: "13"
    cpu: "1",
    # kms_instance: "crn:v1:staging:public:kms:us-south:a/23a24a3e3fe7a115473f07be1c44bdb5:9eeb285a-88e4-4378-b7cf-dbdcd97b5e4e::",
    # kms_key: "ee742940-d87c-48de-abc9-d26a6184ba5a",
    memory: "2gib",
    private_endpoint_type: "vpe",
    service-endpoints: "public-and-private",
    storage: "5gib"
 }
}

