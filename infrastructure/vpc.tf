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
    cidr_block = each.value.cidr_block
    availability_zone = each.value.availability_zone
    for_each = {
        "az1" = {cidr_block = "10.0.1.0/24", availability_zone = local.zone1}
        "az2" = {cidr_block = "10.0.3.0/24", availability_zone = local.zone2}
    }
    map_public_ip_on_launch = true

    tags = {
        Name = "${local.environment}-public-${each.key}"
        "kubernetes.io/cluster/${local.cluster_name}" = "shared"
        "kubernetes.io/role/elb"                      = "1"
    }
}

#Private subnets
resource "aws_subnet" "k8s-private-subnet" {
    vpc_id = aws_vpc.k8s-vpc.id
    cidr_block = each.value.cidr_block
    availability_zone = each.value.availability_zone
    for_each = {
        "az1" = {cidr_block = "10.0.2.0/24", availability_zone = local.zone1}
        "az2" = {cidr_block = "10.0.4.0/24", availability_zone = local.zone2}
    }
    map_public_ip_on_launch = true

    tags = {
        Name = "${local.environment}-private-${each.key}"
        "kubernetes.io/cluster/${local.cluster_name}" = "shared"
        "kubernetes.io/role/elb"                      = "1"
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
    for_each = {
      "az1" = {}
      "az2" = {} 
    }

    tags = {
      Name = "${local.environment}-eip-${each.key}"
    }
}

#Create NAT Gateways
resource "aws_nat_gateway" "k8s-natgateway" {
    for_each = {
      "az1" = aws_subnet.k8s-public-subnet["az1"]
      "az2" = aws_subnet.k8s-public-subnet["az2"]
    }
    subnet_id = each.value.id

    allocation_id = aws_eip.k8s-eip[each.key].id

    depends_on = [aws_internet_gateway.k8s-igw]

    tags = {
      Name = "${local.environment}-${each.key}"
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
    for_each = {
      "az1" = aws_nat_gateway.k8s-natgateway["az1"]
      "az2" = aws_nat_gateway.k8s-natgateway["az2"]
    }

  vpc_id = aws_vpc.k8s-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = each.value.id
  }

  tags = {
      Name = "${local.environment}-private-rtb"
    }
}

#Create Route Table Association for Public Subnets
resource "aws_route_table_association" "public_subnet_association" {
  for_each = aws_subnet.k8s-public-subnet
  subnet_id = each.value.id
  route_table_id = aws_route_table.k8s-public-rtb.id
}


#Create Route Table Association for Private Subnets
resource "aws_route_table_association" "private_subnet_association" {
  for_each = aws_subnet.k8s-private-subnet
  subnet_id = each.value.id
  route_table_id = aws_route_table.k8s-private-rtb[each.key].id

}
