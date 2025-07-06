terraform {
  backend "s3" {
    bucket         = "cloudfence-tfstate-app"
    key            = "operation-team-account/ecr/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "tfstate-lock-app"
  }
}