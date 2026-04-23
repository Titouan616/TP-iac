output "public_ip" {
  description = "IP publique de la VM"
  value       = azurerm_public_ip.pip.ip_address
}

output "private_ip" {
  description = "IP privée de la VM"
  value       = azurerm_network_interface.nic.private_ip_address
}

output "vm_name" {
  description = "Nom de la VM"
  value       = azurerm_linux_virtual_machine.vm.name
}
