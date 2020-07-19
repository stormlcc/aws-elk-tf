variable "vpc_id" {
    type = string
}

####
#NLB
####
variable "nlb_config" {
  default = {
    name            = "logstash-nlb"
    internal        = "false"
    environment     = "test"
    nlb_vpc_id      = "vpc-0a3c8076c106ff7d4"
  }
}

variable "tg_config" {
  default = {
    name                              = "logstash-nlb-tg"
    target_type                       = "instance"
    health_check_protocol             = "TCP"
    tg_vpc_id                         = "vpc-0a3c8076c106ff7d4"
  }
}

variable "forwarding_config" {
  default = {
      #80        =   "TCP"
      #443       =   "TCP"
      5044      =   "TCP" # and so on  }
  }
}

####
#ES
####

variable "es_domain_name" {
  description = "elasticsearch domain name"
  type        = string
}

variable "es_version" {
  description = "elasticsearch version"
  type        = string
}

variable "profile" {
  description = "profile"
  type        = string
}

variable "region" {
  description = "region"
  type        = string
}

variable "department" {
  description = "department"
  type        = string
}

variable "environment" {
  description = "environment"
  type        = string
}

variable "project" {
  description = "project"
  type        = string
}

variable "ticket" {
  description = "ticket"
  type        = string
}

