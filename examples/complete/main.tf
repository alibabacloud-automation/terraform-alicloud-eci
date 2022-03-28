
data "alicloud_eci_zones" "default" {}

resource "alicloud_resource_manager_resource_group" "resource_group" {
  resource_group_name = "tf-test-eci"
  display_name        = "tf-test-eci"
}

module "vpc" {
  source             = "alibaba/vpc/alicloud"
  create             = true
  vpc_name           = "tf-test-eci"
  vpc_cidr           = "172.16.0.0/16"
  vswitch_name       = "tf-test-eci"
  vswitch_cidrs      = ["172.16.0.0/21"]
  availability_zones = [data.alicloud_eci_zones.default.zones.0.zone_ids.1]
}
resource "alicloud_eip_address" "eip_address" {
  address_name = "tf-test-eci"
}

resource "alicloud_security_group" "security_group" {
  vpc_id = module.vpc.this_vpc_id
  name   = "tf-eci-test"
}

module "example" {
  source             = "../.."
  #alicloud_eci_image_cache
  create_image_cache = true
  image_cache_name   = "tf-name"
  images             = var.images
  security_group_id  = alicloud_security_group.security_group.id
  vswitch_id         = module.vpc.this_vswitch_ids[0]
  eip_instance_id    = alicloud_eip_address.eip_address.id
  resource_group_id  = alicloud_resource_manager_resource_group.resource_group.id
  zone_id            = data.alicloud_eci_zones.default.zones.0.zone_ids.1
  #alicloud_eci_virtual_node
  virtual_node_name     = "tf-name"
  create_virtual_node   = true
  enable_public_network = false
  kube_config           = var.kube_config
  taints                = var.taints
  virtual_node_tags     = {
    Created = "TF"
  }
  #alicloud_eci_container_group
  create_container_group           = true
  container_group_name             = "tf-name"
  container_image                  = var.container_image
  cpu                              = var.cpu
  memory                           = var.memory
  restart_policy                   = var.restart_policy
  container_name                   = var.container_name
  container_working_dir            = var.container_working_dir
  container_image_pull_policy      = var.container_image_pull_policy
  container_commands               = var.container_commands
  volume_mounts                    = var.volume_mounts
  environment_vars                 = var.environment_vars
  init_container_name              = var.init_container_name
  init_container_image             = var.init_container_image
  init_container_image_pull_policy = var.init_container_image_pull_policy
  init_container_commands          = var.init_container_commands
  init_container_args              = var.init_container_args
  volumes                          = var.volumes
  ports = {
    port     = 80
    protocol = "TCP"
  }
}