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


module "vpc" {
    source = "./modules/vpc"
    vpc_cide = var.vpc_cidr
    project_name = var.project_name
}


module "alb" {
    source = "./modules/alb"
    project_name = var.project_name
    vpc_id                = module.vpc.vpc_id
    public_subnet_ids     = module.vpc.public_subnet_ids
    alb_security_group_id = module.vpc.alb_security_group_id
}

module "codedeploy" {
    source = "./modules/codedeploy"
    project_name            = var.project_name
    ecs_cluster_name        = module.ecs.cluster_name
    ecs_service_name        = module.ecs.service_name
    alb_listener_arn        = module.alb.listener_arn
    blue_target_group_name  = module.alb.blue_target_group_name
    green_target_group_name = module.alb.green_target_group_name
    ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
}

module "ecs" {
    source = "./modules/ecs"
    project_name = var.project_name
    ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
    ecs_instance_profile_name = module.iam.ecs_instance_profile_name
    private_subnet_ids = module.vpc.private_subnet_ids
    ecs_security_group_id = module.vpc.ecs_security_group_id
    blue_target_group_arn = module.alb.blue_target_group_arn
    green_target_group_arn = module.alb.green_target_group_arn
    golden_ami = data.aws_ami.latest_shared_ami.id
    ecr_image_url = data.terraform_remote_state.operation_account.outputs.ecr_repository_url

}

module "iam" {
    source = "./modules/iam"
    project_name = var.project_name
}



output "github_actions_role_arn" {
    description = "The ARN of the IAM role for GitHub Actions in prod-team-account"
    value       = module.iam.github_actions_role_arn
}