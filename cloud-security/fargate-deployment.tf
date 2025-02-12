module "container" {
source                       = "./modules/container_fargate"
name                         = var.cluster.name
cluster_name                 = var.cluster.name
task_count                   = var.cluster.desired_capacity
appx_container_image_name    = "${var.appx_ecr_registry.base_uri}/${var.container.appx_container_image_name}"
mirth_container_image_name   = "${var.appx_ecr_registry.base_uri}/${var.container.mirth_container_image_name}"
appxws_container_image_name  = "${var.appx_ecr_registry.base_uri}/${var.container.appxws_container_image_name}"
artemis_container_image_name = "${var.appx_ecr_registry.base_uri}/${var.container.artemis_container_image_name}"
subnet_ids                   = var.cluster.subnet_ids
vpc_id                       = var.cluster.vpc_id
ecr_repositories             = var.appx_ecr_registry.arns
certificate = {
key_arn  = var.container.secret_key_arn
cert_arn = var.container.secret_certificate_arn
}
alb_certificate_arn = var.container.alb_certificate_arn

mirth_db_connection_string   = var.container.mirth_db_connection_string
mirth_volume_efs_id          = var.container.mirth_volume_efs_id
appx_db_connection_string    = var.container.appx_db_connection_string
appxws_db_connection_string  = var.container.appxws_db_connection_string
artemis_db_connection_string = var.container.artemis_db_connection_string

db_creds = {
userName = var.database.userName
password = var.database.password
}
}


