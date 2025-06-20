variable "project_name" {
  description = "프로젝트를 식별하는 이름"
  type        = string
  default     = "WHS-CloudFence"
}

variable "vpc_cidr" {
  description = "VPC에 할당할 IP 주소 범위"
  type        = string
  default     = "10.0.0.0/16"
}

variable "custom_ami_id" {
  description = "ECS 인스턴스에 사용할 사용자 정의 AMI ID"
  type        = string
  # 중요: 반드시 본인의 리전에 맞는 최신 ECS 최적화 AMI ID로 변경하세요.
  default     = "ami-0c55b159cbfafe1f0" 
}

variable "instance_type" {
  description = "ECS 인스턴스의 타입"
  type        = string
  default     = "t3.micro"
}