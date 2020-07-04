resource "aws_cloudwatch_metric_alarm" "proxy_cpu_high" {
  alarm_name          = "proxy-high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.proxy.name
  }
  alarm_description = "Scale up if CPU utilization is above 80% for 300 seconds"
  alarm_actions     = [aws_autoscaling_policy.proxy_policy_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "proxy_cpu_low" {
  alarm_name          = "proxy-low-cpu"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 20

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.proxy.name
  }
  alarm_description = "Scale down if CPU utilization is above 20% for 300 seconds"
  alarm_actions     = [aws_autoscaling_policy.proxy_policy_down.arn]
}

resource "aws_cloudwatch_metric_alarm" "ui_cpu_high" {
  alarm_name          = "ui-high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ui.name
  }
  alarm_description = "Scale up if CPU utilization is above 80% for 300 seconds"
  alarm_actions     = [aws_autoscaling_policy.ui_policy_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "ui_cpu_low" {
  alarm_name          = "ui-low-cpu"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 20

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ui.name
  }
  alarm_description = "Scale down if CPU utilization is above 20% for 300 seconds"
  alarm_actions     = [aws_autoscaling_policy.ui_policy_down.arn]
}

resource "aws_cloudwatch_metric_alarm" "api_cpu_high" {
  alarm_name          = "api-high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.api.name
  }
  alarm_description = "Scale up if CPU utilization is above 80% for 300 seconds"
  alarm_actions     = [aws_autoscaling_policy.api_policy_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "api_cpu_low" {
  alarm_name          = "api-low-cpu"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 20

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.api.name
  }
  alarm_description = "Scale down if CPU utilization is above 20% for 300 seconds"
  alarm_actions     = [aws_autoscaling_policy.api_policy_down.arn]
}
