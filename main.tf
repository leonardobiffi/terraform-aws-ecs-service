locals {
  attach_to_load_balancer = var.elb_name != null || var.target_group_arn != null
}

resource "aws_ecs_service" "service" {
  count = var.enabled ? 1 : 0

  name             = var.name
  cluster          = var.ecs_cluster_id
  task_definition  = var.task_definition
  desired_count    = var.autoscaling_enabled ? var.autoscaling_min_capacity : var.desired_count
  iam_role         = (local.attach_to_load_balancer && var.task_network_mode != "awsvpc") ? var.ecs_cluster_service_role_arn : null
  launch_type      = var.launch_type
  platform_version = var.platform_version

  enable_execute_command             = var.enable_execute_command
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  health_check_grace_period_seconds  = local.attach_to_load_balancer ? var.health_check_grace_period_seconds : null
  scheduling_strategy                = var.scheduling_strategy
  force_new_deployment               = var.force_new_deployment

  dynamic "network_configuration" {
    for_each = var.task_network_mode == "awsvpc" ? [var.subnet_ids] : []

    content {
      subnets          = network_configuration.value
      security_groups  = var.security_group_ids
      assign_public_ip = var.assign_public_ip
    }
  }

  dynamic "load_balancer" {
    for_each = var.target_group_arn != null ? [var.target_group_arn] : []

    content {
      target_group_arn = var.target_group_arn
      container_name   = coalesce(var.target_container_name, var.name)
      container_port   = coalesce(var.target_port, var.port)
    }
  }

  dynamic "load_balancer" {
    for_each = var.multiples_target_groups

    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }

  lifecycle {
    ignore_changes = [capacity_provider_strategy, desired_count]
  }

  tags = var.tags
}

# Autoscaling

locals {
  ecs_cluster_name = regex("arn:aws:ecs:.*:.*:cluster/(.*)", var.ecs_cluster_id)[0]
}

resource "aws_appautoscaling_target" "main" {
  count              = var.autoscaling_enabled && var.enabled ? 1 : 0
  max_capacity       = var.autoscaling_max_capacity
  min_capacity       = var.autoscaling_min_capacity
  resource_id        = "service/${local.ecs_cluster_name}/${aws_ecs_service.service[0].name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Autoscaling Policy CPU
resource "aws_appautoscaling_policy" "cpu" {
  count              = var.autoscaling_enabled && var.autoscaling_cpu_target_value > 0 ? 1 : 0
  name               = "cpu-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.main[0].resource_id
  scalable_dimension = aws_appautoscaling_target.main[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.main[0].service_namespace

  target_tracking_scaling_policy_configuration {

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = var.autoscaling_cpu_target_value
    scale_in_cooldown  = var.autoscaling_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_scale_out_cooldown
  }

  depends_on = [aws_ecs_service.service]
}

# Autoscaling Policy Memory
resource "aws_appautoscaling_policy" "memory" {
  count              = var.autoscaling_enabled && var.autoscaling_memory_target_value > 0 ? 1 : 0
  name               = "memory-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.main[0].resource_id
  scalable_dimension = aws_appautoscaling_target.main[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.main[0].service_namespace

  target_tracking_scaling_policy_configuration {

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = var.autoscaling_memory_target_value
    scale_in_cooldown  = var.autoscaling_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_scale_out_cooldown
  }

  depends_on = [aws_ecs_service.service]
}
