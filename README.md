# terraform-aws-elasticache-subnet-group

Terraform module for an ElastiCache subnet group — the set of subnets a
cache may place its nodes in.

## Cost

Cache subnet groups carry no charge. This module has no cost impact of
its own.

## Design

Split from
[`terraform-aws-elasticache-replication-group`](https://github.com/kn47ytv9mv/terraform-aws-elasticache-replication-group)
for the same reason
[`terraform-aws-db-subnet-group`](https://github.com/kn47ytv9mv/terraform-aws-db-subnet-group)
is split from the database modules: one group is routinely shared by
several caches, and the cache references it by name from outside.

Span at least two availability zones. A single-AZ group cannot host a
replication group with automatic failover, which
`terraform-aws-elasticache-replication-group` enables by default — so a
one-zone group fails at cache creation rather than here.

`description` defaults to a placeholder because AWS rejects an empty
one, the same constraint the replication group module carries.

## Usage

```hcl
module "cache_subnets" {
  source = "kn47ytv9mv/elasticache-subnet-group/aws"

  name       = "production-cache"
  subnet_ids = module.vpc.subnet_ids["database"]
}

module "cache" {
  source = "kn47ytv9mv/elasticache-replication-group/aws"

  replication_group_id = "sessions"
  node_type            = "cache.t4g.micro"
  num_cache_clusters   = 2

  subnet_group_name = module.cache_subnets.name
}
```

Or directly from this repository:

```hcl
module "cache_subnets" {
  source = "github.com/kn47ytv9mv/terraform-aws-elasticache-subnet-group"

  name       = "production-cache"
  subnet_ids = ["subnet-1111", "subnet-2222"]
}
```

## Requirements

| Name | Version |
|---|---|
| terraform | >= 1.0 |
| aws | ~> 6.61 |
| random | ~> 3.9 |

## Providers

| Name | Version |
|---|---|
| aws | ~> 6.61 |
| random | ~> 3.9 |

## Inputs

| Name | Description | Default | Required |
|---|---|---|---|
| name | Name of the subnet group. If null, a unique name is generated. | `null` | no |
| description | Description of the subnet group. AWS requires a non-empty value. | `"Managed by Terraform"` | no |
| subnet_ids | IDs of the subnets this group spans. Span at least two availability zones, or a replication group with automatic failover cannot be created in it. | `null` | no |
| tags | A map of tags to assign to the subnet group. | `null` | no |

## Outputs

| Name | Description |
|---|---|
| id | The ID (name) of the subnet group. |
| arn | The ARN of the subnet group. |
| name | The name of the subnet group. Feed this into `terraform-aws-elasticache-replication-group`'s `subnet_group_name`. |

## License

MIT — see [LICENSE.md](LICENSE.md).
