variable "zone1" {
  default = "eu-de-1"
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "image" {
  default = "cc8debe0-1b30-6e37-2e13-744bfb2a0c11" #Centos
}

variable "profile" {
  default = "bc1-2x8" #2CPUs and 8GB RAM
}

variable "ibmcloud_api_key" {
  #default = "XXXXXXXXXXXXXXXXXXXX"
}

