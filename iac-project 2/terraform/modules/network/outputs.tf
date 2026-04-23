output "vnet_id" {
  description = "ID du VNet"
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_id" {
  description = "ID du subnet"
  value       = azurerm_subnet.subnet.id
}

output "nsg_id" {
  description = "ID du NSG"
  value       = azurerm_network_security_group.nsg.id
}
