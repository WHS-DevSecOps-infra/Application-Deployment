# prod-team-account의 역할 ARN을 변수로 받기
variable "prod_github_actions_role_arn" {
  type        = string
  description = "The ARN of the IAM role for GitHub Actions in prod-team-account"
}

# ECR 리포지토리 정책을 생성하기 위한 IAM 정책 문서 데이터 소스
data "aws_iam_policy_document" "ecr_repo_policy_document" {
  statement {
    sid    = "AllowCrossAccountPush"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [var.prod_github_actions_role_arn]
    }
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload"
    ]
  }
}

# 생성된 정책 문서(JSON)를 output으로 출력
output "ecr_policy_json" {
  description = "The JSON policy document for the ECR repository"
  value       = data.aws_iam_policy_document.ecr_repo_policy_document.json
}