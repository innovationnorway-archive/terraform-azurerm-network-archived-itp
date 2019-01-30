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
  value       = ["${flatten(azurerm_virtual_network.this.*.address_space)}"]
}

# Subnets
output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = ["${flatten(azurerm_subnet.public.*.id)}"]
}

output "public_subnet_address_prefixes" {
  description = "List of address prefix for public subnets"
  value       = ["${flatten(azurerm_subnet.public.*.address_prefix)}"]
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = ["${flatten(azurerm_subnet.private.*.id)}"]
}

output "private_subnet_address_prefixes" {
  description = "List of address prefix for private subnets"
  value       = ["${flatten(azurerm_subnet.private.*.address_prefix)}"]
}

output "aci_subnet_ids" {
  description = "List of IDs of ACI subnets"
  value       = ["${flatten(azurerm_subnet.aci.*.id)}"]
}

output "aci_subnet_address_prefixes" {
  description = "List of address prefix for ACI subnets"
  value       = ["${flatten(azurerm_subnet.aci.*.address_prefix)}"]
}

# Route tables
output "public_route_table_id" {
  description = "ID of public route table"
  value       = "${element(concat(azurerm_route_table.public.*.id, list("")), 0)}"
}

output "public_route_table_subnets" {
  description = "List of subnets associated with public route table"
  value       = ["${flatten(azurerm_route_table.public.*.subnets)}"]
}

output "private_route_table_id" {
  description = "ID of private route table"
  value       = "${element(concat(azurerm_route_table.private.*.id, list("")), 0)}"
}

output "private_route_table_subnets" {
  description = "List of subnets associated with private route table"
  value       = ["${flatten(azurerm_route_table.private.*.subnets)}"]
}

# Network security groups per subnets

output "public_network_security_group_id" {
  description = "The Network Security Group ID of public subnet"
  value       = "${element(concat(azurerm_network_security_group.public.*.id, list("")), 0)}"
}

output "private_network_security_group_id" {
  description = "The Network Security Group ID of private subnet"
  value       = "${element(concat(azurerm_network_security_group.private.*.id, list("")), 0)}"
}

output "aci_network_security_group_id" {
  description = "The Network Security Group ID of ACI subnet"
  value       = "${element(concat(azurerm_network_security_group.aci.*.id, list("")), 0)}"
}

# Network watcher
output "this_network_watcher_id" {
  description = "ID of Network Watcher"
  value       = "${element(concat(azurerm_network_watcher.this.*.id, list("")), 0)}"
}

# Firewall
output "this_firewall_id" {
  description = "The Resource ID of the Azure Firewall"
  value       = "${element(concat(azurerm_firewall.this.*.id, list("")), 0)}"
}

output "firewall_subnet_ids" {
  description = "List of IDs of firewall subnets"
  value       = ["${flatten(azurerm_subnet.firewall.*.id)}"]
}

output "firewall_subnet_address_prefixes" {
  description = "List of address prefix for firewall subnets"
  value       = ["${flatten(azurerm_subnet.firewall.*.address_prefix)}"]
}

output "firewall_public_ip_id" {
  description = "ID of firewall public IP"
  value       = "${element(concat(azurerm_public_ip.firewall.*.id, list("")), 0)}"
}

output "firewall_public_ip_ip_address" {
  description = "Public IP of firewall"
  value       = "${element(concat(azurerm_public_ip.firewall.*.ip_address, list("")), 0)}"
}

# Virtual Gateway
output "this_virtual_network_gateway_id" {
  description = "The ID of the Virtual Network Gateway"
  value       = "${element(concat(azurerm_virtual_network_gateway.with_active_standby_vpn_client_and_certificates.*.id, list("")), 0)}"
}

output "gateway_subnet_ids" {
  description = "List of IDs of gateway subnets"
  value       = ["${flatten(azurerm_subnet.gateway.*.id)}"]
}

output "gateway_subnet_address_prefixes" {
  description = "List of address prefix for gateway subnets"
  value       = ["${flatten(azurerm_subnet.gateway.*.address_prefix)}"]
}

output "gateway_public_ip_id" {
  description = "ID of gateway public IP"
  value       = "${element(concat(azurerm_public_ip.gateway.*.id, list("")), 0)}"
}

output "gateway_public_ip_ip_address" {
  description = "Public IP of gateway"
  value       = "${element(concat(azurerm_public_ip.gateway.*.ip_address, list("")), 0)}"
}
