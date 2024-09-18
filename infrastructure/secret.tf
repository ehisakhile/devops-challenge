# Key pair for SSH access
resource "aws_key_pair" "ec2_key" {
  key_name   = "bird-key-pair"
  public_key = file("~/.ssh/bird-key-pair.pub")
}