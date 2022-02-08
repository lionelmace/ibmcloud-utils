resource "ibm_resource_group" "resource_group" {
  name = "simple-group"
}

resource "ibm_is_vpc" "vpc" {
  name                        = "simple-vpc"
  resource_group              = ibm_resource_group.resource_group.id
  default_network_acl_name    = "simple-vpc-acl"
  default_security_group_name = "simple-vpc-sg"
}

data "ibm_is_vpc" "ds_vpc" {
  name = ibm_is_vpc.vpc.name
}

# Modify default ACL
resource "ibm_is_network_acl_rule" "outbound" {
  network_acl = data.ibm_is_vpc.ds_vpc.default_network_acl
  name        = "outbound"
  action      = "allow"
  source      = "0.0.0.0/0"
  destination = "0.0.0.0/0"
  direction   = "outbound"
  icmp {
    code = 1
    type = 1
  }
}
resource "ibm_is_network_acl_rule" "inbound" {
  network_acl = data.ibm_is_vpc.ds_vpc.default_network_acl
  name        = "inbound"
  action      = "allow"
  source      = "0.0.0.0/0"
  destination = "0.0.0.0/0"
  direction   = "inbound"
  icmp {
    code = 1
    type = 1
  }
}

# Create a new ACL in addition to Default ACL
# resource "ibm_is_network_acl" "example" {
#   name = "simple-acl"
#   vpc  = ibm_is_vpc.vpc.id
#   resource_group = ibm_resource_group.resource_group.id

#   rules {
#     name        = "outbound"
#     action      = "allow"
#     source      = "0.0.0.0/0"
#     destination = "0.0.0.0/0"
#     direction   = "outbound"
#     icmp {
#       code = 1
#       type = 1
#     }
#   }
#   rules {
#     name        = "inbound"
#     action      = "allow"
#     source      = "0.0.0.0/0"
#     destination = "0.0.0.0/0"
#     direction   = "inbound"
#     icmp {
#       code = 1
#       type = 1
#     }
#   }
# }

resource "ibm_is_vpc_address_prefix" "example" {
  cidr = "10.0.1.0/24"
  name = "simple-add-prefix"
  vpc  = ibm_is_vpc.vpc.id
  zone = var.zone
}

resource "ibm_is_subnet" "example" {
  depends_on = [
    ibm_is_vpc_address_prefix.example
  ]
  ipv4_cidr_block = "10.0.1.0/24"
  name            = "simple-subnet"
  vpc             = ibm_is_vpc.vpc.id
  zone            = var.zone
  network_acl     = ibm_is_vpc.vpc.default_network_acl
  # To be used when creating new ACL
  # network_acl     = ibm_is_network_acl.example.id
}

# resource "ibm_is_subnet_network_acl_attachment" attach {
#   subnet      = ibm_is_subnet.example.id
#   network_acl = ibm_is_network_acl.example.id
# }