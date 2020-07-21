# ELK Terraform
#### (AWS Platform - Custom Logstash AMI, Amazon Elasticsearch & Kibana)
Note: you will not find a more complete package than this in github (for Amazon ELK)\
These Terraform codes will deploy:
1. Amazon ES (VPC) domain
2. 2 units EC2
3. NLB (internal)

## Included Logstash Docker Compose YAML
For creating your own AMI\
Logstash docker using official image\
Using port 5044 for Filebeat input\
Included in the yaml will also:
1. install the Amazon ES plugin and create the logstash pipeline and config volumes\
2. use Timezone Asia/Singapore (change this to your own TZ)

## Create Logstash AMI
Launch EC2 (minimum t3a.small - Ubuntu LTS 18)\
Install Docker and use the docker-compose.yaml to setup launch Logstash container\
Put your pipeline and config files in the EC2 (same paths in the yaml)\
If there are no "pipeline" and "config" directory in that path, create them\
Create a Route53 subdomain (e.g. es-endpoint.com)\
For your ES output (in the pipeline file), point it to the private subdomain instead of the ES Endpoint URL.\
Also add this to outputs: ssl_certificate_verification => false\
After deployment, copy the ES Endpoint URL to the subdomain CNAME\
Capture the AMI and use the ID in your TF deployment

## Terraform User Inputs and Options

FILE: root/terraform.tfvars
------------------
all values must be defined

FILE: root/main.tf
------------------
All default values (when needed)

FILE: root/main.tf
------------------
cluster_config\
ebs_options\
encrypt_at_rest (note: need to use at least R5 instance type to support encryption)\
module "aws_security_group":\
    ports\
    cidr_blocks\
    description\
module "ec2-logstash":\
    instance_type = "instance.size"\
    name = "logstash-dev"\
    department = "your-department"\
    owner = "your name here"\
    project = "elk-project"\
    ticket = "CS-xxx"\
module "aws_es" :\
    vpc_options\
    subnet_ids = ["subnet-yoursubnet1", "subnet-yoursubnet2"]

FILE: modules/ec2_nlb/main.tf
------------------
resource "aws_instance" "ec2-logstash1" and "ec2-logstash2":\
    ami           = "ami-"\
    subnet_id     = "subnet-"\
    availability_zone = "us-east-1a"\
    key_name = "instance key"

FILE: modules/ec2_nlb/nlb.tf
------------------
resource "aws_lb"\
    subnets = ["subnet-yoursubnet1","subnet-yoursubnet2"]

FILE: modules/ec2_nlb/variables.tf
------------------
variable "nlb_config"\
variable "tg_config"

FILE: modules/es/variables.tf
------------------
variable "domain_name"\
variable "ebs_options_volume_size"\
All default values (when needed)\
Un-hash and define vpc_id default if you do not want to input it during tf apply

FILE: modules/es/main.tf
------------------
module "aws_security_group":\
    ports\
    cidr_blocks\
    description

FILE: modules/iamprofile/s3policy.json
------------------
Note: This is for you to archive your logs to S3\
Create your bucket first and input the bucket ARN into:
"Resource": [
    "arn:aws:s3:::yourbucketarn"
