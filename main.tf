
resource "alicloud_eci_image_cache" "image_cache" {
  count             = var.create_image_cache ? 1 : 0
  image_cache_name  = var.image_cache_name
  images            = var.images
  security_group_id = var.security_group_id
  vswitch_id        = var.vswitch_id
  eip_instance_id   = var.eip_instance_id
  resource_group_id = var.resource_group_id
  zone_id           = var.zone_id
}

resource "alicloud_eci_virtual_node" "virtual_node" {
  count                 = var.create_virtual_node ? 1 : 0
  depends_on            = [alicloud_eci_container_group.container_group]
  eip_instance_id       = var.eip_instance_id
  vswitch_id            = var.vswitch_id
  zone_id               = var.zone_id
  resource_group_id     = var.resource_group_id
  security_group_id     = var.security_group_id
  virtual_node_name     = var.virtual_node_name
  enable_public_network = var.enable_public_network
  kube_config           = var.kube_config
  tags                  = var.virtual_node_tags
  taints {
    effect = lookup(var.taints, "effect", null)
    key    = lookup(var.taints, "key", null)
    value  = lookup(var.taints, "value", null)
  }
}

resource "alicloud_eci_container_group" "container_group" {
  count                = var.create_container_group ? 1 : 0
  depends_on           = [alicloud_eci_image_cache.image_cache]
  security_group_id    = var.security_group_id
  vswitch_id           = var.vswitch_id
  zone_id              = var.zone_id
  resource_group_id    = var.resource_group_id
  container_group_name = var.container_group_name
  cpu                  = var.cpu
  memory               = var.memory
  restart_policy       = var.restart_policy
  containers {
    image             = var.container_image
    name              = var.container_name
    working_dir       = var.container_working_dir
    image_pull_policy = var.container_image_pull_policy
    commands          = var.container_commands
    volume_mounts {
      mount_path = lookup(var.volume_mounts, "mount_path", null)
      read_only  = lookup(var.volume_mounts, "read_only", false)
      name       = lookup(var.volume_mounts, "name", null)
    }
    ports {
      port     = lookup(var.ports, "port", null)
      protocol = lookup(var.ports, "protocol", null)
    }
    environment_vars {
      key   = lookup(var.environment_vars, "key", null)
      value = lookup(var.environment_vars, "value", null)
    }
  }
  init_containers {
    name              = var.init_container_name
    image             = var.init_container_image
    image_pull_policy = var.init_container_image_pull_policy
    commands          = var.init_container_commands
    args              = var.init_container_args
  }
  volumes {
    name = lookup(var.volumes, "name", null)
    type = lookup(var.volumes, "type", null)
  }
}

