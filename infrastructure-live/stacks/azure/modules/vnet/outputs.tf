output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  description = "Map of subnet names to subnet IDs"
  value = { for name, subnet in azurerm_subnet.subnets : name => subnet.id }
}
