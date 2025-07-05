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
    prod_github_actions_role_arn = var.prod_github_actions_role_arn
}

module "ecr" {
    source = "./modules/ecr"
    project_name = var.project_name
    ecr_policy_json = module.iam.ecr_policy_json
}

output "aws_ecr_repository_url" {
    description = "The URL of the ECR repository"
    value       = module.ecr.ecr_repository_url
}