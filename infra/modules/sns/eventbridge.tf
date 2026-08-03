resource "aws_cloudwatch_event_rule" "pipeline_state_change" {
  name        = "${var.project}-${var.environment}-pipeline-state-change"
  description = "Capture les changements d'état (succès/échec) de la pipeline"

  event_pattern = jsonencode({
    source      = ["aws.codepipeline"]
    detail-type = ["CodePipeline Pipeline Execution State Change"]
    detail = {
      pipeline = [var.codepipeline_name]
      state    = ["SUCCEEDED", "FAILED"]
    }
  })

  tags = {
    Name        = "${var.project}-${var.environment}-pipeline-state-change"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.pipeline_state_change.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.pipeline_notifications.arn
}

