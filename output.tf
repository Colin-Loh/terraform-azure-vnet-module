output "vnet_ids" {
  description = "The IDs of the created virtual networks"
  value       = { for k, vnet in azurerm_virtual_network.this : k => vnet.id }
}

output "network_interface_ids" {
  description = "The IDs of the created network interfaces"
  value       = { for k, nic in azurerm_network_interface.this : k => nic.id }
}
