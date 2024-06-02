# creating a vpc for my lab
resource "aws_vpc" "iac_remote_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "iac_remote_vpc"
  }
}