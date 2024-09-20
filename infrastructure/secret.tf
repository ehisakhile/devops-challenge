# Key pair for SSH access
resource "aws_key_pair" "ec2_key" {
  key_name   = "ohio-key"
  public_key = file("~/.ssh/ohio-key.pub")
}