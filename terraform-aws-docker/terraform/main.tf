data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS account ID for Ubuntu

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 1. Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "docker-vpc"
  }
}

# 2. Create a Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true # Automatically give VMs public IPs
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name = "docker-public-subnet"
  }
}

# 3. Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "docker-igw"
  }
}

# 4. Create a Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "docker-public-rt"
  }
}

# 5. Associate the Route Table with the Subnet
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# 6. Create a Security Group (Firewall)
resource "aws_security_group" "docker_sg" {
  name        = "docker-security-group"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.main_vpc.id

  # Inbound rule for HTTP
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound rule for SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rules (allow all)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "docker-sg"
  }
}

# 7. Create the EC2 Instance (Virtual Machine)
resource "aws_instance" "docker_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id

  # Attach the security group
  vpc_security_group_ids = [aws_security_group.docker_sg.id]

  # Optional optional key_name for SSH access (if provided)
  key_name = var.key_name != "" ? var.key_name : null

  # Pass the shell script to bootstrap Docker and Nginx
  user_data = file("${path.module}/install_docker.sh")

  # Ensure user_data executes exactly once
  user_data_replace_on_change = true

  tags = {
    Name = "Docker-Nginx-Server"
  }
}
