
variable "ssh_public_key" {
  description = "SSH Public Key. Get your ssh key by running `ssh-key-gen` command"
  type        = string
  default     = null
}

variable "ssh_key_id" {
  description = "ID of SSH public key stored in IBM Cloud"
  type        = string
  default     = null
}

variable "create_public_ip" {
  type    = bool
  default = true
}

variable "image_name" {
  type        = string
  default     = "ibm-redhat-9-2-minimal-amd64-3"
  description = "Name of the image to use for the private instance"
}

variable "profile_name" {
  type        = string
  description = "Instance profile to use for the private instance"
  default     = "cx2-2x4"
}

data "ibm_is_image" "image" {
  name = var.image_name
}

resource "tls_private_key" "rsa_4096_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.rsa_4096_key.private_key_pem
  filename        = "rsakey.pem"
  file_permission = "0600"
}

# Generate an SSH Key
resource "ibm_is_ssh_key" "generated_ssh_key" {
  name           = "${local.basename}-ssh-key"
  resource_group = local.resource_group_id
  public_key     = tls_private_key.rsa_4096_key.public_key_openssh
}

# Create a VSI (Virtual Server Instance)
resource "ibm_is_instance" "vsi" {
  name           = "${local.basename}-vsi"
  vpc            = ibm_is_vpc.vpc.id
  zone           = ibm_is_subnet.subnet-mirror.zone
  profile        = var.profile_name
  image          = data.ibm_is_image.image.id
  keys           = [ibm_is_ssh_key.generated_ssh_key.id]
  resource_group = local.resource_group_id
  tags           = var.tags

  primary_network_interface {
    subnet = ibm_is_subnet.subnet-mirror.id
  }

  boot_volume {
    name = "${local.basename}-boot"
  }
}

# A Public Floating IP for the VSI
resource "ibm_is_floating_ip" "public_ip" {
  count = tobool(var.create_public_ip) ? 1 : 0

  name   = "${local.basename}-floating-ip"
  target = ibm_is_instance.vsi.primary_network_interface[0].id
  tags   = var.tags
}

# Outputs
output "vsi_private_ip" {
  value = ibm_is_instance.vsi.primary_network_interface.0.primary_ip.0.address
}

output "private_key_pem" {
  value = nonsensitive(tls_private_key.rsa_4096_key.private_key_pem)
}

output "vsi_public_ip" {
  description = "The public Floating IP attached to the VSI"
  value = ibm_is_floating_ip.public_ip.0.address
}

output "ssh_connection_string" {
  value = "ssh -i ./rsakey.pem root@VSI-FLOATING-IP"
}