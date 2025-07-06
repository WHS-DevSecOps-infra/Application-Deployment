variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "cloudfence"
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "ecs_service_name" {
  description = "The name of the ECS service"
  type        = string
}

variable "codedeploy_service_role_arn" {
  description = "The ARN of the IAM role for CodeDeploy to use"
  type        = string
}

variable "alb_listener_arn" {
  description = "The ARN of the ALB listener for traffic shifting"
  type        = string
}

variable "blue_target_group_name" {
  description = "The name of the blue target group"
  type        = string
}

variable "green_target_group_name" {
  description = "The name of the green target group"
  type        = string
}