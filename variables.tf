variable "AWS_ACCESS_KEY"{}
variable "AWS_SECRET_KEY"{}



variable "region" {
  type = string
  default = "us-east-1"
}


variable "s3_bucket_name_prefix" {
  type = string
  default = "playpen"
}


variable "env" {
  type = string
  default = "dev"
}
