# MasterNode - EC2 instance
resource "aws_instance" "master_node" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.k8s-private-subnet.id
  key_name      = aws_key_pair.ec2_key.key_name
  security_groups = [aws_security_group.ec2_sg.name]

  tags = {
    Name = "${local.environment}-MasterNode"
  }
}

# WorkerNode - EC2 instance
resource "aws_instance" "worker_node" {

  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.k8s-private-subnet.id
  key_name      = aws_key_pair.ec2_key.key_name
  security_groups = [aws_security_group.ec2_sg.name]

  tags = {
    Name = "${local.environment}-WorkerNode"
  }
}
