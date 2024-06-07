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
    default_route_table_id = aws_vpc.iac_remote_vpc.default_route_table_id
    # default route that will handle all traffic not explicitly known by the route table, in other words for the igw to the internet not local
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.iac_igw.id
    }
    tags = {
        "Name" = "IaC Route Table"
    }
}
# security groups
resource "aws_default_security_group" "iac_sg" {
    vpc_id = aws_vpc.iac_remote_vpc.id
    # defining the rules for incoming traffic for ssh and http
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    # whats going to be allowed to leave 
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        # minus one means any protocol
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        "Name" = "Security group for my IaC Environment"
    }
}
# ssh sg
resource "aws_default_security_group" "iac_sg_ssh" {
    vpc_id = aws_vpc.iac_remote_vpc.id
    # defining the rules for incoming traffic for ssh and http
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    # whats going to be allowed to leave 
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        # minus one means any protocol
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        "Name" = "Security group for SSH into my IaC Environment"
    }
}
# s3 creation
resource "aws_s3_bucket" "salomon-iac-bucket-practice" {
  bucket = var.bucket_name

  tags = {
    "Name"      = "${var.bucket_name}"
  }
}
# s3 creation using count function 
/*
resource "aws_s3_bucket" "salomonlubin97" {
  count  = length(var.bucket_names)
  bucket = var.bucket_names[count.index]
}

resource "aws_s3_bucket_acl" "salomonlubin97_acl" {
  count  = length(var.bucket_names)
  bucket = aws_s3_bucket.salomonlubin97[count.index].id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_salomonlubin97" {
  count  = length(var.bucket_names)
  bucket = aws_s3_bucket.salomonlubin97[count.index].id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "example" {
  count  = length(var.bucket_names)
  bucket = aws_s3_bucket.salomonlubin97[count.index].bucket

  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = 5
    }
  }
}
*/
/* another s3 to see object lock 
resource "aws_s3_bucket" "example" {
  bucket = "mybucket"

  object_lock_enabled = true
}

resource "aws_s3_bucket_object_lock_configuration" "example" {
  bucket = aws_s3_bucket.example.bucket

  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = 5
    }
  }
}
*/

# aws ec2 creation with startup script
resource "aws_instance" "iac_vm_instance" {
  ami = var.ami_id
  instance_type = "t3.micro"
  key_name = "iac_key_pair"
  subnet_id = aws_subnet.iac_web.id
  security_groups = [aws_default_security_group.iac_sg.name]
  associate_public_ip_address = true

  tags = {
    "Name" = "${var.ec2_name}"
  }
}