##############################################################################
# VPC Variables
##############################################################################

variable "create_vpc2" {
  description = "True to create new VPC. False if VPC is already existing and subnets or address prefixies are to be added"
  type        = bool
  default     = true
}

variable "vpc_classic_access2" {
  description = "Classic Access to the VPC"
  type        = bool
  default     = false
}

variable "vpc_address_prefix_management2" {
  description = "Default address prefix creation method"
  type        = string
  default     = "manual"
}

variable "vpc_acl_rules2" {
  default = [
    {
      name        = "egress"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "inbound"
    },
    {
      name        = "ingress"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "outbound"
    }
  ]
}

variable "vpc_cidr_blocks2" {
  description = "List of CIDR blocks for Address Prefix"
  default = [
    "10.243.0.0/18",
    "10.243.64.0/18",
  "10.243.128.0/18"]
}

variable "subnet_cidr_blocks2" {
  description = "List of CIDR blocks for subnets"
  default = [
    "10.243.0.0/24",
    "10.243.64.0/24",
  "10.243.128.0/24"]
}

variable "vpc_enable_public_gateway2" {
  description = "Enable public gateways, true or false"
  default     = true
}

variable "floating_ip2" {
  description = "Floating IP `id`'s or `address`'es that you want to assign to the public gateway"
  type        = map(any)
  default     = {}
}

##############################################################################
# Create a VPC
##############################################################################

resource "ibm_is_vpc" "vpc2" {
  name                        = format("%s-%s", local.basename, "vpc2")
  resource_group              = local.resource_group_id
  address_prefix_management   = var.vpc_address_prefix_management2
  default_security_group_name = "${local.basename}-vpc-sg2"
  default_network_acl_name    = "${local.basename}-vpc-acl2"
  classic_access              = var.vpc_classic_access2
  tags                        = var.tags
}


##############################################################################
# Prefixes and subnets for zone
##############################################################################

resource "ibm_is_vpc_address_prefix" "address_prefix2" {

  count = 3
  name  = "${local.basename}-prefix-zone-${count.index + 1}"
  zone  = "${var.region}-${(count.index % 3) + 1}"
  vpc   = ibm_is_vpc.vpc2.id
  cidr  = element(var.vpc_cidr_blocks2, count.index)
}


##############################################################################
# Public Gateways
##############################################################################

resource "ibm_is_public_gateway" "pgw2" {

  count = var.vpc_enable_public_gateway2 ? 3 : 0
  name  = "${local.basename}-pgw-${count.index + 1}"
  vpc   = ibm_is_vpc.vpc2.id
  zone  = "${var.region}-${count.index + 1}"
  resource_group = local.resource_group_id
}


# Network ACLs
##############################################################################
resource "ibm_is_network_acl" "multizone_acl2" {

  name           = "${local.basename}-multizone-acl2"
  vpc            = ibm_is_vpc.vpc2.id
  resource_group = local.resource_group_id

  dynamic "rules" {

    for_each = var.vpc_acl_rules2

    content {
      name        = rules.value.name
      action      = rules.value.action
      source      = rules.value.source
      destination = rules.value.destination
      direction   = rules.value.direction
    }
  }
}


##############################################################################
# Create Subnets
##############################################################################

resource "ibm_is_subnet" "subnet2" {

  count           = 3
  name            = "${local.basename}-subnet-${count.index + 1}"
  vpc             = ibm_is_vpc.vpc2.id
  zone            = "${var.region}-${count.index + 1}"
  ipv4_cidr_block = element(var.subnet_cidr_blocks2, count.index)
  network_acl     = ibm_is_network_acl.multizone_acl2.id
  public_gateway  = var.vpc_enable_public_gateway2 ? element(ibm_is_public_gateway.pgw2.*.id, count.index) : null
  tags            = var.tags
  resource_group  = local.resource_group_id

  depends_on = [ibm_is_vpc_address_prefix.address_prefix2]
}