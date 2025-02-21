resource "auth0_log_stream" "aws_log_stream" {
  name = "AWS Eventbridge"
  type = "eventbridge"
  status = "active"
  filters = [
    {
      type = "category"
      name = "auth.login.fail"
    },
    {
      type = "category"
      name = "auth.login.success"
    },
    {
      type = "category"
      name = "auth.logout.fail"
    },
    {
      type = "category"
      name = "auth.logout.success"
    },
    {
      type = "category"
      name = "auth.silent_auth.fail"
    },
    {
      type = "category"
      name = "auth.silent_auth.success"
    },
    {
      type = "category"
      name = "auth.token_exchange.fail"
    },
    {
      type = "category"
      name = "auth.token_exchange.success"
    }
  ]
  sink {
    aws_account_id = var.aws_account_id
    aws_region = var.aws_region
  }
}

resource "aws_cloudwatch_event_bus" "auth0_eventbridge" {
  name              = auth0_log_stream.aws_log_stream.sink[0].aws_partner_event_source
  event_source_name = auth0_log_stream.aws_log_stream.sink[0].aws_partner_event_source
  tags = {
    System = "auth0"
  }
  depends_on = [
    auth0_log_stream.aws_log_stream
  ]
}
