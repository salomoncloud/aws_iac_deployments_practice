# creating a vpc for my lab
resource "aws_vpc" "iac_remote_vpc" {
  cidr_block = "192.168.0.0/24"
  tags = {
    "Name" = "IaC Production VPC"
  }
}