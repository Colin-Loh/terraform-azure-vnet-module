variable "virtual_network" {
  type = object({
    name          = string
    address_space = list(string)
  })
  description = <<DESC
    (Required) details for virtual network.
    Properties:
      `name` (Required)          - name of virtual network.
      `address_space` (Required) - list of address prefixes.

  DESC    
}

variable "subnets" {
  type = object({
    name             = string
    address_prefixes = list(string)
    security_group = object({
      name = string
      rules = list(object({
        name                       = string
        description                = optional(string, "")
        protocol                   = string
        source_port_range          = optional(string, "")
        destination_port_range     = optional(string, "")
        source_address_prefix      = optional(string, "")
        destination_address_prefix = optional(string, "")
        access                     = string
        direction                  = string
      }))
    })
  })
  description = <<DESC
    (Required) subnet and network security group details for the virtual network.
    Properties:
      `name` (Required)                                         - friendly name of the subnet.
      `address_prefixes` (Required)                             - list of address prefixes.
        `security_group` (Required)                       - network security group attached to the subnet.
          `name` (Required)                             - friendly name for network security group.
          `rules` (Required)                            - list of network rules.
            `name` (Required)                       - friendly name for network security rules.
            `description` (Optional)                - description for the rule.
            `protocol` (Required)                   - network protocol for the rule to apply.
            `source_port_range` (Optional)          - list of source ports or port ranges
            `destination_port_range` (Optional)     - list of destination ports or port ranges
            `source_address_prefix` (Optional)      - CIDR or source IP range or * to match any IP.
            `destination_address_prefix` (Optional) - CIDR or destination IP range or * to match any IP. 
            `access` (Required)                     - Specifies whether network traffic is allowed or denied,
            `direction` (Required)                  - The direction specifies if rule will be evaluated on incoming or outgoing.
  DESC

  validation {
    condition = alltrue(
      [
        for rule in var.subnets.security_group.rules :
        contains(
          ["Inbound", "Outbound"],
          rule.direction
        )
      ]
    )
    error_message = "Err: invalid direction scope, possible values includes Inbound or Outbound"
  }

  validation {
    condition = alltrue(
      [
        for rule in var.subnets.security_group.rules :
        contains(
          ["Allow", "Deny"],
          rule.access
        )
      ]
    )
    error_message = "Err: invalid allow scope, possible values includes Allow or Deny"
  }

  validation {
    condition = alltrue(
      [
        for rule in var.subnets.security_group.rules :
        contains(
          ["Tcp", "Udp", "Icmp", "Esp", "Ah", "*"],
          rule.protocol
        )
      ]
    )
    error_message = "Err: invalid protocol scope, possible values include Tcp, Udp, Icmp, Esp, Ah or *"
  }
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
}
