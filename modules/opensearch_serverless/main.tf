resource "aws_opensearchserverless_security_policy" "encryption_policy" {
  name        = "${var.name}-encryption-policy"
  type        = "encryption"
  description = "Encryption security policy for OpenSearch collection"
  policy = jsonencode({
    Rules = [
      {
        Resource = [
          "collection/${var.name}*"
        ],
        ResourceType = "collection"
      }
    ],
    AWSOwnedKey = true
  })
}

resource "aws_opensearchserverless_collection" "OpenSearchCollection" {
  name        = var.name
  description = var.description
  type        = "SEARCH"

  depends_on = [aws_opensearchserverless_security_policy.encryption_policy]
}

resource "aws_opensearchserverless_vpc_endpoint" "OpenSearchVPCEndpoint" {
  name               = "${var.name}-vpc-endpoint"
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids
}

resource "aws_opensearchserverless_security_policy" "network_policy" {
  name        = "${var.name}-network-policy"
  type        = "network"
  description = "Restricts OpenSearch access to VPC"
  policy = jsonencode([
    {
      Description = "VPC access to collection and Dashboards endpoint",
      Rules = [
        {
          ResourceType = "collection",
          Resource = [
            "collection/${var.name}"
          ]
        },
        {
          ResourceType = "dashboard",
          Resource = [
            "collection/${var.name}"
          ]
        }
      ],
      AllowFromPublic = false,
      SourceVPCEs     = [aws_opensearchserverless_vpc_endpoint.OpenSearchVPCEndpoint.id]
    }
  ])
}

resource "aws_opensearchserverless_lifecycle_policy" "OpenSearchLifecyclePolicy" {
  name   = "${var.name}-lifecycle-policy"
  type   = "retention"
  policy = jsonencode(var.policy)

  description = var.description
}

