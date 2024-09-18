#Bastion Host - EC2 Instance

resource "aws_instance" "bastion_host" {
  ami           = "ami-0075013580f6322a1"
  instance_type = "t2.medium"
  key_name      = aws_key_pair.ec2_key.key_name
  subnet_id = aws_subnet.k8s-public-subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  tags = {
    Name = "${local.environment}-Bastion-Host"
  }
}


# MasterNode - EC2 instance
resource "aws_instance" "master_node" {
  ami           = "ami-0075013580f6322a1"
  instance_type = "t2.medium"
  key_name      = aws_key_pair.ec2_key.key_name
  subnet_id = aws_subnet.k8s-private-subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  tags = {
    Name = "${local.environment}-MasterNode"
  }
}

# WorkerNode - EC2 instance
resource "aws_instance" "worker_node" {
  ami           = "ami-0075013580f6322a1"
  instance_type = "t2.medium"
  key_name      = aws_key_pair.ec2_key.key_name
  subnet_id = aws_subnet.k8s-private-subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "${local.environment}-WorkerNode"
  }
}
