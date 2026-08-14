module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 20.0"
  cluster_name    = var.cluster_name
  cluster_version = "1.29"
  vpc_id          = aws_vpc.main.id
  subnet_ids      = aws_subnet.private[*].id

  eks_managed_node_groups = {
    default = {
      instance_types = ["m5.large"]
      min_size       = 2
      max_size       = 6
      desired_size   = 3
    }
  }

  enable_irsa = true

  tags = {
    Environment = var.environment
  }
}
