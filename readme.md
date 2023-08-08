# Azure Vnet Peering Module for Terraform

This Terraform module provides a simple interface for creating a Virtual Network, Subnet and Network Interfaces.

## Features

- Create multiple virtual networks with its corresponding subnets and network inferfaces. 
- Utilise Terraform For Expressions, Local Variables and Conditions. 

## Usage

Include this repository as a module in your existing terraform code:

```
module "network" {
    source = "https://github.com/Colin-Loh/terraform-azure-vnet-module.git"
    resource_group_name = azurerm_resource_group.this.name
    resource_group_location = azurerm_resource_group.this.location
    virtual_networks = var.virtual_networks
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
|Virtual Network| (Required) virtual network details. <br> <br> Properties: <br> `name` (Required) - virtual network name <br> `address_space`(Required) - address space <br> | <pre> object({<br> key = map(object({ <br> name = string <br> address_space = list(string) }))<br> </pre> | n/a | yes |
| Subnet | (Required) subnet that applies to the virtual network. <br> <br> Properties: <br> `subnet_name` (Required) - virtual network name <br> `subnet_address`(Required) - address space <br> `network_interface_name`(Required) - network interface name <br> `ip_configuration_name`(Required) - network interface ip configuration name <br> | <pre>subnets = list(object({<br> subnet_name = string<br> subnet_address = list(string) <br> <br>network_interfaces = list(object({ <br> network_interface_name = string <br> ip_configuration_name = string <br>  })) <br> })) </pre> | `[]` | yes |


## Example

```
module "network" {
    source = "https://github.com/Colin-Loh/terraform-azure-vnet-module.git"
    resource_group_name = azurerm_resource_group.this.name
    resource_group_location = azurerm_resource_group.this.location

    virtual_networks = {
      "db-vnet" = {
        name = "db-vnet"
        address_space = ["10.0.0.0/16"]

        subnets = [
          {
            subnet_name    = "db-subnet"
            subnet_address = ["10.0.1.0/24"]

            network_interfaces = [
              {
                network_interface_name = "db-nic"
                ip_configuration_name  = "db-ip-configuration"
              }
            ]
          }
        ]
      }
      
      "app-vnet" = {
        name = "app-vnet"
        address_space = ["10.1.0.0/16"]

        subnets = [
          {
            subnet_name    = "app-subnet"
            subnet_address = ["10.1.2.0/24"]

            network_interfaces = [
              {
                network_interface_name = "app-nic"
                ip_configuration_name  = "app-ip-configuration"
              }
            ]
          }
        ]
      }
    }
  }

```

## Outputs

N/A


