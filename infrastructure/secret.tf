# Key pair for SSH access
resource "aws_key_pair" "ec2_key" {
  key_name   = "bird-project"
  public_key = file("~/.ssh/bird-project.pub")
}