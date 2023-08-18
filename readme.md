# Azure Vnet Peering Module for Terraform
This Terraform module provides a simple interface for creating a Virtual Network, Subnet and Network Interfaces.

## Features
- Create multiple virtual networks with its corresponding subnets and network inferfaces.
- Utilise Terraform For Expressions, Local Variables and Conditions.

<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_network_interface.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | value for resource group location | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | value for resource group name | `string` | n/a | yes |
| <a name="input_virtual_networks"></a> [virtual\_networks](#input\_virtual\_networks) | value for virtual network | <pre>map(object({<br>    name = string<br>    address_space = list(string)<br><br>    subnets = list(object({<br>      subnet_name    = string<br>      subnet_address = list(string)<br><br>      network_interfaces = list(object({<br>        network_interface_name = string<br>        ip_configuration_name = string<br>      }))<br>    }))<br>  }))</pre> | n/a | yes |

## Usage
Basic usage of this module is as follows:

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "this" {
    name = var.resource_group_name
    location = var.resource_group_location
}

module "network" {
    source = "https://github.com/Colin-Loh/terraform-azure-vnet-module.git"
    resource_group_name = azurerm_resource_group.this.name
    resource_group_location = azurerm_resource_group.this.location
    virtual_networks = var.virtual_networks
}
```

## Example(s)

```hcl
resource "azurerm_virtual_network" "this" {
  for_each = var.virtual_networks

  name                = each.value.name
  address_space       = each.value.address_space
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "this" {
  for_each = local.subnets

  name                 = each.value.subnet_name
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this[each.value.vnet_name].name
  address_prefixes     = each.value.subnet_address
}

data "azurerm_subnet" "subnet" {
  for_each = local.subnets

  name                 = each.key
  virtual_network_name = each.value.vnet_name
  resource_group_name = var.resource_group_name

  depends_on = [azurerm_subnet.this]
}

resource "azurerm_network_interface" "this" {
  for_each = local.subnets

  name                = each.value.network_interface_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = each.value.ip_configuration_name
    subnet_id                     = data.azurerm_subnet.subnet[each.value.subnet_name].id
    private_ip_address_allocation = "Dynamic"
  }
}
```
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->

