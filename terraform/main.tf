
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
}

module "ecs_update_pipeline" {
    source = "./ecs-update-pipeline"
    ecs_sg_id = module.backend.ecs_sg_id
    private_subnet_ids = [module.network.subnet_private1_id, module.network.subnet_private2_id]
    project_region = var.project_region
}
