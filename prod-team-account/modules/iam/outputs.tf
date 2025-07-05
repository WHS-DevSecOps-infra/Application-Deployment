output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS Task Execution Role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "codedeploy_service_role_arn" {
  description = "The ARN of the IAM role for CodeDeploy"
  value       = aws_iam_role.codedeploy_role.arn
}

output "ecs_instance_profile_name" {
  description = "The name of the IAM instance profile for ECS container instances"
  value       = aws_iam_instance_profile.ecs_instance_profile.name
}