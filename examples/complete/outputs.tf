output "this_virtual_network_id" {
  description = "The ID of the virtual network"
  value       = "${module.network.this_virtual_network_id}"
}

output "this_virtual_network_address_space" {
  description = "List of address spaces of the virtual network"
  value       = "${module.network.this_virtual_network_address_space}"
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = "${module.network.private_subnet_ids}"
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = "${module.network.public_subnet_ids}"
}
