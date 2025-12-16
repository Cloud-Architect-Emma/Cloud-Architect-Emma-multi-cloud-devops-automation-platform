variable "aks_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "node_count" {}
variable "node_size" {}
variable "subnet_id" {}

variable "service_cidr" {
  default = "10.240.0.0/16"
}

variable "dns_service_ip" {
  default = "10.240.0.10"
}

variable "acr_name" {}
variable "acr_id" {}           # ✅ ADD THIS
