locals {
  location            = "${element(coalescelist(data.azurerm_resource_group.this.*.location, azurerm_resource_group.this.*.location, list(var.location)), 0)}"
  resource_group_name = "${element(coalescelist(data.azurerm_resource_group.this.*.name, azurerm_resource_group.this.*.name, list("")), 0)}"

  virtual_network_name = "${element(concat(azurerm_virtual_network.this.*.name, list("")), 0)}"
}

data "azurerm_resource_group" "this" {
  count = "${var.create_network && (1 - var.create_resource_group) != 0 ? 1 : 0}"

  name = "${var.resource_group_name}"
}

resource "azurerm_resource_group" "this" {
  count = "${var.create_network && var.create_resource_group ? 1 : 0}"

  name     = "${var.resource_group_name}"
  location = "${var.location}"

  tags = "${merge(map("Name", format("%s", var.resource_group_name)), var.tags, var.resource_group_tags)}"
}

resource "azurerm_virtual_network" "this" {
  count = "${var.create_network ? 1 : 0}"

  resource_group_name = "${local.resource_group_name}"
  location            = "${local.location}"

  name          = "${var.name}"
  address_space = ["${var.address_spaces}"]
  dns_servers   = ["${var.dns_servers}"]

  tags = "${merge(map("Name", format("%s", var.name)), var.tags, var.virtual_network_tags)}"
}

#################
# Public subnet
#################
resource "azurerm_subnet" "public" {
  count = "${var.create_network && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0}"

  resource_group_name = "${local.resource_group_name}"

  name                 = "${format("%s-${var.public_subnet_suffix}-%d", var.name, count.index)}"
  address_prefix       = "${element(var.public_subnets, count.index)}"
  virtual_network_name = "${local.virtual_network_name}"

  service_endpoints = ["${var.public_subnets_service_endpoints}"]

  lifecycle {
    ignore_changes = [
      # Ignoring changes in route_table_id attribute to prevent dependency between azurerm_subnet and azurerm_subnet_route_table_association as describe here: https://www.terraform.io/docs/providers/azurerm/r/subnet_route_table_association.html
      # This should not be necessary in AzureRM Provider (2.0)
      "route_table_id"
    ]
  }
}

#################
# Private subnet
#################
resource "azurerm_subnet" "private" {
  count = "${var.create_network && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"

  resource_group_name = "${local.resource_group_name}"

  name                 = "${format("%s-%s-%d", var.name, var.private_subnet_suffix, count.index)}"
  address_prefix       = "${element(var.private_subnets, count.index)}"
  virtual_network_name = "${local.virtual_network_name}"

  service_endpoints = ["${var.private_subnets_service_endpoints}"]

  lifecycle {
    ignore_changes = [
      # Ignoring changes in route_table_id attribute to prevent dependency between azurerm_subnet and azurerm_subnet_route_table_association as describe here: https://www.terraform.io/docs/providers/azurerm/r/subnet_route_table_association.html
      # This should not be necessary in AzureRM Provider (2.0)
      "route_table_id"
    ]

  }
}

###################################
# Container Instances (ACI) subnet
###################################
resource "azurerm_subnet" "aci" {
  count = "${var.create_network && length(var.aci_subnets) > 0 ? length(var.aci_subnets) : 0}"

  resource_group_name = "${local.resource_group_name}"

  name                 = "${format("%s-%s-%d", var.name, var.aci_subnet_suffix, count.index)}"
  address_prefix       = "${element(var.aci_subnets, count.index)}"
  virtual_network_name = "${local.virtual_network_name}"

  service_endpoints = ["${var.aci_subnets_service_endpoints}"]

  delegation {
    name = "aci-delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

#################
# Route tables
#################
resource "azurerm_route_table" "public" {
  count = "${var.create_network && length(var.public_subnets) > 0 ? 1 : 0}"

  resource_group_name = "${local.resource_group_name}"
  location            = "${local.location}"

  name                          = "${format("%s-%s", var.name, var.public_route_table_suffix)}"
  disable_bgp_route_propagation = "${var.public_route_table_disable_bgp_route_propagation}"

  tags = "${merge(map("Name", format("%s-%s", var.name, var.public_route_table_suffix)), var.tags, var.public_route_table_tags)}"
}

resource "azurerm_route_table" "private" {
  count = "${var.create_network && length(var.private_subnets) > 0 ? 1 : 0}"

  resource_group_name = "${local.resource_group_name}"
  location            = "${local.location}"

  name                          = "${format("%s-%s", var.name, var.private_route_table_suffix)}"
  disable_bgp_route_propagation = "${var.private_route_table_disable_bgp_route_propagation}"

  tags = "${merge(map("Name", format("%s-%s", var.name, var.private_route_table_suffix)), var.tags, var.private_route_table_tags)}"
}

#################
# Public routes
#################
resource "azurerm_route" "public_internet_not_virtualappliance" {
  count = "${var.create_network && length(var.public_subnets) > 0 && lower(var.public_internet_route_next_hop_type) != lower("VirtualAppliance") ? 1 : 0}"

  resource_group_name = "${local.resource_group_name}"

  name             = "${format("%s-%s-%s", var.name, var.public_internet_route_suffix, lower(var.public_internet_route_next_hop_type))}"
  route_table_name = "${azurerm_route_table.public.name}"
  address_prefix   = "0.0.0.0/0"
  next_hop_type    = "${var.public_internet_route_next_hop_type}"
}

resource "azurerm_route" "public_internet_virtualappliance" {
  count = "${var.create_network && length(var.public_subnets) > 0 && lower(var.public_internet_route_next_hop_type) == lower("VirtualAppliance") ? 1 : 0}"

  resource_group_name = "${local.resource_group_name}"

  name                   = "${format("%s-%s-%s", var.name, var.public_internet_route_suffix, lower(var.public_internet_route_next_hop_type))}"
  route_table_name       = "${azurerm_route_table.public.name}"
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "${var.public_internet_route_next_hop_type}"
  next_hop_in_ip_address = "${var.public_internet_route_next_hop_in_ip_address}"                                                               # ${azurerm_firewall.main.ip_configuration.0.private_ip_address}
}

#################
# Private routes
#################

# Allow access to Virtual network
resource "azurerm_route" "private_vnetlocal" {
  count = "${var.create_network && length(var.private_subnets) > 0 ? 1 : 0}"

  resource_group_name = "${local.resource_group_name}"

  name             = "${format("%s-%s", var.name, var.private_vnetlocal_route_suffix)}"
  route_table_name = "${azurerm_route_table.private.name}"
  address_prefix   = "${element(var.address_spaces, 0)}"
  next_hop_type    = "VnetLocal"
}

###########################
# Route table associations
###########################
resource "azurerm_subnet_route_table_association" "public" {
  count = "${var.create_network && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0}"

  subnet_id      = "${element(azurerm_subnet.public.*.id, count.index)}"
  route_table_id = "${element(azurerm_route_table.public.*.id, count.index)}"
}

resource "azurerm_subnet_route_table_association" "private" {
  count = "${var.create_network && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"

  subnet_id      = "${element(azurerm_subnet.private.*.id, count.index)}"
  route_table_id = "${element(azurerm_route_table.private.*.id, count.index)}"
}

//
//azurerm_network_security_group + rule for private (no inbound access from outside, but allow access from vnet)
//
//azurerm_network_security_group + rule for public (no rules, because there are no restrictions)


##################
# Network watcher
##################
resource "azurerm_network_watcher" "this" {
  count = "${var.create_network && var.create_network_watcher ? 1 : 0}"

  name          =  "${format("%s-%s", var.name, var.network_watcher_suffix)}"
  location            = "${local.location}"
  resource_group_name = "${local.resource_group_name}"

  tags = "${merge(map("Name", format("%s-%s", var.name, var.network_watcher_suffix)), var.tags, var.network_watcher_tags)}"
}
