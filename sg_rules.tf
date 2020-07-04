resource "aws_security_group_rule" "bastion_rds" {
  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.bastion_sg.id
  source_security_group_id = aws_security_group.db_sg.id
  description              = "Allow mysql traffic from bastion to mysql server"
}

resource "aws_security_group_rule" "proxy_ingress" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.proxy_sg.id
  source_security_group_id = aws_security_group.elb_proxy_sg.id
  description              = "Allow http traffic from proxy elb"
}

resource "aws_security_group_rule" "proxy_ui_egress" {
  type                     = "egress"
  from_port                = 3030
  to_port                  = 3030
  protocol                 = "tcp"
  security_group_id        = aws_security_group.proxy_sg.id
  source_security_group_id = aws_security_group.elb_ui_sg.id
  description              = "Allow http traffic to ui server"
}

resource "aws_security_group_rule" "elb_ui_egress" {
  type                     = "egress"
  from_port                = 3030
  to_port                  = 3030
  protocol                 = "tcp"
  security_group_id        = aws_security_group.elb_ui_sg.id
  source_security_group_id = aws_security_group.ui_sg.id
  description              = "Allow http traffic from/to ui instances"
}

resource "aws_security_group_rule" "elb_api_egress" {
  type                     = "egress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.elb_api_sg.id
  source_security_group_id = aws_security_group.api_sg.id
  description              = "Allow http traffic from api elb to api instances"
}

resource "aws_security_group_rule" "api_egress" {
  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.api_sg.id
  source_security_group_id = aws_security_group.db_sg.id
  description              = "Allow mysql traffic from the backend to mysql server"
}
