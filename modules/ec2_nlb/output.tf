output "ec2_id1" {
  value = aws_instance.ec2-logstash1.id
}

output "ec2_id2" {
  value = aws_instance.ec2-logstash2.id
}