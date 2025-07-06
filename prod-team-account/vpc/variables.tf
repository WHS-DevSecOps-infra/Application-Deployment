variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "cloudfence"
}

variable "vpc_id" {
  description = "The ID of the VPC where the ECS cluster will be deployed"
  type        = string
  default     = "cloudfence-vpc"
}