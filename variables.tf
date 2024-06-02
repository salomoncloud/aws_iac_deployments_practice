variable "aws_access_key_id" {
type = string
}

variable "aws_secret_access_key" {
type = string
}

variable "vpc_cidr_block" {
    type = string
    default = "192.168.0.0/24"
}

variable "subnet_cidr_block" {
    type = string
    default = "192.168.0.32/27"
}

variable "sub_az" {
    type = string
    default = "us-east-1a"
}

variable "aws_region" {
    type = string
    default = "us-east-1"
}

variable "vpc_name" {
}