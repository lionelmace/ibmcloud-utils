resource "ibm_is_vpc" "vpc" {
  name = "simple-vpc"
}
resource "ibm_is_network_acl" "example" {
  name = "simple-acl"
  vpc  = ibm_is_vpc.vpc.id

  rules {
    name        = "outbound"
    action      = "allow"
    source      = "0.0.0.0/0"
    destination = "0.0.0.0/0"
    direction   = "outbound"
    icmp {
      code = 1
      type = 1
    }
    # Optionals :
    # port_max =
    # port_min =
  }
  rules {
    name        = "inbound"
    action      = "allow"
    source      = "0.0.0.0/0"
    destination = "0.0.0.0/0"
    direction   = "inbound"
    icmp {
      code = 1
      type = 1
    }
    # Optionals :
    # port_max =
    # port_min =
  }
}

resource "ibm_is_vpc_address_prefix" "example" {
  cidr = "10.0.1.0/24"
  name = "simple-add-prefix"
  vpc  = ibm_is_vpc.vpc.id
  zone = var.zone
}

resource "ibm_is_subnet" "example" {
  depends_on      = [
    ibm_is_vpc_address_prefix.example
  ]
  ipv4_cidr_block = "10.0.1.0/24"
  name            = "simple-subnet"
  vpc             = ibm_is_vpc.vpc.id
  zone            = var.zone
  network_acl     = ibm_is_network_acl.example.id
}

resource "ibm_is_subnet_network_acl_attachment" attach {
  subnet      = ibm_is_subnet.example.id
  network_acl = ibm_is_network_acl.example.id
}