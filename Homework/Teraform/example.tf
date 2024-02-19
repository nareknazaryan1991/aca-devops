# main.tf

# Define provider
provider "aws" {
  region = "us-east-1" # You can change the region as needed
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Create a public subnet within the VPC
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24" # Change this CIDR block as needed
  availability_zone       = "us-east-1a"   # Change the availability zone as needed
  map_public_ip_on_launch = true
}

# Create an Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

# Attach the Internet Gateway to the VPC
resource "aws_vpc_attachment" "my_igw_attachment" {
  vpc_id             = aws_vpc.my_vpc.id
  internet_gateway_id = aws_internet_gateway.my_igw.id
}

# Create a security group for the EC2 instance
resource "aws_security_group" "my_security_group" {
  vpc_id = aws_vpc.my_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance in the public subnet
resource "aws_instance" "my_ec2_instance" {
  ami             = "ami-xxxxxxxxxxxxxxxxx" # Specify the AMI ID for your preferred image
  instance_type   = "t2.micro"             # Change the instance type as needed
  subnet_id       = aws_subnet.public_subnet.id

  tags = {
    Name = "MyEC2Instance"
  }
}

# Output the public IP of the EC2 instance
output "ec2_instance_public_ip" {
  value = aws_instance.my_ec2_instance.public_ip
}
