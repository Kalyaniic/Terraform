variable "vpc_cidr" {
    type = string
  default = "192.168.0.0/16"
}

variable "vpc_tenancy" {
    type = string
    default = "default"
}

variable "vpc_tags" {
  type = map(string)
  default = {
    Name = "my-vpc"
    team = "DevOps"
  }
}

variable "public_subnet_cidrs" {
    type = list(string)
    default = [ "192.168.0.0/24","192.168.1.0/24","192.168.2.0/24" ]
}

variable "subnet_az" {
  type = list(string)
  default = [ "ap-southeast-2a","ap-southeast-2b","ap-southeast-2c" ]
}

variable "subnet_tag1" {
  type = map(string)
  default = {
    Name = "pub-1"
  }
}

variable "subnet_tag2" {
  type = map(string)
  default = {
    Name = "pub-2"
  }
}

variable "subnet_tag3" {
  type = map(string)
  default = {
    Name = "pub-3"
  }
}

variable "private_subnet_cidr" {
    type = list(string)
    default = [ "192.168.3.0/24","192.168.4.0/24","192.168.5.0/24" ]
}

variable "subnet_tag4" {
  type = map(string)
  default = {
    Name = "private-1"
  }
}

variable "subnet_tag5" {
  type = map(string)
  default = {
    Name = "private-2"
  }
}

variable "subnet_tag6" {
  type = map(string)
  default = {
    Name = "private-3"
  }
}

variable "cidr_block" {
  type = string
  default = "0.0.0.0/0"
}