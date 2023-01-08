variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "instance_type" {
  description = "isntance type for EC2"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "EC2 key"
  type        = string
  name        = "data_eng_key_pair"
}


variable "alert_name" {
  description = "Threshold email alert"
  type        = string
  name        = "ogbeide331@gmail.com"
}