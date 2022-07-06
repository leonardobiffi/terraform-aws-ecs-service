resource "aws_ecs_service" "service" {
  name            = var.name
  cluster         = var.ecs_cluster_id
  task_definition = var.task_definition
  desired_count   = var.desired_count
  iam_role        = (var.attach_to_load_balancer && var.task_network_mode != "awsvpc") ? var.ecs_cluster_service_role_arn : null

  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  health_check_grace_period_seconds  = var.attach_to_load_balancer ? var.health_check_grace_period_seconds : null
  scheduling_strategy                = var.scheduling_strategy
  force_new_deployment               = var.force_new_deployment

  dynamic "network_configuration" {
    for_each = var.task_network_mode == "awsvpc" ? [var.subnet_ids] : []

    content {
      subnets         = network_configuration.value
      security_groups = var.security_group_ids
    }
  }

  dynamic "load_balancer" {
    for_each = var.attach_to_load_balancer ? [coalesce(var.target_group_arn, var.elb_name)] : []

    content {
      elb_name         = var.elb_name
      target_group_arn = var.target_group_arn
      container_name   = coalesce(var.target_container_name, var.name)
      container_port   = coalesce(var.target_port, var.port)
    }
  }

  lifecycle {
    ignore_changes = [capacity_provider_strategy]
  }

  tags = var.tags
}
