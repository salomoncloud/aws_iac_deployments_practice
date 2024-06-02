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
# igw
resource "aws_internet_gateway" "iac_igw" {
    vpc_id = aws_vpc.iac_remote_vpc.id 
    tags = {
        "Name" = "${var.vpc_name} Internet Gateway"
    }
}
# Route Table
resource "aws_default_route_table" "iac_route_table" {
    default_route_table_id = aws_vpc.iac_remote_vpc.aws_default_route_table_id
    # default route that will handle all traffic not explicitly known by the route table, in other words for the igw to the internet not local
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.iac_igw.id
    }
    tags = {
        "Name" = "IaC Route Table"
    }
}