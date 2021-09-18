resource "aws_route53_zone" "serverspec_operations_org" {
  name = "serverspec-operations.org"
}

resource "aws_route53_record" "www_serverspec_operations_org" {
  name    = "www.serverspec-operations.org"
  type    = "A"
  zone_id = aws_route53_zone.serverspec_operations_org.zone_id
  records = ["192.168.0.1"]
  ttl     = 300
}
