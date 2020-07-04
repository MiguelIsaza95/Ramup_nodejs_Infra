resource "aws_autoscaling_group" "proxy" {
  depends_on                = [aws_autoscaling_group.ui]
  name_prefix               = "proxy-autoscaling-group"
  max_size                  = 5
  min_size                  = 3
  health_check_grace_period = 300
  health_check_type         = "EC2"
  default_cooldown          = 300
  termination_policies      = ["Default"]
  enabled_metrics           = var.enabled_metrics
  protect_from_scale_in     = false
  load_balancers            = [aws_elb.elb_proxy.name]
  vpc_zone_identifier       = [aws_subnet.front_private.0.id, aws_subnet.front_private.1.id]
  launch_template {
    id      = aws_launch_template.proxy_conf.id
    version = "$Latest"
  }
  force_delete = true
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "proxy_policy_up" {
  name                   = "proxy-scale-up"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "SimpleScaling"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.proxy.name
}

resource "aws_autoscaling_policy" "proxy_policy_down" {
  name                   = "proxy-scale-down"
  scaling_adjustment     = -2
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "SimpleScaling"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.proxy.name
}

resource "aws_autoscaling_group" "ui" {
  name_prefix               = "ui-autoscaling-group"
  max_size                  = 5
  min_size                  = 3
  health_check_grace_period = 300
  health_check_type         = "EC2"
  default_cooldown          = 300
  termination_policies      = ["Default"]
  enabled_metrics           = var.enabled_metrics
  protect_from_scale_in     = false
  load_balancers            = [aws_elb.elb_frontend.name]
  vpc_zone_identifier       = [aws_subnet.front_private.1.id, aws_subnet.front_private.2.id]
  launch_template {
    id      = aws_launch_template.ui_conf.id
    version = "$Latest"
  }
  force_delete = true
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "ui_policy_up" {
  name                   = "ui-scale-up"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "SimpleScaling"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ui.name
}

resource "aws_autoscaling_policy" "ui_policy_down" {
  name                   = "ui-scale-down"
  scaling_adjustment     = -2
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "SimpleScaling"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ui.name
}

resource "aws_autoscaling_group" "api" {
  depends_on                = [aws_route53_record.db]
  name_prefix               = "api-autoscaling-group"
  max_size                  = 5
  min_size                  = 3
  health_check_grace_period = 300
  health_check_type         = "EC2"
  default_cooldown          = 300
  termination_policies      = ["Default"]
  enabled_metrics           = var.enabled_metrics
  protect_from_scale_in     = false
  load_balancers            = [aws_elb.elb_backend.name]
  vpc_zone_identifier       = aws_subnet.back_private.*.id
  launch_template {
    id      = aws_launch_template.api_conf.id
    version = "$Latest"
  }
  force_delete = true
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "api_policy_up" {
  name                   = "api-scale-up"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "SimpleScaling"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.api.name
}

resource "aws_autoscaling_policy" "api_policy_down" {
  name                   = "api-scale-down"
  scaling_adjustment     = -2
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "SimpleScaling"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.api.name
}
