resource "azurerm_virtual_network" "this" {
  name = var.virtual_network.name
  location = var.resource_group.location
  resource_group_name = var.resource_group.name
  address_space = var.virtual_network.address_space
}

resource "azurerm_subnet" "this" {
  name = var.subnets.name
  resource_group_name = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes = var.subnets.address_prefixes
}

resource "azurerm_network_security_group" "this" {
  name = var.subnets.security_group.name
  location = var.resource_group.location
  resource_group_name = var.resource_group.name

  dynamic "security_rule" {
    for_each = {
      for id, rule in var.subnets.security_group.rules : 
      rule.name => {
        rule = rule
        priority = 100 + id #check is this right? 
      }
    }

    content {
    name                       = security_rule.value.rule.name
    description                = security_rule.value.rule.description
    protocol                   = security_rule.value.rule.protocol
    source_port_range          = security_rule.value.rule.source_port_range
    destination_port_range     = security_rule.value.rule.destination_port_range
    source_address_prefix      = security_rule.value.rule.source_address_prefix
    destination_address_prefix = security_rule.value.rule.destination_address_prefix
    access                     = security_rule.value.rule.access
    priority                   = security_rule.value.priority
    direction                  = security_rule.value.rule.direction
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

