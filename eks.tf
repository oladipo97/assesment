data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}

module "eks" {
  source  = "registry.terraform.io/terraform-aws-modules/eks/aws"
  version = "18.31.2"

  # Required
  cluster_name    = "eks-${var.environment_name}"
  cluster_version = "1.31"
  subnet_ids      = concat(module.shared_vpc.public_subnets, module.shared_vpc.private_subnets)
  vpc_id          = module.shared_vpc.vpc_id

  prefix_separator                   = ""
  iam_role_name                      = "eks-${var.environment_name}"
  cluster_security_group_name        = "eks-${var.environment_name}"
  cluster_security_group_description = "EKS cluster security group."

  node_security_group_tags = {
    "kubernetes.io/cluster/eks-sandbox" = null
  }

  node_security_group_additional_rules = {
    egress_rds = {
      description      = "MSSQL"
      protocol        = "tcp"
      from_port        = 1433
      to_port          = 1433
      type             = "ingress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
    egress_aurora = {
      description      = "Postgres"
      protocol        = "tcp"
      from_port        = 5432
      to_port          = 5432
      type             = "ingress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
      addon_version = "v1.11.4-eksbuild.2"
    }
    kube-proxy = {
      resolve_conflicts = "OVERWRITE"
      addon_version = "v1.30.7-eksbuild.2"
    }
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
      addon_version = "v1.19.2-eksbuild.1"
    }
  }

  # Optional
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  cloudwatch_log_group_retention_in_days = 90
  enable_irsa                     = true
  create_iam_role                 = true

  eks_managed_node_groups = {
    main = {
      name             = "main"
      ami_type         = "AL2_ARM_64"
      capacity_type    = "ON_DEMAND"
      desired_size     = 5
      min_size         = 5
      max_size         = 5
      disk_size        = 40
      disk_type        = "gp3"
      instance_types   = ["r6g.large"]
      name_prefix      = "eks-${var.environment_name}"
      subnet_ids       = module.shared_vpc.private_subnets
      version          = "1.31"
      create_security_group = false
      create_launch_template = false
      launch_template_name   = ""
      force_update_version = true
    }
    geoserver = {
      name             = "geoserver"
      ami_type         = "AL2_x86_64"
      capacity_type    = "ON_DEMAND"
      desired_size     = var.geoserver_desired_capacity
      min_size         = var.geoserver_desired_capacity
      max_size         = var.geoserver_desired_capacity
      disk_size        = 20
      disk_type        = "gp3"
      instance_types   = [ var.geoserver_instance_type ]
      name_prefix      = "eks-${var.environment_name}"
      subnet_ids       = module.shared_vpc.private_subnets
      version          = "1.31"
      taints           = [
        {
          key = "type"
          value = "geoserver"
          effect = "NO_SCHEDULE"
        }
      ]
      labels = {
        type = "geoserver"
      }
      create_security_group = false
      create_launch_template = false
      launch_template_name   = ""
      force_update_version = true
    }
    batch = {
      name             = "batch"
      ami_type         = "AL2_ARM_64"
      capacity_type    = "ON_DEMAND"
      desired_size     = var.batch_desired_capacity
      min_size         = var.batch_desired_capacity
      max_size         = var.batch_desired_capacity
      disk_size        = 20
      disk_type        = "gp3"
      instance_types   = [ var.batch_instance_type ]
      name_prefix      = "eks-${var.environment_name}"
      subnet_ids       = module.shared_vpc.private_subnets
      version          = "1.31"
      taints           = [
        {
          key = "type"
          value = "batch"
          effect = "NO_SCHEDULE"
        }
      ]
      labels = {
        type = "batch"
      }
      create_security_group = false
      create_launch_template = false
      launch_template_name   = ""
      force_update_version = true
    }
  }
}

resource "aws_iam_policy" "cloudwatch" {
  name = "cloudwatch_logs"
  policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogStreams",
            "logs:PutRetentionPolicy"
          ],
          "Effect": "Allow",
          "Resource": [
            "arn:aws:logs:*:*:*"
          ]
        }
      ]
    })
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  for_each = module.eks.eks_managed_node_groups
  role       = each.value.iam_role_name
  policy_arn = aws_iam_policy.cloudwatch.arn
}

resource "aws_iam_role_policy_attachment" "ssm_managed" {
  for_each = module.eks.eks_managed_node_groups
  role       = each.value.iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_ssm_parameter" "eks" {
  name  = "/platform/eks/id"
  type  = "String"
  value = module.eks.cluster_name
}

resource "aws_ssm_parameter" "eks_worker_node_role" {
  name  = "/platform/eks/worker_node_role_arn"
  type  = "String"
  value = module.eks.eks_managed_node_groups["main"].iam_role_arn
}

resource "aws_ssm_parameter" "eks_worker_main_node_role" {
  name  = "/platform/eks/worker_main_node_role_arn"
  type  = "String"
  value = module.eks.eks_managed_node_groups["main"].iam_role_arn
}

resource "aws_ssm_parameter" "eks_worker_geoserver_node_role" {
  name  = "/platform/eks/worker_geoserver_node_role_arn"
  type  = "String"
  value = module.eks.eks_managed_node_groups["geoserver"].iam_role_arn
}

resource "aws_ssm_parameter" "eks_worker_batch_node_role" {
  name  = "/platform/eks/worker_batch_node_role_arn"
  type  = "String"
  value = module.eks.eks_managed_node_groups["batch"].iam_role_arn
}

resource "aws_ssm_parameter" "oidc_provider_arn" {
  name  = "/platform/eks/oidc_provider_arn"
  type  = "String"
  value = module.eks.oidc_provider_arn
}

resource "aws_ssm_parameter" "oidc_provider_url" {
  name  = "/platform/eks/oidc_provider_url"
  type  = "String"
  value = module.eks.cluster_oidc_issuer_url
}