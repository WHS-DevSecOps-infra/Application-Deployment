terraform {
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
    
}

provider "aws" {
  region = "ap-northeast-2"
}

module "iam" {
    source = "./modules/iam"
    
}

module "ecs" {
    source = "./modules/ecs"
    ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
}

output "github_actions_role_arn" {
    description = "The ARN of the IAM role for GitHub Actions in prod-team-account"
    value       = module.iam.github_actions_role_arn
}