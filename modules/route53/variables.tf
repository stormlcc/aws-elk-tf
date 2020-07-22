variable "vpc_id" {
  description = "vpc_id"
  type        = string
}

variable "name" {
  description = "name"
  type        = string
  default     = "logstash-dev"
}

variable "department" {
  description = "department"
  type        = string
  default     = "yourdepartment"
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
