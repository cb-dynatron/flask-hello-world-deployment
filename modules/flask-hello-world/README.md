# Flask Hello World

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.37.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.37.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.ecs](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/resources/autoscaling_group) | resource |
| [aws_cloudwatch_log_group.ecs](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_capacity_provider.ec2](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/resources/ecs_capacity_provider) | resource |
| [aws_ecs_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.ec2](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_ecs_service.svc](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.task](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/resources/ecs_task_definition) | resource |
| [aws_iam_instance_profile.ecs_node](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ecs_execution](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_node](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecs_execution](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_node](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_template.ecs_ec2](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/resources/launch_template) | resource |
| [aws_lb.alb](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/resources/lb) | resource |
| [aws_lb_listener.https](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.ecs_svc](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/resources/lb_target_group) | resource |
| [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/resources/security_group) | resource |
| [aws_security_group.ecs_node](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/resources/security_group) | resource |
| [aws_security_group.ecs_task](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/resources/security_group) | resource |
| [aws_iam_policy_document.ecs_node](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_task](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/data-sources/iam_policy_document) | data source |
| [aws_ssm_parameter.ecs_node_ami](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/data-sources/ssm_parameter) | data source |
| [aws_subnets.default](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/5.37.0/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region to deploy in to | `any` | n/a | yes |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | Name of the image | `string` | `"339713176830.dkr.ecr.us-east-2.amazonaws.com/flask-hello-world"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | The version of the service to deploy | `string` | `"latest"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix of name for resources created | `string` | `"flask-hello-world"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC to utilize | `any` | n/a | yes |

## Outputs

No outputs.
