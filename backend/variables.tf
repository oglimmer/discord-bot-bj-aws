
variable "vpc_id" {
    type = string
    description = "vpc id"
}

variable "subnet_private1_id" {
    type = string
    description = "aws_subnet.private1.id"
}

variable "subnet_private2_id" {
    type = string
    description = "aws_subnet.private2.id"
}

variable "project_region" {
  type = string
  description = "The AWS region to be used"
  default = "eu-central-1"
}

variable "image" {
  type = string
  description = "Container image name"
  default = "ghcr.io/oglimmer/discord-bot-bj:latest"
}

variable "clientId" {
  type = string
  description = "discord bot clientId"
  default = "UNSET"
}

variable "token" {
  type = string
  description = "discord bot secret token"
  default = "UNSET"
}
