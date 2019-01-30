# Azure Network Terraform module

[![Help Contribute to Open Source](https://www.codetriage.com/innovationnorway/terraform-azurerm-network/badges/users.svg)](https://www.codetriage.com/innovationnorway/terraform-azurerm-network)

Terraform module which creates networking resources on Azure.

These types of resources are supported:

* [Virtual Network](https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html)
* [Subnet](https://www.terraform.io/docs/providers/azurerm/r/subnet.html)
* [Route](https://www.terraform.io/docs/providers/azurerm/r/route.html)
* [Route Table](https://www.terraform.io/docs/providers/azurerm/r/route_table.html)
* [Network Security Group](https://www.terraform.io/docs/providers/azurerm/r/network_security_group.html)
* [Network Watcher](https://www.terraform.io/docs/providers/azurerm/r/network_watcher.html)
* [Firewall](https://www.terraform.io/docs/providers/azurerm/r/firewall.html)

## Usage

```hcl
module "network" {
  source = "innovationnorway/network/azurerm"

  # Resource group
  create_resource_group = true
  resource_group_name   = "my-dev"
  location              = "westeurope"

  # Virtual network
  name           = "my-dev-network"
  address_spaces = ["10.0.0.0/16"]
  dns_servers    = ["20.20.20.20"]

  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  aci_subnets     = ["10.0.128.0/24"]

  # Routes
  public_internet_route_next_hop_type          = "VirtualAppliance"
  public_internet_route_next_hop_in_ip_address = "AzureFirewall"

  # Firewall
  create_firewall = true
  firewall_subnet_address_prefix = "10.0.192.0/24"

  # Tags
  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
```

## Subnets

This module handles creation of these types of subnets:
1. Public - `public_subnets` defines a list of address spaces for public subnets. They can be configured to allow access to the internet either via `VirtualAppliance` or using any other hop type.
1. Private - `private_subnets` defines a list of address spaces for private subnets. They can be configured to access resources using hop type `VnetLocal`.
1. Azure Container Instances (ACI) - `aci_subnets` defines a list of address spaces for ACI subnets where service delegation is set to `Microsoft.ContainerInstance/containerGroups`.
1. Firewall - `firewall_subnet_address_prefix` defines an address prefix for firewall subnet (name `AzureFirewallSubnet`).
1. Gateway - `vnet_gateway_subnet_address_prefix` defines an address prefix for firewall subnet (name `GatewaySubnet`).

It is possible to add other routes to the associated route tables outside of this module.   

This module also creates network security groups for each type of subnet (public, private, etc).

## Create resource group or use an existing one

By default this module will not create a resource group and a name of an existing one should be provided in an argument `resource_group_name`.
If you want to create it using this module, set argument `create_resource_group = true`.

## Firewall

To create Azure Firewall resources (subnet, public IP and firewall) specify `create_firewall = true`.

To enable route to the internet from public subnet via Azure Firewall, firewall has to be created (`create_firewall = true`), set `public_internet_route_next_hop_type = "VirtualAppliance"` and `public_internet_route_next_hop_in_ip_address = "AzureFirewall"`.

## Virtual Network Gateway

Virtual Network Gateway can be configured to:

1. Accept IPSec point-to-site connections:
  * active-standby:
    - [x] with VPN client using certificates - `azurerm_virtual_network_gateway.with_active_standby_vpn_client_and_certificates`
    - [ ] with VPN client using RADIUS server - `azurerm_virtual_network_gateway.with_active_standby_vpn_client_and_radius`
    - [ ] without VPN client (eg, when using `VNet-to-VNet` connection) - `azurerm_virtual_network_gateway.with_active_standby_no_vpn_client`
  * active-active VPN client and certificates:
    - [ ] with VPN client using certificates - `azurerm_virtual_network_gateway.with_active_active_vpn_client_and_certificates`
    - [ ] with VPN client using RADIUS server - `azurerm_virtual_network_gateway.with_active_active_vpn_client_and_radius`
2. Use ExpressRoute type:
  - [ ] active-standby VPN client - `azurerm_virtual_network_gateway.with_vpn_client_active_standby`
  - [ ] active-active VPN client (todo: two `ip_configuration` blocks) - `azurerm_virtual_network_gateway.with_vpn_client_active_active`

### Notes for developers

1. At most single resource of `azurerm_virtual_network_gateway` type is created depending on input arguments
1. `with_active_active_...` contains two `ip_configuration` blocks
1. `with_active_standby_...` contains one `ip_configuration` block
1. `with_..._vpn_client` contains `vpn_client_configuration` block
1. `with_..._no_vpn_client` does not contain `vpn_client_configuration` block
1. `..._and_certificates` contains `root_certificate` and `revoked_certificate` blocks, but does not contain `radius_server_address` and `radius_server_secret` blocks
1. `..._and_radius` contains `radius_server_address` and `radius_server_secret` blocks, but does not contain `root_certificate` and `revoked_certificate` blocks

## Tagging

All network resources which support tagging can be tagged by specifying key-values in arguments like `resource_group_tags`, `virtual_network_tags`, `public_route_table_tags`, `private_route_table_tags`, `tags`. Tag `Name` is added automatically on all resources. For eg, you can specify virtual network tags like this: 

```hcl
module "network" {
  source = "innovationnorway/network/azurerm"

  # ... omitted
  virtual_network_tags = {
    Owner     = "test-user"
    Terraform = "true"
  }
}
```

## Conditional creation

Sometimes you need to have a way to create network resources conditionally but Terraform does not allow to use `count` inside `module` block, so the solution is to specify argument `create_network`.

```hcl
# This network will not be created
module "network" {
  source = "innovationnorway/network/azurerm"

  create_network = false
  # ... omitted
}
```

## Examples

* [Complete network](https://github.com/innovationnorways/terraform-azurerm-network/tree/master/examples/complete)

## Other resources

* [Virtual network documentation (Azure docs)](https://docs.microsoft.com/en-us/azure/virtual-network/)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aci\_subnet\_suffix | Suffix to append to private subnets name | string | `"aci"` | no |
| aci\_subnets | A list of Azure Container Instances (ACI) subnets inside virtual network | list | `[]` | no |
| aci\_subnets\_service\_endpoints | The list of Service endpoints to associate with the ACI subnets. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql and Microsoft.Storage. | list | `[]` | no |
| address\_spaces | List of address spaces to use for virtual network | list | `[]` | no |
| create\_firewall | Whether to create firewall (incl. subnet and public IP)) | string | `"false"` | no |
| create\_network | Controls if networking resources should be created (it affects almost all resources) | string | `"true"` | no |
| create\_network\_security\_group | Whether to create network security group | string | `"true"` | no |
| create\_network\_watcher | Whether to create network watcher | string | `"true"` | no |
| create\_resource\_group | Whether to create resource group and use it for all networking resources | string | `"false"` | no |
| create\_vnet\_gateway | Whether to create virtual network gateway (incl. subnet and public IP)) | string | `"false"` | no |
| dns\_servers | List of dns servers to use for virtual network | list | `[]` | no |
| firewall\_subnet\_address\_prefix | Address prefix to use on firewall subnet. Default is a valid value, which should be overriden. | string | `"0.0.0.0/0"` | no |
| firewall\_suffix | Suffix to append to firewall name | string | `"firewall"` | no |
| firewall\_tags | Additional tags for the firewall | map | `{}` | no |
| location | Location where resource should be created | string | `""` | no |
| name | Name to use on resources | string | `""` | no |
| network\_security\_group\_name | Name to be used on network security group | string | `""` | no |
| network\_security\_group\_tags | Additional tags for the network security group | map | `{}` | no |
| network\_watcher\_suffix | Suffix to append to network watcher name | string | `"nw"` | no |
| network\_watcher\_tags | Additional tags for the network watcher | map | `{}` | no |
| private\_route\_table\_disable\_bgp\_route\_propagation | Boolean flag which controls propagation of routes learned by BGP on private route table. True means disable. | string | `"false"` | no |
| private\_route\_table\_suffix | Suffix to append to private route table name | string | `"private"` | no |
| private\_route\_table\_tags | Additional tags for the private route table | map | `{}` | no |
| private\_subnet\_suffix | Suffix to append to private subnets name | string | `"private"` | no |
| private\_subnets | A list of private subnets inside virtual network | list | `[]` | no |
| private\_subnets\_service\_endpoints | The list of Service endpoints to associate with the private subnets. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql and Microsoft.Storage. | list | `[]` | no |
| private\_vnetlocal\_route\_suffix | Suffix to append to private VnetLocal route name | string | `"private-vnetlocal"` | no |
| public\_internet\_route\_next\_hop\_in\_ip\_address | Contains the IP address packets should be forwarded to when destination is 0.0.0.0/0 for the public subnets. Next hop values are only allowed in routes where the next hop type is VirtualAppliance. | string | `""` | no |
| public\_internet\_route\_next\_hop\_type | The type of Azure hop the packet should be sent when reaching 0.0.0.0/0 for the public subnets. Possible values are VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance and None. | string | `"Internet"` | no |
| public\_internet\_route\_suffix | Suffix to append to public internet route name | string | `"public"` | no |
| public\_route\_table\_disable\_bgp\_route\_propagation | Boolean flag which controls propagation of routes learned by BGP on public route table. True means disable. | string | `"false"` | no |
| public\_route\_table\_suffix | Suffix to append to public route table name | string | `"public"` | no |
| public\_route\_table\_tags | Additional tags for the public route table | map | `{}` | no |
| public\_subnet\_suffix | Suffix to append to public subnets name | string | `"public"` | no |
| public\_subnets | A list of public subnets inside virtual network | list | `[]` | no |
| public\_subnets\_service\_endpoints | The list of Service endpoints to associate with the public subnets. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql and Microsoft.Storage. | list | `[]` | no |
| resource\_group\_name | Name to be used on resource group | string | `""` | no |
| resource\_group\_tags | Additional tags for the resource group | map | `{}` | no |
| tags | A map of tags to add to all resources | map | `{}` | no |
| virtual\_network\_tags | Additional tags for the virtual network | map | `{}` | no |
| vnet\_gateway\_active\_active | If true, an active-active Virtual Network Gateway will be created. An active-active gateway requires a HighPerformance or an UltraPerformance sku. If false, an active-standby gateway will be created. | string | `"false"` | no |
| vnet\_gateway\_bgp\_settings | List of map containing BGP settings. Keys are: asn - (Optional) The Autonomous System Number (ASN) to use as part of the BGP; peering_address - (Optional) The BGP peer IP address of the virtual network gateway. This address is needed to configure the created gateway as a BGP Peer on the on-premises VPN devices. The IP address must be part of the subnet of the Virtual Network Gateway. Changing this forces a new resource to be created.; peer_weight - (Optional) The weight added to routes which have been learned through BGP peering. Valid values can be between 0 and 100. | list | `[ { "asn": 65515 } ]` | no |
| vnet\_gateway\_default\_local\_network\_gateway\_id | The ID of the local network gateway through which outbound Internet traffic from the virtual network in which the gateway is created will be routed (forced tunneling). Refer to the Azure documentation on forced tunneling. If not specified, forced tunneling is disabled. | string | `""` | no |
| vnet\_gateway\_enable\_bgp | If true, BGP (Border Gateway Protocol) will be enabled for this Virtual Network Gateway. | string | `"false"` | no |
| vnet\_gateway\_sku | Configuration of the size and capacity of the virtual network gateway. Valid options are Basic, Standard, HighPerformance, UltraPerformance, ErGw1AZ, ErGw2AZ, ErGw3AZ, VpnGw1, VpnGw2 and VpnGw3 and depend on the type and vpn_type arguments. A PolicyBased gateway only supports the Basic sku. Further, the UltraPerformance sku is only supported by an ExpressRoute gateway. | string | `"Basic"` | no |
| vnet\_gateway\_subnet\_address\_prefix | Address prefix to use on virtual network gateway subnet. Default is a valid value, which should be overriden. | string | `"0.0.0.0/0"` | no |
| vnet\_gateway\_suffix | Suffix to append to virtual network gateway name | string | `"vnet-gateway"` | no |
| vnet\_gateway\_tags | Additional tags for the virtual network gateway | map | `{}` | no |
| vnet\_gateway\_type | The type of the Virtual Network Gateway. Valid options are Vpn or ExpressRoute. | string | `"Vpn"` | no |
| vnet\_gateway\_vpn\_client\_configuration\_address\_space | The address space out of which ip addresses for vpn clients will be taken. You can provide more than one address space, e.g. in CIDR notation. | list | `[ "0.0.0.0/0" ]` | no |
| vnet\_gateway\_vpn\_client\_configuration\_revoked\_certificate | One or more revoked_certificate blocks which are defined below. Type - list of maps, where keys are: name - (Required) A user-defined name of the revoked certificate.; thumbprint - (Required) The SHA1 thumbprint of the certificate to be revoked. | list | `[]` | no |
| vnet\_gateway\_vpn\_client\_configuration\_root\_certificate | One or more root_certificate blocks which are defined below. These root certificates are used to sign the client certificate used by the VPN clients to connect to the gateway. Type - list of maps, where keys are: name - (Required) A user-defined name of the root certificate; public_cert_data - (Required) The public certificate of the root certificate authority. The certificate must be provided in Base-64 encoded X.509 format (PEM). In particular, this argument must not include the -----BEGIN CERTIFICATE----- or -----END CERTIFICATE----- markers. | list | `[]` | no |
| vnet\_gateway\_vpn\_client\_configuration\_vpn\_client\_protocols | List of the protocols supported by the vpn client. The supported values are SSTP, IkeV2 and OpenVPN. | list | `[ "" ]` | no |
| vnet\_gateway\_vpn\_type | The routing type of the Virtual Network Gateway. Valid options are RouteBased or PolicyBased. | string | `"RouteBased"` | no |

## Outputs

| Name | Description |
|------|-------------|
| aci\_network\_security\_group\_id | The Network Security Group ID of ACI subnet |
| aci\_subnet\_address\_prefixes | List of address prefix for ACI subnets |
| aci\_subnet\_ids | List of IDs of ACI subnets |
| firewall\_public\_ip\_id | ID of firewall public IP |
| firewall\_public\_ip\_ip\_address | Public IP of firewall |
| firewall\_subnet\_address\_prefixes | List of address prefix for firewall subnets |
| firewall\_subnet\_ids | List of IDs of firewall subnets |
| gateway\_public\_ip\_id | ID of gateway public IP |
| gateway\_public\_ip\_ip\_address | Public IP of gateway |
| gateway\_subnet\_address\_prefixes | List of address prefix for gateway subnets |
| gateway\_subnet\_ids | List of IDs of gateway subnets |
| private\_network\_security\_group\_id | The Network Security Group ID of private subnet |
| private\_route\_table\_id | ID of private route table |
| private\_route\_table\_subnets | List of subnets associated with private route table |
| private\_subnet\_address\_prefixes | List of address prefix for private subnets |
| private\_subnet\_ids | List of IDs of private subnets |
| public\_network\_security\_group\_id | The Network Security Group ID of public subnet |
| public\_route\_table\_id | ID of public route table |
| public\_route\_table\_subnets | List of subnets associated with public route table |
| public\_subnet\_address\_prefixes | List of address prefix for public subnets |
| public\_subnet\_ids | List of IDs of public subnets |
| this\_firewall\_id | The Resource ID of the Azure Firewall |
| this\_network\_watcher\_id | ID of Network Watcher |
| this\_resource\_group\_id | The ID of the resource group in which resources are created. |
| this\_resource\_group\_location | The location of the resource group in which resources are created |
| this\_resource\_group\_name | The name of the resource group in which resources are created |
| this\_virtual\_network\_address\_space | List of address spaces that are used the virtual network. |
| this\_virtual\_network\_gateway\_id | The ID of the Virtual Network Gateway |
| this\_virtual\_network\_id | The virtual NetworkConfiguration ID. |
| this\_virtual\_network\_name | The name of the virtual network. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by [Anton Babenko](https://github.com/antonbabenko) with help from [these awesome contributors](https://github.com/innovationnorway/terraform-azurerm-network/graphs/contributors).

## License

Apache 2 Licensed. See LICENSE for full details.
