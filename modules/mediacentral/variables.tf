#########################
# Input Variables       #
#########################
variable "hostname" {
  description = "description"
}

variable "admin_password" {
  description = "Admin Password for Virtual Machines"
}

variable "admin_username" {
  description = "Admin Username for Virtual Machines"
  default = "avid"
}

variable "media_central_vm_public_ip_dns" {
  description = "description"
}

variable "media_central_vm_number_public_ip" {
  description = "description"
}

variable "media_central_vm_remote_port" {
  description = "description"
  default = 22
}

variable "media_central_vm_instances" {
  description = "description"
  default = 1
}

variable "media_central_vm_size" {
  description = "description"
}

variable "resource_group_name" {
  description = ""
}

variable "resource_group_location" {
  description = ""
}

variable "subnet_id" {
  description = ""
}

variable "source_address_prefix" {
  description = "CIDR or source IP range or * to match any IP. Tags such as ‘VirtualNetwork’, ‘AzureLoadBalancer’ and ‘Internet’ can also be used."
  default = "*"
}

variable "tags" {
  description = "description"
}

#########################
# General Variables     #
#########################
resource "random_string" "mediacentral" {
    length  = 5
    special = false
    upper   = false
}
