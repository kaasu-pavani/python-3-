
provider "aws" {
region     = "ap-southeast-2"
 }
# Defining CIDR Block for VPC
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

# Defining CIDR Block for Subnet
variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

# Creating the VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "vpc"
  }
}

# Creating the Subnet
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr
  availability_zone = "ap-southeast-2b" }
}

# Creating the Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# Creating the Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "Route to internet"
  }
}

# Associating Route Table with Subnet
resource "aws_route_table_association" "subnet_assoc" { # Inbound Rules
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 7000
    to_port     = 7000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp" from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web SG"
  }
}

# Creating EC2 Instance
resource "aws_instance" "Terraform" {
  ami                         = "ami-076fe60835f136dc9"
  instance_type               = "t2.micro"
  key_name                    = "terra"
  vpc_security_group_ids      = [aws_security_group.py_sg.id]
  subnet_id                   = aws_subnet.main.id
  associate_public_ip_address = true
  user_data                   = file("data.sh")

  tags = {
    Name = "Terraform"
  }
}

# Output the public IP of the instance
output "public_ip" {
  value = aws_instance.Terraform.public_ip
  }

# Variable for AWS region
variable "region" {
  default = "ap-southeast-2b"
}



  
                               
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Rules
  egress {

  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# Creating Security Group
resource "aws_security_group" "py_sg" {
  vpc_id = aws_vpc.main.id
                            
  tags = {
    Name = "subnet"
