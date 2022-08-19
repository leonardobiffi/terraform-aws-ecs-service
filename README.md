# terraform-aws-ecs-service

Terraform module to create an ECS Service for a web app (task), with existint ALB and Cluster 

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.24.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.memory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_ecs_service.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assign_public_ip"></a> [assign\_public\_ip](#input\_assign\_public\_ip) | Whether or not to assign a public IP address to each container. | `bool` | `false` | no |
| <a name="input_attach_to_load_balancer"></a> [attach\_to\_load\_balancer](#input\_attach\_to\_load\_balancer) | Whether or not this service should attach to a load balancer. | `bool` | `true` | no |
| <a name="input_autoscaling_cpu_target_value"></a> [autoscaling\_cpu\_target\_value](#input\_autoscaling\_cpu\_target\_value) | The CPU target value for autoscaling. | `number` | `0` | no |
| <a name="input_autoscaling_enabled"></a> [autoscaling\_enabled](#input\_autoscaling\_enabled) | Whether or not to enable autoscaling for this service. | `bool` | `false` | no |
| <a name="input_autoscaling_max_capacity"></a> [autoscaling\_max\_capacity](#input\_autoscaling\_max\_capacity) | The maximum number of tasks to run for this service. | `number` | `1` | no |
| <a name="input_autoscaling_memory_target_value"></a> [autoscaling\_memory\_target\_value](#input\_autoscaling\_memory\_target\_value) | The memory target value for autoscaling. | `number` | `0` | no |
| <a name="input_autoscaling_min_capacity"></a> [autoscaling\_min\_capacity](#input\_autoscaling\_min\_capacity) | The minimum number of tasks to run for this service. | `number` | `1` | no |
| <a name="input_autoscaling_scale_in_cooldown"></a> [autoscaling\_scale\_in\_cooldown](#input\_autoscaling\_scale\_in\_cooldown) | The cooldown period after a scale in event. | `number` | `120` | no |
| <a name="input_autoscaling_scale_out_cooldown"></a> [autoscaling\_scale\_out\_cooldown](#input\_autoscaling\_scale\_out\_cooldown) | The cooldown period after a scale out event. | `number` | `120` | no |
| <a name="input_deployment_maximum_percent"></a> [deployment\_maximum\_percent](#input\_deployment\_maximum\_percent) | The maximum percentage of the desired count that can be running. | `number` | `200` | no |
| <a name="input_deployment_minimum_healthy_percent"></a> [deployment\_minimum\_healthy\_percent](#input\_deployment\_minimum\_healthy\_percent) | The minimum healthy percentage of the desired count to keep running. | `number` | `50` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | The desired number of tasks in the service. | `number` | `3` | no |
| <a name="input_ecs_cluster_id"></a> [ecs\_cluster\_id](#input\_ecs\_cluster\_id) | The ID of the ECS cluster in which to deploy the service. | `string` | n/a | yes |
| <a name="input_ecs_cluster_service_role_arn"></a> [ecs\_cluster\_service\_role\_arn](#input\_ecs\_cluster\_service\_role\_arn) | The ARN of the IAM role to provide to ECS to manage the service. | `string` | `null` | no |
| <a name="input_elb_name"></a> [elb\_name](#input\_elb\_name) | The name of the ELB to configure to point at the service containers. | `string` | `null` | no |
| <a name="input_force_new_deployment"></a> [force\_new\_deployment](#input\_force\_new\_deployment) | Whether or not to force a new deployment of the service. | `bool` | `false` | no |
| <a name="input_health_check_grace_period_seconds"></a> [health\_check\_grace\_period\_seconds](#input\_health\_check\_grace\_period\_seconds) | The number of seconds to wait for the service to start up before starting load balancer health checks. | `number` | `0` | no |
| <a name="input_launch_type"></a> [launch\_type](#input\_launch\_type) | The launch type to use for the service ("EC2" or "FARGATE"). | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the service being created. | `string` | n/a | yes |
| <a name="input_platform_version"></a> [platform\_version](#input\_platform\_version) | The platform version to use for the ECS | `string` | `"1.4.0"` | no |
| <a name="input_port"></a> [port](#input\_port) | The port the containers will be listening on. | `string` | `null` | no |
| <a name="input_scheduling_strategy"></a> [scheduling\_strategy](#input\_scheduling\_strategy) | The scheduling strategy to use for this service ("REPLICA" or "DAEMON"). | `string` | `"REPLICA"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | The IDs of the security groups to associate with the ENIs when the service task network mode is "awsvpc". | `list(string)` | `[]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The IDs of the subnets in which to create ENIs when the service task network mode is "awsvpc". | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to apply to the service. | `map(string)` | `{}` | no |
| <a name="input_target_container_name"></a> [target\_container\_name](#input\_target\_container\_name) | The name of the container to which the load balancer should route traffic. Defaults to the service\_name. | `string` | `null` | no |
| <a name="input_target_group_arn"></a> [target\_group\_arn](#input\_target\_group\_arn) | The arn of the target group to point at the service containers. | `string` | `null` | no |
| <a name="input_target_port"></a> [target\_port](#input\_target\_port) | The port to which the load balancer should route traffic. Defaults to the service\_port. | `string` | `null` | no |
| <a name="input_task_definition"></a> [task\_definition](#input\_task\_definition) | A template for the container definitions in the task. | `string` | n/a | yes |
| <a name="input_task_network_mode"></a> [task\_network\_mode](#input\_task\_network\_mode) | The network mode used for the containers in the task. | `string` | `"awsvpc"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC into which to deploy the service. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | The arn of the ECS cluster |
| <a name="output_id"></a> [id](#output\_id) | The ID of the ECS service |
| <a name="output_name"></a> [name](#output\_name) | The name of the ECS service |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements for Dev

- pre-commit
- terraform-docs

```sh
pre-commit install
```
