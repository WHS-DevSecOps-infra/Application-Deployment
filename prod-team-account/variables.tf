variable "project_name" {
  description = "프로젝트를 식별하는 이름"
  type        = string
  default     = "cloudfence"
}

variable "vpc_cidr" {
  description = "VPC에 할당할 IP 주소 범위"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "ECS 인스턴스의 타입"
  type        = string
  default     = "t3.micro"
}

variable "ami_owner_id" {
    description = "ECS 인스턴스에 사용할 AMI의 소유자 ID"
    type        = string
    default     = "502676416967" # operation-team-account
}