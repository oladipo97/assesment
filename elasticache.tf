resource "aws_elasticache_subnet_group" "elasticache_subnet_group" {
  name = "subnet-group"
  subnet_ids = module.shared_vpc.private_subnets
  tags = var.tags
}

resource "aws_security_group" "elasticache_security_group" {
  name        = "elasticache-security-group"
  description = "elasticache-security-group"
  vpc_id      = module.shared_vpc.vpc_id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [
      module.vpn.security_group_id,
      data.aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "elasticache-security-group"
  }
}

resource "aws_elasticache_replication_group" "elasticache_queue_cluster" {
  automatic_failover_enabled  = var.elasticache_multi_az
  multi_az_enabled            = var.elasticache_multi_az
  engine                      = "redis"
  engine_version              = "7.1"
  replication_group_id        = "queue-cluster"
  description                 = "queue-cluster"
  node_type                   = var.elasticache_node_type
  num_cache_clusters          = var.elasticache_nodes
  parameter_group_name        = "default.redis7"
  port                        = 6379
  subnet_group_name = aws_elasticache_subnet_group.elasticache_subnet_group.name
  security_group_ids = [
    aws_security_group.elasticache_security_group.id
  ]
  depends_on = [
    aws_elasticache_subnet_group.elasticache_subnet_group,
    aws_security_group.elasticache_security_group
  ]
  tags = var.tags
  apply_immediately = true
}
