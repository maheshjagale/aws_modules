resource "aws_eks_fargate_profile" "main" {
  cluster_name           = var.cluster_name
  fargate_profile_name   = var.fargate_profile_name
  subnet_ids             = var.subnet_ids
  selector {
    namespace = "default"
  }
}
