
resource "ibm_tg_gateway" "my_tgw"{
  name="transit-gateway-1"
  location="eu-de"
  global=false
  resource_group = ibm_resource_group.group.id
}  

resource "ibm_tg_connection" "test_ibm_tg_connection" {
  gateway      = ibm_tg_gateway.my_tgw.id
  network_type = "vpc"
  name         = "myconnection"
  network_id   = ibm_is_vpc.vpc.crn
}