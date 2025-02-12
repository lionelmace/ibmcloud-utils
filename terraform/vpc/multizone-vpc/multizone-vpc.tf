
resource "ibm_is_vpc" "vpc" {
  name                      = "${var.prefix}-vpc"
  address_prefix_management = var.vpc_address_prefix_management
  # default_network_acl_name  = "${var.prefix}-acl"
  classic_access = var.vpc_classic_access
  tags           = var.tags
}

resource "ibm_is_vpc_address_prefix" "subnet_prefix" {

  count = 3
  name  = "${var.prefix}-prefix-zone-${count.index + 1}"
  zone  = "${var.region}-${(count.index % 3) + 1}"
  vpc   = ibm_is_vpc.vpc.id
  cidr  = element(var.vpc_cidr_blocks, count.index)
}

resource "ibm_is_public_gateway" "pgw" {

  count = var.vpc_enable_public_gateway ? 3 : 0
  name  = "${var.prefix}-pgw-${count.index + 1}"
  vpc   = ibm_is_vpc.vpc.id
  zone  = "${var.region}-${count.index + 1}"

}

resource "ibm_is_security_group_rule" "sg-rule-inbound-icmp" {
  group     = ibm_is_vpc.vpc.default_security_group
  direction = "inbound"
  remote    = "0.0.0.0/0"

  icmp {
    type = 8
  }
}

# Allow incoming ICMP packets (pings).
resource "ibm_is_security_group_rule" "sg-rule-inbound-https" {
  group     = ibm_is_vpc.vpc.default_security_group
  direction = "inbound"
  remote    = "0.0.0.0/0"

  tcp {
    port_min = 443
    port_max = 443
  }
}

resource "ibm_is_security_group_rule" "sg-rule-inbound-ssh" {
  group     = ibm_is_vpc.vpc.default_security_group
  direction = "inbound"
  remote    = "0.0.0.0/0"

  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_network_acl" "multizone_acl" {

  name = "${var.prefix}-acl"
  vpc  = ibm_is_vpc.vpc.id

  dynamic "rules" {

    for_each = var.vpc_acl_rules

    content {
      name        = rules.value.name
      action      = rules.value.action
      source      = rules.value.source
      destination = rules.value.destination
      direction   = rules.value.direction
    }
  }
}

resource "ibm_is_subnet" "subnet" {

  count           = 3
  name            = "${var.prefix}-subnet-${count.index + 1}"
  vpc             = ibm_is_vpc.vpc.id
  zone            = "${var.region}-${count.index + 1}"
  ipv4_cidr_block = element(ibm_is_vpc_address_prefix.subnet_prefix.*.cidr, count.index)
  network_acl     = ibm_is_network_acl.multizone_acl.id
  public_gateway  = var.vpc_enable_public_gateway ? element(ibm_is_public_gateway.pgw.*.id, count.index) : null
}

resource "ibm_is_subnet_network_acl_attachment" "attach" {
  count       = 3
  subnet      = element(ibm_is_subnet.subnet.*.id, count.index)
  network_acl = ibm_is_network_acl.multizone_acl.id
}