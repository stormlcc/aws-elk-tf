resource "aws_instance" "ec2-logstash1" {
  ami           = "ami-03c5d095bc6ac48da"
  instance_type = var.instance_type
  subnet_id     = "subnet-060951f276e50bece"
  associate_public_ip_address = false
  availability_zone = "us-east-1a"
  iam_instance_profile = "logstash_iam_profile"
  key_name = "cse-ken.lee-k8s.test"
  # use your ec2 static ip here
  # private_ip = "10.252.0.10"
  source_dest_check = true
  vpc_security_group_ids = var.security_group_ids

  tags = {
  "Name" = var.name
  "department" = var.department
  "environment" = var.environment
  "project" = var.project
  "ticket_no" = var.ticket
}

  tenancy = "default"
  volume_tags = {
  "Name" = var.name
  "department" = var.department
  "environment" = var.environment
  "project" = var.project
  "ticket_no" = var.ticket
  }
}

resource "aws_instance" "ec2-logstash2" {
  ami           = "ami-03c5d095bc6ac48da"
  instance_type = var.instance_type
  subnet_id     = "subnet-0d2254b87b3651de1"
  associate_public_ip_address = false
  availability_zone = "us-east-1b"
  iam_instance_profile = "logstash_iam_profile"
  key_name = "cse-ken.lee-k8s.test"
  # use your ec2 static ip here
  # private_ip = "10.252.0.10"
  source_dest_check = true
  vpc_security_group_ids = var.security_group_ids

  tags = {
  "Name" = var.name
  "department" = var.department
  "environment" = var.environment
  "project" = var.project
  "ticket_no" = var.ticket
}
  tenancy = "default"
  volume_tags = {
  "Name" = var.name
  "department" = var.department
  "environment" = var.environment
  "project" = var.project
  "ticket_no" = var.ticket
  }
}
