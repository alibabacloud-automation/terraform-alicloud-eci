
data "alicloud_eci_zones" "default" {}

data "alicloud_resource_manager_resource_groups" "default" {}

resource "alicloud_vpc" "default" {
  vpc_name   = var.name
  cidr_block = "10.4.0.0/16"
}

resource "alicloud_eip_address" "eip_address" {
  address_name = "tf-test-eci"
}

resource "alicloud_security_group" "security_group" {
  vpc_id = alicloud_vpc.default.id
  name   = "tf-eci-test"
}



data "alicloud_zones" "default" {
  available_resource_creation = "VSwitch"
}

resource "alicloud_vswitch" "default1" {
  count        = 1
  vswitch_name = format("${var.name}_%d", count.index + 1)
  cidr_block   = format("10.4.%d.0/24", count.index + 1)
  zone_id      = data.alicloud_eci_zones.default.zones[0].zone_ids[1]
  vpc_id       = alicloud_vpc.default.id
}

resource "alicloud_vswitch" "default2" {
  count        = 3
  vswitch_name = format("${var.name}_%d", count.index + 2)
  cidr_block   = format("10.4.%d.0/24", count.index + 2)
  zone_id      = data.alicloud_zones.default.zones[count.index].id
  vpc_id       = alicloud_vpc.default.id
}

data "alicloud_instance_types" "default" {
  count                = 3
  availability_zone    = data.alicloud_zones.default.zones[count.index].id
  cpu_core_count       = 4
  memory_size          = 8
  kubernetes_node_role = "Master"
  system_disk_category = "cloud_essd"
}

resource "alicloud_cs_kubernetes" "default" {
  master_vswitch_ids    = alicloud_vswitch.default2[*].id
  master_instance_types = [data.alicloud_instance_types.default[0].instance_types[0].id, data.alicloud_instance_types.default[1].instance_types[0].id, data.alicloud_instance_types.default[2].instance_types[0].id]
  master_disk_category  = "cloud_essd"
  version               = "1.24.6-aliyun.1"
  password              = "Yourpassword1234"
  pod_cidr              = "10.72.0.0/16"
  service_cidr          = "172.18.0.0/16"
  load_balancer_spec    = "slb.s2.small"
  install_cloud_monitor = "true"
  resource_group_id     = data.alicloud_resource_manager_resource_groups.default.groups[0].id
  deletion_protection   = "false"
  timezone              = "Asia/Shanghai"
  os_type               = "Linux"
  platform              = "CentOS"
  cluster_domain        = "cluster.local"
  proxy_mode            = "ipvs"
  custom_san            = "www.terraform.io"
  new_nat_gateway       = "true"
}

data "alicloud_cs_cluster_credential" "auth" {
  cluster_id = alicloud_cs_kubernetes.default.id
}

data "alicloud_regions" "default" {
  current = true
}

module "example" {
  source = "../.."
  #alicloud_eci_image_cache
  create_image_cache = true
  image_cache_name   = "tf-name"
  images             = ["registry-vpc.${data.alicloud_regions.default.regions[0].id}.aliyuncs.com/eci_open/nginx:alpine"]
  security_group_id  = alicloud_security_group.security_group.id
  vswitch_id         = alicloud_vswitch.default1[0].id
  eip_instance_id    = alicloud_eip_address.eip_address.id
  resource_group_id  = data.alicloud_resource_manager_resource_groups.default.groups[0].id
  zone_id            = alicloud_vswitch.default1[0].zone_id
  #alicloud_eci_virtual_node
  virtual_node_name     = "tf-name"
  create_virtual_node   = true
  enable_public_network = false
  kube_config           = base64encode(data.alicloud_cs_cluster_credential.auth.kube_config)
  taints                = var.taints
  virtual_node_tags = {
    Created = "TF"
  }
  #alicloud_eci_container_group
  create_container_group           = true
  container_group_name             = "tf-name"
  container_image                  = "registry-vpc.${data.alicloud_regions.default.regions[0].id}.aliyuncs.com/eci_open/nginx:alpine"
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
  init_container_image             = "registry-vpc.${data.alicloud_regions.default.regions[0].id}.aliyuncs.com/eci_open/busybox:1.30"
  init_container_image_pull_policy = var.init_container_image_pull_policy
  init_container_commands          = var.init_container_commands
  init_container_args              = var.init_container_args
  volumes                          = var.volumes
  ports = {
    port     = 80
    protocol = "TCP"
  }
}
