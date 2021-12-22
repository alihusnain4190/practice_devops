terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}
data "aws_vpc" "main" {
  id = "vpc-06144ef3257df89e3"
}

resource "aws_security_group" "sg_my_server" {
  name        = "sg_my_server"
  description = "Allow TLS inbound traffic"
vpc_id      = data.aws_vpc.main.id
    
  ingress = [{
    description      = "SSH "
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["51.198.143.96/32"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
    },

    {
      description      = "HTTP "
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }

  ]

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }

  tags = {
    Name = "allow_tls"
  }
}

data "template_file" "user_data" {
  template = file("./userdata.yaml")
}

resource "aws_instance" "my_server" {
  ami           = "ami-0ed9277fb7eb570c9"
  instance_type = "t2.micro"
  key_name               = "key-pair"
  vpc_security_group_ids = [aws_security_group.sg_my_server.id]
  user_data = data.template_file.user_data.rendered
  tags = {
    Name = "ali husnain"
  }
}

output "my_server" {
  value = aws_instance.my_server.public_ip
}
output "user" {
  value=aws_instance.my_server.user_data
}