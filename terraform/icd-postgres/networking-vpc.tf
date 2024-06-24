##############################################################################
# VPC Variables
##############################################################################

variable "create_vpc" {
  description = "True to create new VPC. False if VPC is already existing and subnets or address prefixies are to be added"
  type        = bool
  default     = true
}

variable "vpc_classic_access" {
  description = "Classic Access to the VPC"
  type        = bool
  default     = false
}

variable "vpc_address_prefix_management" {
  description = "Default address prefix creation method"
  type        = string
  default     = "manual"
}

variable "vpc_acl_rules" {
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

variable "vpc_cidr_blocks" {
  description = "List of CIDR blocks for Address Prefix"
  default = [
    "10.243.0.0/18",
    "10.243.64.0/18",
  "10.243.128.0/18"]
}

variable "subnet_cidr_blocks" {
  description = "List of CIDR blocks for subnets"
  default = [
    "10.243.0.0/24",
    "10.243.64.0/24",
  "10.243.128.0/24"]
}

variable "vpc_enable_public_gateway" {
  description = "Enable public gateways, true or false"
  default     = true
}

variable "floating_ip" {
  description = "Floating IP `id`'s or `address`'es that you want to assign to the public gateway"
  type        = map(any)
  default     = {}
}

##############################################################################
# Create a VPC
##############################################################################

resource "ibm_is_vpc" "vpc" {
  name                        = format("%s-%s", local.basename, "vpc")
  resource_group              = ibm_resource_group.group.id
  address_prefix_management   = var.vpc_address_prefix_management
  default_security_group_name = "${local.basename}-vpc-sg"
  default_network_acl_name    = "${local.basename}-vpc-acl"
  # Delete all rules attached to default security group and default network ACL
  # for a new VPC. This attribute has no impact on update. Default = false
  # no_sg_acl_rules             = true
  classic_access              = var.vpc_classic_access
  tags                        = var.tags
}


##############################################################################
# Prefixes and subnets for zone
##############################################################################

resource "ibm_is_vpc_address_prefix" "address_prefix" {

  count = 3
  name  = "${local.basename}-prefix-zone-${count.index + 1}"
  zone  = "${var.region}-${(count.index % 3) + 1}"
  vpc   = ibm_is_vpc.vpc.id
  cidr  = element(var.vpc_cidr_blocks, count.index)
}


##############################################################################
# Public Gateways
##############################################################################

resource "ibm_is_public_gateway" "pgw" {

  count          = var.vpc_enable_public_gateway ? 3 : 0
  name           = "${local.basename}-pgw-${count.index + 1}"
  vpc            = ibm_is_vpc.vpc.id
  zone           = "${var.region}-${count.index + 1}"
  resource_group = ibm_resource_group.group.id
}


# Network ACLs
##############################################################################
resource "ibm_is_network_acl" "multizone_acl" {

  name           = "${local.basename}-multizone-acl"
  vpc            = ibm_is_vpc.vpc.id
  resource_group = ibm_resource_group.group.id

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


##############################################################################
# Create Subnets
##############################################################################

resource "ibm_is_subnet" "subnet" {

  count           = 3
  name            = "${local.basename}-subnet-${count.index + 1}"
  vpc             = ibm_is_vpc.vpc.id
  zone            = "${var.region}-${count.index + 1}"
  ipv4_cidr_block = element(var.subnet_cidr_blocks, count.index)
  network_acl     = ibm_is_network_acl.multizone_acl.id
  public_gateway  = var.vpc_enable_public_gateway ? element(ibm_is_public_gateway.pgw.*.id, count.index) : null
  tags            = var.tags
  resource_group  = ibm_resource_group.group.id

  depends_on = [ibm_is_vpc_address_prefix.address_prefix]
}