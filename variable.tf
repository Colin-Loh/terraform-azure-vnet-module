variable "virtual_network" {}

variable "subnets" {
  type = object({
    name           = string
    address_prefixes  = list(string)
    security_group = object({
      name  = string
      rules = list(object({
        name                       = string
        description                = string
        protocol                   = string
        source_port_range          = string
        destination_port_range     = string
        source_address_prefix      = string
        destination_address_prefix = string
        access                     = string
        direction                  = string
      }))
    })
  })
}

variable "resource_group" {
  type = object({
    name = string
    location = string
  })
}
