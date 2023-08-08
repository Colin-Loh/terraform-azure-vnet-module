#Module      : Virtual Network Configuration
#Description : This will automatically create the virtual network, subnets and network interfaces. 

variable "resource_group_name" {
  type = string
  description = "value for resource group name"
}

variable "resource_group_location" {
  type = string
  description = "value for resource group location"
}

variable "virtual_networks" {
  type = map(object({
    name = string
    address_space = list(string)

    subnets = list(object({
      subnet_name    = string
      subnet_address = list(string)

      network_interfaces = list(object({
        network_interface_name = string
        ip_configuration_name = string
      }))
    }))
  }))
  
  description = "value for virtual network"
} 
