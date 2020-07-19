resource "aws_iam_role" "logstashec2-role" {
  name = "logstashec2-role"
  
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_policy" "ec2policy" {
  name        = "ec2policy"
  description = "logstash ec2 policy"
  policy = file(".//modules/iamprofile/ec2policy.json")
}

resource "aws_iam_policy" "s3policy" {
  name        = "s3policy"
  description = "s3 access policy"
  policy = file(".//modules/iamprofile/s3policy.json")
}

resource "aws_iam_role_policy_attachment" "ec2policy-attach" {
  #name       = "ec2policy-attach"
  role       = aws_iam_role.logstashec2-role.name
  policy_arn = aws_iam_policy.ec2policy.arn
}

resource "aws_iam_role_policy_attachment" "s3policy-attach" {
  #name       = "s3policy-attach"
  role       = aws_iam_role.logstashec2-role.name
  policy_arn = aws_iam_policy.s3policy.arn
}

resource "aws_iam_instance_profile" "logstash_iam_profile" {
  name  = "logstash_iam_profile"
  role = aws_iam_role.logstashec2-role.name
}