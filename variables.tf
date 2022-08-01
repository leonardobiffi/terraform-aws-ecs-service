variable "vpc_id" {
  description = "The ID of the VPC into which to deploy the service."
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets in which to create ENIs when the service task network mode is \"awsvpc\"."
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "The IDs of the security groups to associate with the ENIs when the service task network mode is \"awsvpc\"."
  type        = list(string)
  default     = []
}

variable "task_definition" {
  description = "A template for the container definitions in the task."
  type        = string
}

variable "task_network_mode" {
  description = "The network mode used for the containers in the task."
  type        = string
  default     = "awsvpc"
}

variable "name" {
  description = "The name of the service being created."
  type        = string
}

variable "desired_count" {
  description = "The desired number of tasks in the service."
  type        = number
  default     = 3
}

variable "deployment_maximum_percent" {
  description = "The maximum percentage of the desired count that can be running."
  type        = number
  default     = 200
}

variable "deployment_minimum_healthy_percent" {
  description = "The minimum healthy percentage of the desired count to keep running."
  type        = number
  default     = 50
}

variable "health_check_grace_period_seconds" {
  description = "The number of seconds to wait for the service to start up before starting load balancer health checks."
  type        = number
  default     = 0
}

variable "port" {
  description = "The port the containers will be listening on."
  type        = string
  default     = null
}

variable "attach_to_load_balancer" {
  description = "Whether or not this service should attach to a load balancer."
  type        = bool
  default     = true
}

variable "elb_name" {
  description = "The name of the ELB to configure to point at the service containers."
  type        = string
  default     = null
}

variable "target_group_arn" {
  description = "The arn of the target group to point at the service containers."
  type        = string
  default     = null
}

variable "target_container_name" {
  description = "The name of the container to which the load balancer should route traffic. Defaults to the service_name."
  type        = string
  default     = null
}

variable "target_port" {
  description = "The port to which the load balancer should route traffic. Defaults to the service_port."
  type        = string
  default     = null
}

variable "scheduling_strategy" {
  description = "The scheduling strategy to use for this service (\"REPLICA\" or \"DAEMON\")."
  type        = string
  default     = "REPLICA"
}

variable "ecs_cluster_id" {
  description = "The ID of the ECS cluster in which to deploy the service."
  type        = string
}

variable "ecs_cluster_service_role_arn" {
  description = "The ARN of the IAM role to provide to ECS to manage the service."
  type        = string
  default     = null
}

variable "force_new_deployment" {
  description = "Whether or not to force a new deployment of the service."
  type        = bool
  default     = false
}

# Autoscaling
variable "autoscaling_enabled" {
  description = "Whether or not to enable autoscaling for this service."
  type        = bool
  default     = false
}

variable "autoscaling_min_capacity" {
  description = "The minimum number of tasks to run for this service."
  type        = number
  default     = 1
}

variable "autoscaling_max_capacity" {
  description = "The maximum number of tasks to run for this service."
  type        = number
  default     = 1
}

variable "autoscaling_cpu_target_value" {
  description = "The CPU target value for autoscaling."
  type        = number
  default     = 0
}

variable "autoscaling_memory_target_value" {
  description = "The memory target value for autoscaling."
  type        = number
  default     = 0
}

variable "autoscaling_scale_in_cooldown" {
  description = "The cooldown period after a scale in event."
  type        = number
  default     = 120
}

variable "autoscaling_scale_out_cooldown" {
  description = "The cooldown period after a scale out event."
  type        = number
  default     = 120
}

variable "tags" {
  description = "The tags to apply to the service."
  type        = map(string)
  default     = {}
}
