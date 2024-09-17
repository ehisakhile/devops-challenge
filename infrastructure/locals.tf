locals {
  region = "us-west-2"
  environment = "k8s"
  zone1 = "us-east-1a"
  zone2 = "us-east-1b"
  azs = [local.zone1, local.zone2]
}