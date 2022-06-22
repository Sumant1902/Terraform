provider "aws" {
  region = "us-east-1"
}

resource "aws_sns_topic" "alarm_topic" {
  name = "Terraform_alarm_topic"
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 5,
      "maxDelayTarget": 5,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
}

variable "instance_id" {
  default = ["i-019c737384033d4fa", "i-000dc60c7d80bdba0" , "i-014f51393bfbe2624"]    
}

resource "aws_cloudwatch_metric_alarm" "cpu" {
  count = "${length(var.instance_id)}"
  alarm_name                = "Test-${count.index}-CPU utilization-Alert"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  dimensions                = { 
    InstanceId = "${element(var.instance_id, count.index)}"
    }
  datapoints_to_alarm       = "2"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Maximum"
  threshold                 = "1"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  actions_enabled           = "true"
  alarm_actions             = ["${aws_sns_topic.alarm_topic.arn}"]
  ok_actions                = ["${aws_sns_topic.alarm_topic.arn}"]
}

resource "aws_sns_topic_subscription" "alarm_topic" {
  topic_arn                 = aws_sns_topic.alarm_topic.arn
  protocol                  = "email"
  endpoint                  = "sumantbangale1902@gmail.com" 
}
resource "aws_security_group" "AlarmSG" {
  name        = "AlarmSG"
  description = "Allow inbound traffic"
  vpc_id      = "vpc-d16e1fac"

ingress {
    description = "SSH access"
    from_port = 22
    to_port = 80
    protocol = "tcp"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    self             = false
}
egress  {
  cidr_blocks      = [
     "0.0.0.0/0"
    ]
    description      = ""
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    self             = false
    to_port          = 0
}
}