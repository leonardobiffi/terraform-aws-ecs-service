output "id" {
  description = "The ID of the ECS service"
  value       = aws_ecs_service.service.id
}

output "name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.service.name
}
