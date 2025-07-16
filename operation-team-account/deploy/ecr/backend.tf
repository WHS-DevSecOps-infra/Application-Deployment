terraform {
  backend "s3" {
    bucket         = "cloudfence-operation-state"
    key            = "deploy/ecr.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "s3-operation-lock"
    encrypt        = true
  }
}