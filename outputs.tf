output "private_ip" {
  description = "Private IP of the VM"
  value       = azurerm_network_interface.nic.private_ip_address
}
