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

  target_group_arn      = aws_lb_target_group.example.arn
  target_container_name = local.name
  target_port           = 80
  port                  = 80

  enable_service_discovery       = true
  service_discovery_namespace_id = aws_service_discovery_private_dns_namespace.example.id
}

module "container_definition" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "~> 0.58"

  container_name  = local.name
  container_image = "ngnix:latest"
  port_mappings = [{
    containerPort = 80
    hostPort      = 80
    protocol      = "tcp"
  }]
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

resource "aws_lb_target_group" "example" {
  name        = "tf-example-lb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_service_discovery_private_dns_namespace" "example" {
  name        = "example.terraform.local"
  description = "example"
  vpc         = data.aws_vpc.default.id
}
