locals {
  name = "ecs-service-test"
}

resource "aws_ecs_cluster" "main" {
  name = local.name
}

module "ecs" {
  source = "../.."

  name = local.name

  subnet_ids         = data.aws_subnets.default.ids
  security_group_ids = data.aws_security_groups.default.ids

  ecs_cluster_id  = aws_ecs_cluster.main.id
  task_definition = module.container_definition.json_map_encoded

  elb_name              = "elb-test"
  target_group_arn      = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/target-group-test/1"
  target_container_name = local.name
  target_port           = 80
  port                  = 80

  multiples_target_groups = [
    {
      target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/target-group-test/1"
      container_name   = local.name
      container_port   = 80
    },
    {
      target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/target-group-test/2"
      container_name   = local.name
      container_port   = 8080
    }
  ]
}

module "container_definition" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "~> 0.58"

  container_name  = local.name
  container_image = "ngnix:latest"
  port_mappings = [
    {
      containerPort = 80
      hostPort      = 80
      protocol      = "tcp"
    }
  ]
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_security_groups" "default" {
  tags = {
    Name = "default"
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
