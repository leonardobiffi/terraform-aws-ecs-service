output "id" {
  description = "The ID of the ECS service"
  value       = aws_ecs_service.service.id
}

output "name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.service.name
}

output "cluster_arn" {
  description = "The arn of the ECS cluster"
  value       = aws_ecs_service.service.cluster
}
