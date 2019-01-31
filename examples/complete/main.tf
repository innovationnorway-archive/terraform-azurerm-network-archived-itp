provider "azurerm" {}

module "network" {
  source = "../../"

  # Resource group
  create_resource_group = true
  resource_group_name   = "complete-example"
  location              = "westeurope"

  # Virtual network
  name = "complete-example-network"

  address_spaces = ["10.0.0.0/16"]
  dns_servers    = ["20.20.20.20"]

  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  aci_subnets     = ["10.0.121.0/24", "10.0.122.0/24", "10.0.123.0/24"]

  private_subnets_service_endpoints = ["Microsoft.Storage"]

  public_internet_route_next_hop_type          = "VirtualAppliance" # "Internet" is default
  public_internet_route_next_hop_in_ip_address = "AzureFirewall"

  # Firewall
  create_firewall                = true
  firewall_subnet_address_prefix = "10.0.125.0/24"

  # Virtual Network Gateway - disabled to save 30 minutes during creation
  create_vnet_gateway                                        = false
  vnet_gateway_subnet_address_prefix                         = "10.0.126.0/24"
  vnet_gateway_vpn_client_configuration_address_space        = ["30.30.0.0/24"]
  vnet_gateway_vpn_client_configuration_vpn_client_protocols = ["SSTP"]

  # Tags
  virtual_network_tags = {
    Owner = "test-user"
  }
}
