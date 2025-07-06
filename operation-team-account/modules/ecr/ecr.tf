# CI/CD Test
# iam.tf에서 만든 정책 JSON을 받을 변수 선언
variable "ecr_policy_json" {
  type        = string
  description = "The JSON policy to attach to the ECR repository"
}

# ECR 리포지토리 생성
resource "aws_ecr_repository" "app_ecr_repo" {
  name                 = var.project_name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# 정책을 리포지토리에 연결
resource "aws_ecr_repository_policy" "app_ecr_repo_policy" {
  repository = aws_ecr_repository.app_ecr_repo.name
  policy     = var.ecr_policy_json # 변수로 받은 정책을 사용
}