locals {
  domain = "lab.example.com"
  name   = "eks-lab"
  region = "us-east-2"

  tags = {
    Environment = "sandbox"
    Project     = "EKS Lab"
    Owner       = "Fabricio Mariani"
  }
}
