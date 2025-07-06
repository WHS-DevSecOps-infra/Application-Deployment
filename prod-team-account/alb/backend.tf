terraform {
  backend "s3" {
    bucket         = "cloudfence-tfstate-app"
    key            = "prod-team-account/alb/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "tfstate-lock-app"
    encrypt        = true
  }
}