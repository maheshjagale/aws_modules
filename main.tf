terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "ec2" {
  source = "./modules/ec2"
  instance_type = var.instance_type
  ami_id = var.ami_id
  subnet_id = module.vpc.public_subnet_ids[0]
  security_group_ids = [module.vpc.default_security_group_id]
}

module "s3" {
  source = "./modules/s3"
  bucket_name = var.bucket_name
}

module "iam" {
  source = "./modules/iam"
  iam_policy_arn = var.iam_policy_arn
}

module "eks" {
  source = "./modules/eks"
  cluster_name = var.cluster_name
  subnet_ids = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids)
}

module "eks_fargate" {
  source = "./modules/eks_fargate"
  cluster_name = module.eks.cluster_name
  fargate_profile_name = var.fargate_profile_name
}

module "load_balancer" {
  source = "./modules/load_balancer"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
}

module "lambda" {
  source = "./modules/lambda"
  function_name = var.function_name
  runtime = var.runtime
  handler = var.handler
  filename = var.filename
}
