mock_provider "aws" {}

run "name_defaults_to_random_uuid" {
  command = apply

  variables {
    subnet_ids = ["subnet-1111", "subnet-2222"]
  }

  assert {
    condition     = aws_elasticache_subnet_group.resource.name == random_uuid.resource.id
    error_message = "Leaving name unset should fall back to the generated random_uuid."
  }
}

run "description_defaults_to_a_placeholder" {
  command = plan

  variables {
    subnet_ids = ["subnet-1111", "subnet-2222"]
  }

  assert {
    condition     = aws_elasticache_subnet_group.resource.description == "Managed by Terraform"
    error_message = "AWS rejects an empty description, so it should default to a placeholder rather than null."
  }
}

run "subnet_ids_pass_through" {
  command = plan

  variables {
    subnet_ids = ["subnet-1111", "subnet-2222", "subnet-3333"]
  }

  assert {
    condition     = length(aws_elasticache_subnet_group.resource.subnet_ids) == 3
    error_message = "Every subnet supplied should reach the subnet group."
  }
}

run "readme_default_example" {
  command = plan

  variables {
    name       = "production-cache"
    subnet_ids = ["subnet-1111", "subnet-2222"]
  }
}
