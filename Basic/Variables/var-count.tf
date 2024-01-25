variable "vpc_cidr" {
    type = string
  default = "192.168.0.0/16"
}

variable "vpc_tenancy" {
    type = string
    default = "default"
}


variable "public_cidr" {
    type = list(string)
    default = [ "192.168.0.0/24","192.168.1.0/24","192.168.2.0/24" ]
}

variable "private_cidr" {
  type = list(string)
  default = ["192.168.3.0/24","192.168.4.0/24","192.168.5.0/24"]
}

variable "subnet_az" {
  type = list(string)
  default = [ "ap-southeast-2a","ap-southeast-2b","ap-southeast-2c" ]
}


variable "cidr_block" {
  type = string
  default = "0.0.0.0/0"
}

variable "name" {
  type = string
  default = "Dev"
}

variable "common_tag" {
  type = map
  default = {
  project ="Devops"
  task = "Infra"
  }
}