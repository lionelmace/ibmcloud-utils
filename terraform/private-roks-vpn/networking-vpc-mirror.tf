

##############################################################################
# VPC Variables
##############################################################################


##############################################################################
# Create Subnets
##############################################################################

resource "ibm_is_subnet" "subnet-mirror" {

  name            = "${local.basename}-subnet-mirror"
  vpc             = ibm_is_vpc.vpc.id
  zone            = "${var.region}-1"
  ipv4_cidr_block = "10.243.65.0/24"
  network_acl     = ibm_is_network_acl.multizone_acl.id
  public_gateway  = ibm_is_public_gateway.pgw-mirror.*.id
  tags            = var.tags
  resource_group  = ibm_resource_group.group.id

  depends_on = [ibm_is_vpc_address_prefix.address_prefix]
}

##############################################################################
# Public Gateways
##############################################################################

resource "ibm_is_public_gateway" "pgw-mirror" {

  name           = "${local.basename}-pgw-mirror"
  vpc            = ibm_is_vpc.vpc.id
  zone           = "${var.region}-${count.index + 1}"
  resource_group = ibm_resource_group.group.id
  tags           = var.tags
}