
variable "ecs_sg_id" {
    type = string
    description = "SG ID for ECS"
}

variable "private_subnet_ids" {
    type = set(string)
    description = "Set for private subnet ids"
}

variable "project_region" {
  type = string
  description = "The AWS region to be used"
  default = "eu-central-1"
}
