terraform {
  backend "s3" {
    bucket         = "cloudfence-tfstate-app"
    key            = "prod-team/terraform.tfstate" # prod 전용 경로
    region         = "ap-northeast-2"
    dynamodb_table = "tfstate-lock-app"
    encrypt        = true
  }
}