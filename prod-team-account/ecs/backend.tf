terraform {
  backend "s3" {
    bucket         = "cloudfence-tfstate-app"
    key            = "prod-team-account/ecs/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "tfstate-lock-app"
    encrypt        = true
  }
}