provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "this" {
  name     = "terraform-vnet-rg"
  location = "australiaeast"
}

module "virtual_networks" {
  source = "../"

  resource_group = {
    name     = azurerm_resource_group.this.name
    location = azurerm_resource_group.this.location
  }

  virtual_network = {
    name          = "test-vnet"
    address_space = ["10.0.0.0/16"]
  }

  subnets = {
    name             = "db-subnet"
    address_prefixes = ["10.0.1.0/24"]

    security_group = { 
      name = "db-security-group"
      rules = [
        { #note that it needs to be case sensitive
          name                       = "test"
          description                = " "
          protocol                   = "Tcp"
          source_port_range          = "8080"
          destination_port_range     = "80"
          source_address_prefix      = "0.0.0.0/0"
          destination_address_prefix = "10.0.0.0/16"
          access                     = "Allow"
          direction                  = "Inbound"
        },
        { #note that it needs to be case sensitive
          name                       = "test2"
          description                = " "
          protocol                   = "Tcp"
          source_port_range          = "80"
          destination_port_range     = "80"
          source_address_prefix      = "0.0.0.0/0"
          destination_address_prefix = "10.0.0.0/16"
          access                     = "Allow"
          direction                  = "Inbound"
        }
      ]
    }
  }

}