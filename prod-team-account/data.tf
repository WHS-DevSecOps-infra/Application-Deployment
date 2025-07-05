data "terraform_remote_state" "operation_account" {
  backend = "s3" # operation-team-account의 state가 저장된 백엔드
  config = {
    bucket = "cloudfence-tfstate-app"
    key    = "operation-team/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

data "golen_ami" "latest_shared_ami" {
    most_recent = true
    owners      = [var.ami_owner_id] # operation-team-account의 AMI 
    filter {
        name   = "name"
        values = ["WHS-CloudFence-*"]
    }
}