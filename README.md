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

It is possible to add other routes to the associated route tables outside of this module.   

This module also creates network security groups for each type of subnet (public, private, etc).

## Create resource group or use an existing one

By default this module will not create a resource group and a name of an existing one should be provided in an argument `resource_group_name`.
If you want to create it using this module, set argument `create_resource_group = true`.

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
| create\_network | Controls if networking resources should be created (it affects almost all resources) | string | `"true"` | no |
| create\_network\_security\_group | Whether to create network security group | string | `"true"` | no |
| create\_network\_watcher | Whether to create network watcher | string | `"true"` | no |
| create\_resource\_group | Whether to create resource group and use it for all networking resources | string | `"false"` | no |
| dns\_servers | List of dns servers to use for virtual network | list | `[]` | no |
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

## Outputs

| Name | Description |
|------|-------------|
| aci\_network\_security\_group\_id | The Network Security Group ID of ACI subnet |
| aci\_subnet\_address\_prefixes | List of address prefix for ACI subnets |
| aci\_subnet\_ids | List of IDs of ACI subnets |
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
| this\_network\_watcher\_id | ID of Network Watcher |
| this\_resource\_group\_id | The ID of the resource group in which resources are created. |
| this\_resource\_group\_location | The location of the resource group in which resources are created |
| this\_resource\_group\_name | The name of the resource group in which resources are created |
| this\_virtual\_network\_address\_space | List of address spaces that are used the virtual network. |
| this\_virtual\_network\_id | The virtual NetworkConfiguration ID. |
| this\_virtual\_network\_name | The name of the virtual network. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by [Anton Babenko](https://github.com/antonbabenko) with help from [these awesome contributors](https://github.com/innovationnorway/terraform-azurerm-network/graphs/contributors).

## License

Apache 2 Licensed. See LICENSE for full details.
