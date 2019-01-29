# Complete network example

Configuration in this directory creates set of Azure network resources.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which can cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Outputs

| Name | Description |
|------|-------------|
| private\_subnet\_ids | List of IDs of private subnets |
| public\_subnet\_ids | List of IDs of public subnets |
| this\_virtual\_network\_address\_space | List of address spaces of the virtual network |
| this\_virtual\_network\_id | The ID of the virtual network |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
