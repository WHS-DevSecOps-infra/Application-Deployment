variable "project_name" {
  description = "The name of the project to use for the ECR repository name"
  type        = string
}

variable "ecr_policy_json" {
  description = "The JSON policy document from the IAM module to attach to the ECR repository"
  type        = string
  sensitive   = true
}