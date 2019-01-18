# Resource group
output "this_resource_group_id" {
  description = "The ID of the resource group in which resources are created."
  value       = "${element(coalescelist(data.azurerm_resource_group.this.*.id, azurerm_resource_group.this.*.id, list("")), 0)}"
}

output "this_resource_group_name" {
  description = "The name of the resource group in which resources are created"
  value       = "${element(coalescelist(data.azurerm_resource_group.this.*.name, azurerm_resource_group.this.*.name, list("")), 0)}"
}

output "this_resource_group_location" {
  description = "The location of the resource group in which resources are created"
  value       = "${element(coalescelist(data.azurerm_resource_group.this.*.location, azurerm_resource_group.this.*.location, list("")), 0)}"
}

# Virtual network
output "this_virtual_network_id" {
  description = "The virtual NetworkConfiguration ID."
  value       = "${element(concat(azurerm_virtual_network.this.*.id, list("")), 0)}"
}

output "this_virtual_network_name" {
  description = "The name of the virtual network."
  value       = "${element(concat(azurerm_virtual_network.this.*.id, list("")), 0)}"
}

output "this_virtual_network_address_space" {
  description = "List of address spaces that are used the virtual network."
  value       = ["${azurerm_virtual_network.this.*.address_space}"]
}

# Subnets
output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = ["${azurerm_subnet.public.*.id}"]
}

output "public_subnet_address_prefixes" {
  description = "List of address prefix for public subnets"
  value       = ["${azurerm_subnet.public.*.address_prefix}"]
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = ["${azurerm_subnet.private.*.id}"]
}

output "private_subnet_address_prefixes" {
  description = "List of address prefix for private subnets"
  value       = ["${azurerm_subnet.private.*.address_prefix}"]
}

# Route tables
output "public_route_table_id" {
  description = "ID of public route table"
  value       = "${element(concat(azurerm_route_table.public.*.id, list("")), 0)}"
}

output "public_route_table_subnets" {
  description = "List of subnets associated with public route table"
  value       = ["${azurerm_route_table.public.*.subnets}"]
}

output "private_route_table_id" {
  description = "ID of private route table"
  value       = "${element(concat(azurerm_route_table.private.*.id, list("")), 0)}"
}

output "private_route_table_subnets" {
  description = "List of subnets associated with private route table"
  value       = ["${azurerm_route_table.private.*.subnets}"]
}
