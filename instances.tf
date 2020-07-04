resource "aws_instance" "bastion" {
  monitoring                  = true
  ami                         = data.aws_ami.ubuntu_18_latest.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  security_groups             = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  subnet_id                   = element(aws_subnet.dmz_public.*.id, 0)
  tags = {
    Name        = "bastion"
    Environment = "Test"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "nat" {
  monitoring                  = true
  ami                         = data.aws_ami.linux_latest.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  security_groups             = [aws_security_group.nat_sg.id]
  associate_public_ip_address = true
  subnet_id                   = element(aws_subnet.dmz_public.*.id, 1)
  tags = {
    Name        = "nat"
    Environment = "Test"
  }
  lifecycle {
    create_before_destroy = true
  }
  source_dest_check = false
}

resource "aws_instance" "jenkins" {
  monitoring                  = true
  ami                         = data.aws_ami.ubuntu_18_latest.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id, aws_security_group.general_sg.id]
  subnet_id                   = element(aws_subnet.dmz_public.*.id, 2)
  tags = {
    Name        = "jenkins"
    Environment = "Test"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_template" "proxy_conf" {
  depends_on = [
    aws_instance.jenkins,
    aws_autoscaling_group.ui
  ]
  monitoring {
    enabled = true
  }
  name_prefix            = "proxy_server_config"
  image_id               = data.aws_ami.ubuntu_18_latest.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.proxy_sg.id, aws_security_group.general_sg.id]
  user_data              = filebase64("${path.module}/proxy.sh")
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "nginx_proxy"
      Environment = "Test"
    }
  }
  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_launch_template" "api_conf" {
  monitoring {
    enabled = true
  }
  name_prefix            = "api_server_config"
  image_id               = data.aws_ami.ubuntu_18_latest.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.api_sg.id, aws_security_group.general_sg.id]
  user_data              = filebase64("${path.module}/backend.sh")
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "movie_back"
      Environment = "Test"
    }
  }
  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_launch_template" "ui_conf" {
  monitoring {
    enabled = true
  }
  name_prefix            = "ui_server_config"
  image_id               = data.aws_ami.ubuntu_18_latest.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ui_sg.id, aws_security_group.general_sg.id]
  user_data              = filebase64("${path.module}/frontend.sh")
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "movie_front"
      Environment = "Test"
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "mysql_server" {
  engine                = var.engine
  engine_version        = var.engine_version
  identifier            = "moviedb"
  username              = var.db_username
  password              = var.db_password
  instance_class        = var.db_instance_type
  allocated_storage     = 20
  max_allocated_storage = 100
  multi_az              = false
  publicly_accessible   = false
  port                  = 3306
  tags = {
    Name        = "Mysql_Server"
    Environment = "Test"
  }
  vpc_security_group_ids = [aws_security_group.db_sg.id, aws_security_group.general_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.default.id

  parameter_group_name = aws_db_parameter_group.default.id
  skip_final_snapshot  = true
}

resource "aws_db_snapshot" "db_snapshot" {
  db_instance_identifier = aws_db_instance.mysql_server.id
  db_snapshot_identifier = "moviesnapshot1234"
}

resource "aws_db_parameter_group" "default" {
  name   = "mysql-pg"
  family = "mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = aws_subnet.back_private.*.id
}

resource "null_resource" "db_provision" {
  depends_on = [aws_route53_record.db]
  provisioner "local-exec" {
    command = <<EOT
chmod +x mysql.sh
${path.module}/mysql.sh
    EOT
  }
}

resource "null_resource" "jenkins_provision" {
  depends_on = [aws_route53_record.jenkins]
  provisioner "local-exec" {
    command = <<EOT
chmod +x jenkins.sh
${path.module}/jenkins.sh
    EOT
  }
}