data "terraform_remote_state" "operation_account" {
  backend = "s3" # operation-team-account의 state가 저장된 백엔드
  config = {
    bucket = "cloudfence-tfstate-app"
    key    = "operation-team/terraform.tfstate"
    region = "ap-northeast-2"
  }
}
