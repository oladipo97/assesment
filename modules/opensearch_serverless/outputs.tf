output "opensearch_collection_id" {
  value = aws_opensearchserverless_collection.OpenSearchCollection.id
}

output "opensearch_vpc_endpoint_id" {
  value = aws_opensearchserverless_vpc_endpoint.OpenSearchVPCEndpoint.id
}

output "opensearch_lifecycle_policy_id" {
  value = aws_opensearchserverless_lifecycle_policy.OpenSearchLifecyclePolicy.id
}

output "opensearch_lifecycle_policy_version" {
  value = aws_opensearchserverless_lifecycle_policy.OpenSearchLifecyclePolicy.policy_version
}
