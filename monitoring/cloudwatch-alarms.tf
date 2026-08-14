resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.cluster_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods   = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Triggers when RDS CPU exceeds 80% for 15 minutes"
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.app_db.id
  }
}

resource "aws_cloudwatch_metric_alarm" "low_free_storage" {
  alarm_name          = "${var.cluster_name}-low-free-storage"
  comparison_operator = "LessThanThreshold"
  evaluation_periods   = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 5368709120 # 5 GB in bytes
  alarm_description   = "Triggers when RDS free storage drops below 5GB"
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.app_db.id
  }
}
