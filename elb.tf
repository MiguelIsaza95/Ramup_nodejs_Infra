resource "aws_elb" "elb_proxy" {
  name    = "proxy-elb"
  subnets = aws_subnet.dmz_public.*.id
  # subnets helps to attach the lb to your current vpc
  # we can define az or subnets, but just one of them.
  security_groups = [aws_security_group.elb_proxy_sg.id]
  internal        = false
  tags = {
    Environment = "test"
  }
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
}

resource "aws_elb" "elb_frontend" {
  name    = "frontend-elb"
  subnets = [aws_subnet.front_private.1.id, aws_subnet.front_private.2.id]
  # subnets helps to attach the lb to your current vpc
  # we can define az or subnets, but just one of them.
  security_groups = [aws_security_group.elb_ui_sg.id]
  internal        = true
  tags = {
    Environment = "test"
  }
  listener {
    instance_port     = 3030
    instance_protocol = "http"
    lb_port           = 3030
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:3030/"
    interval            = 30
  }
}

resource "aws_elb" "elb_backend" {
  name    = "backend-elb"
  subnets = aws_subnet.back_private.*.id
  # subnets helps to attach the lb to your current vpc
  # we can define az or subnets, but just one of them.
  security_groups = [aws_security_group.elb_api_sg.id]
  internal        = true
  tags = {
    Environment = "test"
  }
  listener {
    instance_port     = 3000
    instance_protocol = "http"
    lb_port           = 3000
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:3000/"
    interval            = 30
  }
}
