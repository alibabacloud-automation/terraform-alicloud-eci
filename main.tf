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
  dynamic "taints" {
    for_each = var.taints
    content {
      effect = lookup(image_registry_credential.value, "effect", null)
      key    = lookup(image_registry_credential.value, "key", null)
      value  = lookup(image_registry_credential.value, "value", null)
    }
  }
}

resource "alicloud_eci_container_group" "container_group" {
  count                = var.create_container_group ? 1 : 0
  security_group_id    = var.security_group_id
  vswitch_id           = var.vswitch_id
  zone_id              = var.zone_id
  resource_group_id    = var.resource_group_id
  container_group_name = var.container_group_name
  cpu                  = var.cpu
  memory               = var.memory
  restart_policy       = var.restart_policy
  instance_type        = var.instance_type

  dynamic "image_registry_credential" {
    for_each = var.image_registry_credential
    content {
      user_name = image_registry_credential.value.user_name
      password  = image_registry_credential.value.password
      server    = image_registry_credential.value.server
    }
  }

  dynamic "containers" {
    for_each = var.containers
    content {
      name              = containers.value.name
      image             = containers.value.image
      cpu               = containers.value.cpu
      memory            = containers.value.memory
      gpu               = containers.value.gpu
      image_pull_policy = containers.value.image_pull_policy
      working_dir       = containers.value.working_dir
      commands          = containers.value.commands
      args              = containers.value.args
      dynamic "ports" {
        for_each = containers.value.ports
        content {
          port     = ports.value.port
          protocol = ports.value.protocol
        }
      }
      dynamic "environment_vars" {
        for_each = containers.value.environment_vars
        content {
          key   = environment_vars.value.key
          value = environment_vars.value.value
          dynamic "field_ref" {
            for_each = environment_vars.value.field_ref
            content {
              field_path = field_ref.value.field_path
            }
          }
        }
      }
      dynamic "volume_mounts" {
        for_each = containers.value.volume_mounts
        content {
          mount_path = volume_mounts.value.mount_path
          read_only  = volume_mounts.value.read_only
          name       = volume_mounts.value.name
        }
      }

      dynamic "liveness_probe" {
        for_each = containers.value.liveness_probe
        content {
          period_seconds        = liveness_probe.value.period_seconds
          initial_delay_seconds = liveness_probe.value.initial_delay_seconds
          timeout_seconds       = liveness_probe.value.timeout_seconds
          success_threshold     = liveness_probe.value.success_threshold
          failure_threshold     = liveness_probe.value.failure_threshold
          dynamic "exec" {
            for_each = liveness_probe.value.exec
            content {
              commands = exec.value.commands
            }
          }
        }
      }

      dynamic "readiness_probe" {
        for_each = containers.value.readiness_probe
        content {
          period_seconds        = readiness_probe.value.period_seconds
          initial_delay_seconds = readiness_probe.value.initial_delay_seconds
          timeout_seconds       = readiness_probe.value.timeout_seconds
          success_threshold     = readiness_probe.value.success_threshold
          failure_threshold     = readiness_probe.value.failure_threshold
          dynamic "exec" {
            for_each = readiness_probe.value.exec
            content {
              commands = exec.value.commands
            }
          }
        }
      }
    }
  }


  dynamic "init_containers" {
    for_each = var.init_containers
    content {
      name              = init_containers.value.name
      image             = init_containers.value.image
      cpu               = init_containers.value.cpu
      gpu               = init_containers.value.gpu
      memory            = init_containers.value.memory
      image_pull_policy = init_containers.value.image_pull_policy
      working_dir       = init_containers.value.working_dir
      commands          = init_containers.value.commands
      args              = init_containers.value.args

      dynamic "ports" {
        for_each = init_containers.value.ports
        content {
          port     = ports.value.port
          protocol = ports.value.protocol
        }
      }

      dynamic "environment_vars" {
        for_each = init_containers.value.environment_vars
        content {
          key   = environment_vars.value.key
          value = environment_vars.value.value
          dynamic "field_ref" {
            for_each = environment_vars.value.field_ref
            content {
              field_path = field_ref.value.field_path
            }
          }
        }
      }

      dynamic "volume_mounts" {
        for_each = init_containers.value.volume_mounts
        content {
          mount_path = volume_mounts.value.mount_path
          read_only  = volume_mounts.value.read_only
          name       = volume_mounts.value.name
        }
      }
    }
  }

  dynamic "volumes" {
    for_each = var.volumes
    content {
      name = volumes.value.name
      type = volumes.value.type
    }
  }
}

