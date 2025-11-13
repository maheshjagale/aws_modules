variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "fargate_profile_name" {
  description = "Name of the Fargate profile"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for Fargate profile"
  type        = list(string)
}
