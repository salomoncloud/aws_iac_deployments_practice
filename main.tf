# creating a vpc for my lab
resource "aws_vpc" "iac_remote_vpc" {
  cidr_block = "192.168.0.0/24"
  tags = {
    "Name" = "IaC Production VPC"
  }
}
# creating a subnet for my vpc 
resource "aws_subnet" "iac_web" {
    vpc_id = aws_vpc.iac_remote_vpc.id
    cidr_block = "192.168.0.32/27"
    availability_zone = "us-east-1a"
    tags = {
        "Name" = "Iac Web Subnet"
    }
}