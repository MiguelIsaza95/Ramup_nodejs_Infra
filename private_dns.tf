resource "aws_route53_zone" "private" {
  name = "movieanalyst.org"

  vpc {
    vpc_id = aws_vpc.test.id
  }
}

resource "aws_route53_record" "front" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "front"
  type    = "A"

  alias {
    name                   = aws_elb.elb_frontend.dns_name
    zone_id                = aws_elb.elb_frontend.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "back" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "back"
  type    = "A"

  alias {
    name                   = aws_elb.elb_backend.dns_name
    zone_id                = aws_elb.elb_backend.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "db" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "db"
  type    = "A"

  alias {
    name                   = aws_db_instance.mysql_server.address
    zone_id                = aws_db_instance.mysql_server.hosted_zone_id
    evaluate_target_health = true
  }
}
