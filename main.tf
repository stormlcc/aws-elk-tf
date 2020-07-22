terraform {
  required_version = ">= 0.12"
}

####
#ES
####

# Use this data source to get the access to the effective Account ID in which
# Terraform is working.
data "aws_caller_identity" "current" {}

# To obtain the name of the AWS region configured on the provider
data "aws_region" "current" {}

module "es_security_group" {
    source = ".//modules/security-group"
    vpc_id     = var.vpc_id

    security-groups = {
        "aws-es-sg" = {
            description = "Elasticsearch security group"
            tags = {
            "Name" = "elk-dev-sg"
          }

          rules = {
                egress = {
                    type        = "egress"
                    description = "outbound"
                    protocol    = "-1"
                    from_port   = 0
                    to_port     = 0
                    cidr_blocks = ["0.0.0.0/0"]
                    self        = false
                }

                logstash = {
                    type        = "ingress"
                    description = "Allow Logstash inbound"
                    protocol    = "tcp"
                    from_port   = 0
                    to_port     = 65535
                    cidr_blocks = ["172.10.0.0/24"]
                    self        = false
                    }

                https = {
                    type        = "ingress"
                    description = "Allow Logstash inbound"
                    protocol    = "tcp"
                    from_port   = 443
                    to_port     = 443
                    cidr_blocks = ["10.0.0.0/16"]
                    self        = false
                    }
                }
            }
        }
    }


module "aws_es" {
  vpc_id     = var.vpc_id
  source = ".//modules/es"
  domain_name = var.es_domain_name
  elasticsearch_version = var.es_version
  create_service_link_role = false

  vpc_options = {
    subnet_ids         = ["subnet-yoursubnetidhere", "subnet-yoursubnetidhere"]
    security_group_ids = [module.es_security_group.security_group["aws-es-sg"].id]
  }

  cluster_config = {
    dedicated_master_enabled = "false"
    instance_count           = "2"
    instance_type            = "t2.small.elasticsearch"
    zone_awareness_enabled   = "true"
    availability_zone_count  = "2"
  }

  ebs_options = {
    ebs_enabled = "true"
    volume_size = "25"
  }

  encrypt_at_rest = {
    enabled    = "false"
    kms_key_id = "alias/aws/es"
  }

  node_to_node_encryption_enabled                = true
  snapshot_options_automated_snapshot_start_hour = 23

  access_policies = templatefile("${path.module}/es-access_policies.tpl", {
    region      = data.aws_region.current.name,
    account     = data.aws_caller_identity.current.account_id,
    domain_name = var.es_domain_name
  })

  timeouts_update = "60m"

  tags = {
    "department" = var.department
    "environment" = var.environment
    "project" = var.project
    "ticket_no" = var.ticket
  }

}

####
#EC2 & NLB
####

module "aws_security_group" {
    source = ".//modules/security-group"

    vpc_id     = var.vpc_id

    security-groups = {
        "logstash-sg" = {
            description = "Logstash security group"
            tags = {
            "Name" = "logstash-dev-sg"
          }

            rules = {
                egress = {
                    type        = "egress"
                    description = "Logstash Outbound to Elasticsearch"
                    protocol    = "-1"
                    from_port   = 0
                    to_port     = 0
                    cidr_blocks = ["0.0.0.0/0"]
                    self        = false
                }

                ingress = {
                    type        = "ingress"
                    description = "Allow Filebeat inbound"
                    protocol    = "tcp"
                    from_port   = 5044
                    to_port     = 5044
                    cidr_blocks = ["10.252.0.0/16"]
                    self        = false
                }
            }
        }
    }
  }

module "ec2-logstash" {
  source = ".//modules/ec2_nlb"
  instance_type = "t3a.small"
  name = "logstash-dev"
  department = "cse"
  environment = "development"
  project = "elk-project"
  ticket = "CS-239"
  nlb_config               = var.nlb_config
  forwarding_config        = var.forwarding_config
  tg_config                = var.tg_config
  security_group_ids = [module.aws_security_group.security_group["logstash-sg"].id]
  }

module "logstashec2-role" {
  source = ".//modules/iamprofile"
}

module "elkdev_com" {
  source = ".//modules/route53"
  vpc_id = var.vpc_id
  department = "cse"
  environment = "development"
  project = "elk-project"
  ticket = "CS-239"
}
