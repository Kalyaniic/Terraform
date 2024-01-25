resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  instance_tenancy = var.vpc_tenancy
 tags = var.vpc_tags
}

resource "aws_subnet" "public_subnet" {
 vpc_id            = aws_vpc.main.id
 cidr_block        = var.public_subnet_cidrs[0]
 availability_zone = var.subnet_az[0]
 tags = var.subnet_tag1
}
 
resource "aws_subnet" "public_subnet2" {
 vpc_id            = aws_vpc.main.id
 cidr_block        = var.public_subnet_cidrs[1]
 availability_zone = var.subnet_az[1]
 tags = var.subnet_tag2
}

resource "aws_subnet" "public_subnet3" {
 vpc_id            = aws_vpc.main.id
 cidr_block        = var.public_subnet_cidrs[2]
 availability_zone = var.subnet_az[2]
 tags = var.subnet_tag3
}


resource "aws_subnet" "private_subnet1" {
 vpc_id            = aws_vpc.main.id
 cidr_block        = var.private_subnet_cidr[0]
 availability_zone = var.subnet_az[0]
 tags = var.subnet_tag4
}

resource "aws_subnet" "private_subnet2" {
 vpc_id            = aws_vpc.main.id
 cidr_block        = var.private_subnet_cidr[1]
 availability_zone = var.subnet_az[1]
 tags = var.subnet_tag5
}

resource "aws_subnet" "private_subnet3" {
 vpc_id            = aws_vpc.main.id
 cidr_block        = var.private_subnet_cidr[2]
 availability_zone = var.subnet_az[2]
 tags = var.subnet_tag6
}


resource "aws_internet_gateway" "igw" {
 vpc_id = aws_vpc.main.id
 tags = {
   Name = "IG"
 }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.elastic.id
  subnet_id     = aws_subnet.private_subnet1.id
  tags = {
    Name = "NAT-GW"
  }
}

resource "aws_eip" "elastic" {
  domain           = "vpc"
  public_ipv4_pool = "ipv4pool-ec2-012345"
  tags = {
    Name = "EIP"
  }
}


resource "aws_route_table" "pub_rt" {
 vpc_id = aws_vpc.main.id
 route {
   cidr_block = var.cidr_block
   gateway_id = aws_internet_gateway.igw.id
 }
 tags = {
   Name = "Public-RT"
 }
}

resource "aws_route_table_association" "pub1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.pub_rt.id
}
resource "aws_route_table_association" "pub2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.pub_rt.id
}
resource "aws_route_table_association" "pub3" {
  subnet_id      = aws_subnet.public_subnet3.id
  route_table_id = aws_route_table.pub_rt.id
}


resource "aws_route_table" "private_rt" {
 vpc_id = aws_vpc.main.id
 route {
   cidr_block = var.cidr_block
   gateway_id = aws_nat_gateway.nat.id
 }
 tags = {
   Name = "Private-RT"
 }
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "private3" {
  subnet_id      = aws_subnet.private_subnet3.id
  route_table_id = aws_route_table.private_rt.id
}
