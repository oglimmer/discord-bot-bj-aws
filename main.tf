terraform {
  backend "s3" {
    bucket = "terraform-bot-bj"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}

module "network" {
    source = "./network"
    project_region = var.project_region
}

module "backend" {
    source = "./backend"
    vpc_id = module.network.vpc_id
    subnet_private1_id = module.network.subnet_private1_id
    subnet_private2_id = module.network.subnet_private2_id
    clientId = var.clientId
    token = var.token
    project_region = var.project_region
}

module "ecs_update_pipeline" {
    source = "./ecs-update-pipeline"
    ecs_sg_id = module.backend.ecs_sg_id
    private_subnet_ids = [module.network.subnet_private1_id, module.network.subnet_private2_id]
    project_region = var.project_region
}
