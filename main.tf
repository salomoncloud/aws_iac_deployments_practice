# creating a vpc for my lab
resource "aws_vpc" "iac_remote_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = "IaC Production VPC"
  }
}
# creating a subnet for my vpc 
resource "aws_subnet" "iac_web" {
    vpc_id = aws_vpc.iac_remote_vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.sub_az
    tags = {
        "Name" = "Iac Web Subnet"
    }
}