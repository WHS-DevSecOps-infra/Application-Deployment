variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "cloudfence"
}

variable "prod_github_actions_role_arn" {
  description = "The ARN of the IAM role for GitHub Actions in prod-team-account to grant push access"
  type        = string
  sensitive   = true
}