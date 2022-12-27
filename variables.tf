
variable "project_region" {
  type = string
  description = "The AWS region to be used"
  default = "eu-central-1"
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
