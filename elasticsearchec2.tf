resource "aws_security_group" "es" {
  name = "${local.common_prefix}-es-sg"
  description = "Allow inbound traffic to ElasticSearch from VPC CIDR"
  vpc_id = aws_vpc.demo.id

  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = [
          aws_vpc.demo.cidr_block
      ]
  }
}

resource "aws_iam_service_linked_role" "esiam" {
  aws_service_name = "es.amazonaws.com"
}

resource "aws_elasticsearch_domain" "esdomain" {
  domain_name = local.elk_domain
  elasticsearch_version = "7.7"

  cluster_config {
      instance_count = 1
      instance_type = "t3.medium.elasticsearch"
      zone_awareness_enabled = true

      zone_awareness_config {
        availability_zone_count = 1
      }
  }

  vpc_options {
      subnet_ids = [
        aws_subnet.private-elk.id,
        aws_subnet.public-elk.id
      ]

      security_group_ids = [
          aws_security_group.my_private_sg.id
      ]
  }

  ebs_options {
      ebs_enabled = true
      volume_size = 50
  }

  access_policies = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": "my_private_sg:*",
          "Principal": "*",
          "Effect": "Allow",
          "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${local.elk_domain}/*"
      }
  ]
}
  CONFIG

  snapshot_options {
      automated_snapshot_start_hour = 23
  }

  tags = {
      Domain = local.elk_domain
  }
}

output "elk_endpoint" {
  value = aws_elasticsearch_domain.esdomain.endpoint
}

output "elk_kibana_endpoint" {
  value = aws_elasticsearch_domain.esdomain.kibana_endpoint
}