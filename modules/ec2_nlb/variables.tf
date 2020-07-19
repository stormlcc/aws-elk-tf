variable "instance_type" {
  description = "ec2 instance_type"
  type        = string
  default     = "t3a.small"
}

variable "security_group_ids" {
  type = list(string)
}

variable "nlb_config" {
  type = map
}

variable "tg_config" {
  type = map
}

variable "forwarding_config" {
}

variable "name" {
  description = "name"
  type        = string
  default     = "logstash-dev"
}

variable "department" {
  description = "department"
  type        = string
  default     = "xxx"
}

variable "environment" {
  description = "environment"
  type        = string
  default     = "development"
}

variable "project" {
  description = "project"
  type        = string
  default     = "elk-project"
}

variable "ticket" {
  description = "ticket"
  type        = string
  default     = "CS-xxx"
}
