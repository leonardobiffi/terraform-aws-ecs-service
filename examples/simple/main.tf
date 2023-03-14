locals {
  name = "ecs-service-test"
}

resource "aws_ecs_cluster" "main" {
  name = local.name
}

module "ecs" {
  source = "../.."

  name = local.name

  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnets.default.ids

  ecs_cluster_id   = aws_ecs_cluster.main.id
  ecs_cluster_name = aws_ecs_cluster.main.name
  task_definition  = module.container_definition.json_map_encoded
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
