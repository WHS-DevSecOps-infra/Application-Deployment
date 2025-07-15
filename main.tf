terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

# S3 버킷 생성
resource "aws_s3_bucket" "tfstate_app" {
  bucket = "cloudfence-tfstate-app"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "application-deployment"
  }
}

# 버전 관리 활성화
resource "aws_s3_bucket_versioning" "tfstate_app_versioning" {
  bucket = aws_s3_bucket.tfstate_app.id

  versioning_configuration {
    status = "Enabled"
  }
}

# 객체 소유권 충돌 방지
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.tfstate_app.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

# 퍼블릭 접근 차단
resource "aws_s3_bucket_public_access_block" "tfstate_app_block" {
  bucket                  = aws_s3_bucket.tfstate_app.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 기본 암호화 설정
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.tfstate_app.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# DynamoDB 테이블 생성
resource "aws_dynamodb_table" "lock_app" {
  name         = "tfstate-lock-app"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }

  tags = {
    Name        = "Terraform Lock Table"
    Environment = "application-deployment"
  }
}
