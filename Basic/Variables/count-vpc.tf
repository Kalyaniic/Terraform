resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  instance_tenancy = var.vpc_tenancy
 tags = merge(var.common_tag, {Name = "${var.name}-vpc"})
}

resource "aws_subnet" "public_subnet" {
 count = length(var.public_cidr)
 vpc_id            = aws_vpc.main.id
 cidr_block        = element(var.public_cidr, count.index)
 availability_zone = var.subnet_az[0]
 map_public_ip_on_launch = true
 tags = merge(var.common_tag, {Name = "${var.name}-public-${count.index + 1}"})
}



resource "aws_subnet" "private_subnet1" {
 count = length(var.private_cidr)
 vpc_id            = aws_vpc.main.id
 cidr_block        = element(var.private_cidr, count.index)
 availability_zone = var.subnet_az[0]
 tags = merge(var.common_tag, {Name = "${var.name}-private-${count.index + 1}"})
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
