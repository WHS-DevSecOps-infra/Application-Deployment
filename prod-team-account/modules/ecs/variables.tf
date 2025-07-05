variable "project_name" {
  description = "The name of the project for resource naming"
  type        = string
}

# --- IAM 모듈로부터 받을 정보 ---
variable "ecs_task_execution_role_arn" {
  description = "The ARN of the ECS Task Execution Role for tasks to pull images, etc."
  type        = string
}

variable "ecs_instance_profile_name" {
  description = "The name of the IAM instance profile for ECS container instances"
  type        = string
}

# --- VPC 모듈로부터 받을 정보 ---
variable "private_subnet_ids" {
  description = "A list of private subnet IDs for the ECS instances"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "The ID of the security group for the ECS instances"
  type        = string
}

# --- 외부 데이터 소스로부터 받을 정보 ---
variable "golden_ami" {
  description = "The ID of the AMI to use for the ECS instances"
  type        = string
}

variable "ecr_image_url" {
  description = "The full URL of the Docker image in ECR"
  type        = string
}

# --- ALB 모듈로부터 받을 정보 ---
variable "blue_target_group_arn" {
  description = "The ARN of the blue target group from the ALB"
  type        = string
}