terraform {
  backend "s3" {
    bucket         = "cloudfence-prod-state"
    key            = "prod-team-account/alb/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "s3-prod-lock"
    encrypt        = true
  }
}