variable "name" {
  default     = null
  description = "Name of the subnet group. If null, a unique name is generated."
}

variable "description" {
  default     = "Managed by Terraform"
  description = "Description of the subnet group. AWS requires a non-empty value, so this defaults to a placeholder rather than null."
}

variable "subnet_ids" {
  default     = null
  description = "IDs of the subnets this group spans, from terraform-aws-vpc-subnet or terraform-aws-vpc's subnet_ids output. Span at least two availability zones — a single-AZ group cannot host a replication group with automatic failover, which is the default in terraform-aws-elasticache-replication-group."
}

variable "tags" {
  default     = null
  description = "A map of tags to assign to the subnet group."
}
