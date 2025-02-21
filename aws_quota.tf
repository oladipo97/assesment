resource "aws_servicequotas_service_quota" "location_search_place_index_for_text_api_limit_per_second" {
  quota_code   = "L-20F1367A"
  service_code = "geo"
  value        = 200
}

resource "aws_servicequotas_service_quota" "location_search_place_index_for_suggestion_api_limit_per_second" {
  quota_code   = "L-EC3CCC13"
  service_code = "geo"
  value        = 200
}

resource "aws_servicequotas_service_quota" "lambda_concurrent_executions" {
  quota_code   = "L-B99A9384"
  service_code = "lambda"
  value        = 5000
}
