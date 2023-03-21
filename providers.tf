terraform {
  backend "s3" {
    bucket  = "fab-tfstate"
    key     = "eks-lab"
    region  = "us-east-2"
    profile = "bluesentry-sandbox"
    encrypt = true
  }

  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-2"
  profile = "bluesentry-sandbox"
}

# Configure the Helm provider
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}
