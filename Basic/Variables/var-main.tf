
variable "user_name" {
  type    = string
  default = "hanuman"
}

variable "user_path" {
  type    = string
  default = "/"
}

variable "user_list" {
  type    = list(any)
  default = ["himawari", "shinchan", "shiro"]
}

variable "user_tags" {
  type = map(any)
  default = {
    team   = "3-idiots"
    target = "devops"
  }
}

variable "user_any" {
  type = any
  default = {
    a1 = "main"
    a2 = ["m1","m2"]
    a3 = 500
  }
}





#Create instance

variable "ami_any" {
  type = map(string)
  default = {
    owners = "099720109477"
    value  = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
  }
}

variable "instance_type" {
  type    = string
  default = "c5.2xlarge"
}

variable "instance_az" {
  type    = string
  default = "ap-southeast-2a"

}


variable "sg_any" {
  type = map(string)
  default = {
    des   = "allow web traffic"
    vpcid = "vpc-0d136ccd6bf49aaba"
  }
}



data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = [var.ami_any["owners"]]
  filter {
    name   = "name"
    values = [var.ami_any["value"]]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "web" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = var.instance_type
  availability_zone = var.instance_az
  security_groups   = [aws_security_group.allow_tls.name]

}

resource "aws_security_group" "allow_tls" {
  name        = "web-sg"
  description = var.sg_any["des"]
  vpc_id      = var.sg_any["vpcid"]

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_placement_group" "web" {
  name     = "hunky-dory-pg"
  strategy = "cluster"
}