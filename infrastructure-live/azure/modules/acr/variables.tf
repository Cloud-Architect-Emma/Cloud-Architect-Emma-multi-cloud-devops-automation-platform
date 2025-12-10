// modules/acr/variables.tf
variable "acr_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "sku" {}  // because main.tf uses var.sku