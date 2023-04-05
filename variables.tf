variable "enabled" {
  description = "Whether or not to create the resources."
  type        = bool
  default     = true
}

variable "ecs_cluster_id" {
  description = "The ID of the ECS cluster in which to deploy the service."
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets in which to create ENIs when the service task network mode is \"awsvpc\"."
  type        = list(string)
  default     = null
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
  default     = 1
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

variable "target_group_arn" {
  description = "The arn of the target group to point at the service containers."
  type        = string
  default     = null
}

variable "multiples_target_groups" {
  description = "The multiples target groups to attach to the service."
  type = list(object({
    target_group_arn = string
    container_name   = string
    container_port   = string
  }))
  default = []
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

variable "launch_type" {
  description = "The launch type to use for the service (\"EC2\" or \"FARGATE\")."
  type        = string
  default     = null
}

variable "platform_version" {
  description = "The platform version to use for the ECS"
  type        = string
  default     = "1.4.0"
}

variable "enable_execute_command" {
  description = "Whether or not to enable execute command for this service."
  type        = bool
  default     = true
}

variable "assign_public_ip" {
  description = "Whether or not to assign a public IP address to each container."
  type        = bool
  default     = false
}

# Service Discovery
variable "enable_service_discovery" {
  description = "Whether the service should be registered with Service Discovery. In order to use Service Disovery, an existing DNS Namespace must exist and be passed in."
  type        = bool
  default     = false
}

variable "service_discovery_namespace_id" {
  description = "The ID of the namespace to use for DNS configuration."
  type        = string
  default     = null
}

variable "service_discovery_dns_record_type" {
  description = "The type of the resource, which indicates the value that Amazon Route 53 returns in response to DNS queries. One of `A` or `SRV`."
  type        = string
  default     = "A"
}

variable "service_discovery_dns_ttl" {
  description = "The amount of time, in seconds, that you want DNS resolvers to cache the settings for this resource record set."
  type        = number
  default     = 10
}

variable "service_discovery_routing_policy" {
  description = "The routing policy that you want to apply to all records that Route 53 creates when you register an instance and specify the service. One of `MULTIVALUE` or `WEIGHTED`."
  type        = string
  default     = "MULTIVALUE"
}

variable "service_discovery_failure_threshold" {
  description = "The number of 30-second intervals that you want service discovery to wait before it changes the health status of a service instance. Maximum value of 10."
  type        = number
  default     = 1
}

variable "service_discovery_port" {
  description = "The port value used if your Service Discovery service specified an SRV record."
  type        = number
  default     = null
}

variable "service_discovery_container_name" {
  description = "The container name value, already specified in the task definition, to be used for your service discovery service."
  type        = string
  default     = null
}

variable "service_discovery_container_port" {
  description = "The port value, already specified in the task definition, to be used for your service discovery service."
  type        = number
  default     = null
}

variable "tags" {
  description = "The tags to apply to the service."
  type        = map(string)
  default     = {}
}
