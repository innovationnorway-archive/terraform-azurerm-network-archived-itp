variable "create_network" {
  description = "Controls if networking resources should be created (it affects almost all resources)"
  default     = true
}

variable "create_resource_group" {
  description = "Whether to create resource group and use it for all networking resources"
  default     = false
}

variable "create_network_security_group" {
  description = "Whether to create network security group"
  default     = true
}

variable "create_network_watcher" {
  description = "Whether to create network watcher"
  default     = true
}

variable "resource_group_name" {
  description = "Name to be used on resource group"
  default     = ""
}

variable "network_security_group_name" {
  description = "Name to be used on network security group"
  default     = ""
}

variable "location" {
  description = "Location where resource should be created"
  default     = ""
}

variable "name" {
  description = "Name to use on resources"
  default     = ""
}

variable "address_spaces" {
  description = "List of address spaces to use for virtual network"
  default     = []
}

variable "dns_servers" {
  description = "List of dns servers to use for virtual network"
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside virtual network"
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside virtual network"
  default     = []
}

variable "aci_subnets" {
  description = "A list of Azure Container Instances (ACI) subnets inside virtual network"
  default     = []
}

variable "public_subnets_service_endpoints" {
  description = "The list of Service endpoints to associate with the public subnets. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql and Microsoft.Storage."
  default     = []
}

variable "private_subnets_service_endpoints" {
  description = "The list of Service endpoints to associate with the private subnets. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql and Microsoft.Storage."
  default     = []
}

variable "aci_subnets_service_endpoints" {
  description = "The list of Service endpoints to associate with the ACI subnets. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql and Microsoft.Storage."
  default     = []
}

variable "public_route_table_disable_bgp_route_propagation" {
  description = "Boolean flag which controls propagation of routes learned by BGP on public route table. True means disable."
  default     = false
}

variable "private_route_table_disable_bgp_route_propagation" {
  description = "Boolean flag which controls propagation of routes learned by BGP on private route table. True means disable."
  default     = false
}

variable "public_internet_route_next_hop_type" {
  # More info: https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview
  description = "The type of Azure hop the packet should be sent when reaching 0.0.0.0/0 for the public subnets. Possible values are VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance and None."
  default     = "Internet"
}

variable "public_internet_route_next_hop_in_ip_address" {
  # More info: https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview
  description = "Contains the IP address packets should be forwarded to when destination is 0.0.0.0/0 for the public subnets. Next hop values are only allowed in routes where the next hop type is VirtualAppliance."
  default     = ""
}

# Tags

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "resource_group_tags" {
  description = "Additional tags for the resource group"
  default     = {}
}

variable "virtual_network_tags" {
  description = "Additional tags for the virtual network"
  default     = {}
}

variable "public_route_table_tags" {
  description = "Additional tags for the public route table"
  default     = {}
}

variable "private_route_table_tags" {
  description = "Additional tags for the private route table"
  default     = {}
}

variable "network_security_group_tags" {
  description = "Additional tags for the network security group"
  default     = {}
}

variable "network_watcher_tags" {
  description = "Additional tags for the network watcher"
  default     = {}
}

# Suffixes

variable "public_subnet_suffix" {
  description = "Suffix to append to public subnets name"
  default     = "public"
}

variable "private_subnet_suffix" {
  description = "Suffix to append to private subnets name"
  default     = "private"
}

variable "aci_subnet_suffix" {
  description = "Suffix to append to private subnets name"
  default     = "aci"
}

variable "public_route_table_suffix" {
  description = "Suffix to append to public route table name"
  default     = "public"
}

variable "private_route_table_suffix" {
  description = "Suffix to append to private route table name"
  default     = "private"
}

variable "public_internet_route_suffix" {
  description = "Suffix to append to public internet route name"
  default     = "public"
}

variable "private_vnetlocal_route_suffix" {
  description = "Suffix to append to private VnetLocal route name"
  default     = "private-vnetlocal"
}

variable "network_watcher_suffix" {
  description = "Suffix to append to network watcher name"
  default     = "nw"
}
