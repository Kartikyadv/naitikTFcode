# Provider configuration for ap-south-1 region (Mumbai) with explicit credentials
provider "aws" {
  region     = "ap-south-1"         # Mumbai region
  access_key = var.aws_access_key  # Replace with your AWS access key
  secret_key = var.aws_secret_key  # Replace with your AWS secret key
}

# Security Group to allow SSH access (port 22)
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = "vpc-088420f7860aca4ae"  # Using your provided VPC ID

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance using the specified Ubuntu AMI in ap-south-1
resource "aws_instance" "my_ec2" {
  ami           = "ami-001d198b1662bb7dd"  # The specified Ubuntu AMI ID
  instance_type = "t4g.micro"  # Instance type, replace with your choice
  key_name      = "open-sign"  # The specified key pair name (make sure you have the private key)

  security_groups = [aws_security_group.allow_ssh.id]
  subnet_id       = "subnet-0e9ae471d8daa03d4"  # Using your specified subnet

  tags = {
    Name = "terraform-kartik"  # The EC2 instance will be named "terraform"
  }

  # Optional: User data for bootstrapping the instance (e.g., install software)
  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y apache2
              systemctl start apache2
              systemctl enable apache2
              EOF
}

# Output the public IP of the EC2 instance
output "instance_public_ip" {
  value = aws_instance.my_ec2.public_ip
}

