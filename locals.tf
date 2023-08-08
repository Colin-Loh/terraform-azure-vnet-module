locals {
  subnets_flatlist = flatten([for key, val in var.virtual_networks : [
    for subnet in val.subnets : [
      for nic in subnet.network_interfaces : {
        vnet_name              = val.name
        subnet_name            = subnet.subnet_name
        subnet_address         = subnet.subnet_address
        network_interface_name = nic.network_interface_name
        ip_configuration_name  = nic.ip_configuration_name
      }
    ]
    ]
  ])

  subnets = { for subnet in local.subnets_flatlist : subnet.subnet_name => subnet }
}
