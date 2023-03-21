module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = local.name
  cluster_version = "1.23"

  # This is recommended only for testing purposes
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  enable_irsa = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.public_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    disk_size      = 50
    instance_types = ["t3a.large", "t3.large"]
  }

  eks_managed_node_groups = {
    default = {}
  }

  # Adding required DNS Egress rule for Cert-Manager DNS challenge
  node_security_group_additional_rules = {
    dns_all = {
      description      = "DNS All"
      protocol         = "-1"
      from_port        = 53
      to_port          = 53
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  tags = local.tags
}
