# 생성된 정책 문서(JSON)를 output으로 출력
output "ecr_policy_json" {
  description = "The JSON policy document for the ECR repository"
  value       = data.aws_iam_policy_document.ecr_repo_policy_document.json
}