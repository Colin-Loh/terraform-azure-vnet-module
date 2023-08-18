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