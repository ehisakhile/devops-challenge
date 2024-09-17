locals {
  region = "us-east-1"
  environment = "k8s"
  zone1 = "us-east-1a"
  zone2 = "us-east-1b"
  azs = [local.zone1, local.zone2]
}