#Bastion Host - EC2 Instance

resource "aws_instance" "bastion_host" {
  ami           = "ami-085f9c64a9b75eed5"
  instance_type = "t3.medium"
  key_name      = aws_key_pair.ec2_key.key_name
  subnet_id = aws_subnet.k8s-public-subnet.id
  vpc_security_group_ids = [aws_security_group.bastion_host_sg.id]
  tags = {
    Name = "${local.environment}-Bastion-Host"
  }
}


# MasterNode - EC2 instance
resource "aws_instance" "master_node" {
  ami           = "ami-085f9c64a9b75eed5"
  instance_type = "t3.medium"
  key_name      = aws_key_pair.ec2_key.key_name
  subnet_id = aws_subnet.k8s-private-subnet.id
  vpc_security_group_ids = [aws_security_group.k8s_master_sg.id]
  tags = {
    Name = "${local.environment}-MasterNode"
  }
}

# WorkerNode - EC2 instance
resource "aws_instance" "worker_node" {
  ami           = "ami-085f9c64a9b75eed5"
  instance_type = "t3.medium"
  key_name      = aws_key_pair.ec2_key.key_name
  subnet_id = aws_subnet.k8s-private-subnet.id
  vpc_security_group_ids = [aws_security_group.k8s_worker_sg.id]

  tags = {
    Name = "${local.environment}-WorkerNode"
  }
}
