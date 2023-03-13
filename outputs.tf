output "id" {
  description = "The ID of the ECS service"
  value       = try(aws_ecs_service.service[0].id, null)
}

output "name" {
  description = "The name of the ECS service"
  value       = try(aws_ecs_service.service[0].name, null)
}

output "cluster_arn" {
  description = "The arn of the ECS cluster"
  value       = try(aws_ecs_service.service[0].cluster, null)
}
