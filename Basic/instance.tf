#Create security group and attach to instance


resource "aws_instance" "web" {
  ami           = "ami-04f5097681773b989"
  instance_type = "t3.micro"
  security_groups = [aws_security_group.allow_tls.name]

  tags = {
    Name = "Web-Server"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "web-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = "vpc-0d136ccd6bf49aaba"

  tags = {
    Name = "web-sg"
  }

 ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
}

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]

  }
}



#create AMI and attach to instance

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "web" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.allow_tls.name]

  tags = {
    Name = "Web-Server"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "web-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = "vpc-0d136ccd6bf49aaba"

  tags = {
    Name = "web-sg"
  }

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



#install apache in instance

resource "aws_instance" "instance-for-tera" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = "t3.micro"
  key_name          = "new-key"
  availability_zone = "ap-southeast-2c"
  security_groups   = [aws_security_group.allow_tls.name]
  user_data         = <<-EOF
#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y
sudo systemctl start apache2
sudo bash -c 'echo this is apache web server > /var/www/html/index.html'
EOF

  tags = {
    Name = "web-instance"
  }

}



#install nginx in instance

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    owners = ["099720109477"]
}

module "ec2_instances" {
    source = "terraform-aws-modules/ec2-instance/aws"
    version = "3.5.0"
    count = 1

    name = "ec2-nginx-demo"

    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.nginx_demo.id]
    user_data = file("userdata.tpl")

    tags = {
        Name = "NginxDemo"
    }
}

resource "aws_default_vpc" "default" {

}

resource "aws_security_group" "nginx_demo" {
    name = "nginx_demo"
    description = "SSH on port 22 and HTTP on port 80"
    vpc_id = aws_default_vpc.default.id

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

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }
}

#touch userdata.tpl
#vim userdata.tpl
#!/bin/bash
#sudo apt update -y
#sudo apt-get install nginx -y
#sudo systemctl start nginx
#sudo systemctl enable nginx
#sudo echo "This is my page" > /var/www/html/index.html
#sudo systemctl restart nginx




# key pair

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
output "ubuntu_ami_id" {
  value = [data.aws_ami.ubuntu.id]
}

resource "aws_instance" "instance-for-tera" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = "t3.micro"
  key_name          = "new-key"
  availability_zone = "ap-southeast-2c"
  security_groups   = [aws_security_group.allow_tls.name]
  tags = {
    Name = "web-instance"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "new-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCwVsq2QJ5Vi8FSRUeacpJTLEr/C7sXqR1TNFkTtEdPgAzNWrXZTJWPaCr0hfdnp3Ya7RwJv8jPQvUC7cbxpnug2VdxhnF2Wqrv3SSMuXyflETCfH2/GSkUxHfjglWa2wHxvnW6Bmrt4cCQkJZ/ieAa7G3dS/DwG7G1a62IOM5aC8u3v7uwojekc9N05MWYJa/7dpf8ebON7huAylsOtSX5HRCxhbCNmH2UPiLYARulzChr1R/FPKIEdJSxRbniUGHx6VkqHkhZ6rqtYtTXRpX+b5vTq7B5KmmE9TNgMNngjeiTyrE41NpyrF4+/4BeD6CNKZDZORxLELynt5t0+WptdE9COQPk8DNFRhP11RPbCYHeXWGH1JjnISxSjiYJsHgpxHTjKgecL1zvqjyb2Q0D7REtS2ESVgtQVXlpEOexeWEpbzL8uDeFeJWyySvKnMt39XIJUqB8Zoif1pEIBn6c2YxhRGVMM3OFlAv9jUvSeAMNQGmasayPZAI83qCNV+8= root@ip-172-31-33-1"
}


resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow for security group"
  vpc_id      = "vpc-0d136ccd6bf49aaba"
  tags = {
    Name = "allow_tls"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}