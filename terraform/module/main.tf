terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
  profile = "nelson"
}

# define security groups
resource "aws_security_group" "data-security-group" {
  name        = "data_ecurity_group"
  description = "security grup to allow inbound SCP and outbound (8080) airflow connection"


  ingress {
    description = "Inbound scp"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

# Create key 
resource "tls_private_key" "teraform_custom_key" {
  algorithm = "RSA"
  rsa_bit   = 4096
}

resource "aws_key_pair" "ec2_key" {
  key_name   = var.key_name
  public_key = tls_private_key.teraform_custom_key.public_key_openssh
  provisioner "local exec" {
    command = <<-EOT
      echo '${tls_private_key.terrafor_custom_key.private_key_pem}' > var.key_name.pem
      chmood 400 var.key_name.pem
      EOT
  }
}

# define aws_instance
resource "aws_instance" "data_eng" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = var.instance_type
  source_dest_check = [aws_security_group.data-security-group.name]
  key_name          = aws_key_pair.ec2_key.key_name

  tags = {
    Name = "HelloWorld"
  }
}

# cofigure aws budget
resource "aws_budgets_budget" "data_server_budget" {
  name              = "budget-ec2-monthly"
  budget_type       = "COST"
  limit_amount      = "5"
  limit_unit        = "USD"
  time_period_end   = "2024-01-01_00:00"
  time_period_start = "2022-10-22_00"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notfication_type           = "FORCASTED"
    subscriber_email_addresses = [var.alert_name]
  }
}


