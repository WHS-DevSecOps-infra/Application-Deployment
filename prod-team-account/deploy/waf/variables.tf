variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "cloudfence"
}

variable "bucket_name" {
  description = "The name of the S3 bucket for WAF logs"
  type        = string

}