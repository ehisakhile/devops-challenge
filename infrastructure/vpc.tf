#Create K8s VPC Resource
resource "aws_vpc" "k8s-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
      Name = "${local.environment}-vpc"
    }
}

#Create K8s Public & Private Subnets

#Public subnets
resource "aws_subnet" "k8s-public-subnet" {
    vpc_id = aws_vpc.k8s-vpc.id
    cidr_block = "10.0.5.0/24"
    availability_zone = local.az
    map_public_ip_on_launch = true

    tags = {
        Name = "${local.environment}-public-subnet"
    }
}

#Private subnets
resource "aws_subnet" "k8s-private-subnet" {
    vpc_id = aws_vpc.k8s-vpc.id
    cidr_block = "10.0.6.0/24"
    availability_zone = local.az

    map_public_ip_on_launch = true

    tags = {
        Name = "${local.environment}-private-subnet"
    }
}

# Create Internet Gateway
resource "aws_internet_gateway" "k8s-igw" {
    vpc_id = aws_vpc.k8s-vpc.id

    tags = {
      Name = "${local.environment}-igw"
    }
}

# Create Elastic IPs for NAT Gateways
resource "aws_eip" "k8s-eip" {
    domain = "vpc"
    depends_on = [aws_internet_gateway.k8s-igw]
    tags = {
      Name = "${local.environment}-eip"
    }
}

#Create NAT Gateways
resource "aws_nat_gateway" "k8s-natgateway" {
    subnet_id = aws_subnet.k8s-public-subnet.id

    allocation_id = aws_eip.k8s-eip.id

    depends_on = [aws_internet_gateway.k8s-igw]

    tags = {
      Name = "${local.environment}-nat-gw"
    }
}

#Create Public Route Table
resource "aws_route_table" "k8s-public-rtb" {
    vpc_id = aws_vpc.k8s-vpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.k8s-igw.id
    }

    tags = {
      Name = "${local.environment}-public-rtb"
    }
}

#Create Private Route Table
resource "aws_route_table" "k8s-private-rtb" {

  vpc_id = aws_vpc.k8s-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.k8s-natgateway.id
  }

  tags = {
      Name = "${local.environment}-private-rtb"
    }
}

#Create Route Table Association for Public Subnets
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id = aws_subnet.k8s-public-subnet.id
  route_table_id = aws_route_table.k8s-public-rtb.id
}


#Create Route Table Association for Private Subnets
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id = aws_subnet.k8s-private-subnet.id
  route_table_id = aws_route_table.k8s-private-rtb.id

}
