resource "aws_sns_topic" "pipeline_notifications" {
  name = "${var.project}-${var.environment}-pipeline-notifications"

  tags = {
    Name        = "${var.project}-${var.environment}-pipeline-notifications"
    Environment = var.environment
  }
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.pipeline_notifications.arn
  protocol  = "email"
  endpoint  = var.notification_email
}