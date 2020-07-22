resource "aws_route53_zone" "elkdev_com" {
    name = "elkdev.com."
    vpc {
      vpc_id = var.vpc_id
    }

    tags = {
    "Name" = var.name
    "department" = var.department
    "environment" = var.environment
    "project" = var.project
    "ticket_no" = var.ticket
    }
}


resource "aws_route53_record" "aws-elasticsearch_elkdev_com" {
    zone_id = aws_route53_zone.elkdev_com.zone_id
    name    = "aws-elasticsearch"
    type    = "CNAME"
    ttl     = "300"
    records = ["vpc-elkdev-esendpointurl.us-east-1.es.amazonaws.com"]
    }

resource "aws_route53_record" "logstash_elkdev_com" {
    zone_id = aws_route53_zone.elkdev_com.zone_id
    name    = "logstash"
    type    = "CNAME"
    ttl     = "300"
    records = ["NLB-dns-name-here"]
    }
