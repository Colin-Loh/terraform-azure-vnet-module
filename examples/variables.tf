variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
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
}
