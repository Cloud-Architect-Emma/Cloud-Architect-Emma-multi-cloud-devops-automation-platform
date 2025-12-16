variable "location" {
  description = "The Azure region where resources will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where VNet and subnets will be created"
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = set(string)
}

variable "subnets" {
  description = "Map of subnet names to CIDR blocks"
  type        = map(string)
}
