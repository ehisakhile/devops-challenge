# Key pair for SSH access
resource "aws_key_pair" "ec2_key" {
  key_name   = "bird-key"
  public_key = file("~/.ssh/id_rsa.pub")
}