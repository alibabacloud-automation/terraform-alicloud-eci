provider "alicloud" {
  region = "cn-shanghai"
}

# VPC & VSwitch
data "alicloud_eci_zones" "default" {}

resource "alicloud_vpc" "default" {
  vpc_name   = var.name
  cidr_block = "10.4.0.0/16"
}

resource "alicloud_security_group" "security_group" {
  vpc_id              = alicloud_vpc.default.id
  security_group_name = "tf-example-eci"
}

resource "alicloud_vswitch" "default1" {
  count        = 1
  vswitch_name = format("${var.name}_%d", count.index + 1)
  cidr_block   = format("10.4.%d.0/24", count.index + 1)
  zone_id      = data.alicloud_eci_zones.default.zones[0].zone_ids[0]
  vpc_id       = alicloud_vpc.default.id
}


data "alicloud_resource_manager_resource_groups" "default" {}

data "alicloud_regions" "default" {
  current = true
}


# alicloud_eci_image_cache
resource "alicloud_eip_address" "eip_address" {
  address_name = "tf-example-eci"
}

module "image_cache" {
  source = "../.."

  create_image_cache = true
  image_cache_name   = "tf-name"
  images             = ["registry-vpc.${data.alicloud_regions.default.regions[0].id}.aliyuncs.com/eci_open/nginx:alpine"]
  security_group_id  = alicloud_security_group.security_group.id
  vswitch_id         = alicloud_vswitch.default1[0].id
  zone_id            = alicloud_vswitch.default1[0].zone_id
  eip_instance_id    = alicloud_eip_address.eip_address.id
  resource_group_id  = data.alicloud_resource_manager_resource_groups.default.groups[0].id
}

# alicloud_eci_container_group
module "container_group" {
  source = "../.."

  create_container_group = true
  container_group_name   = "tf-name"
  vswitch_id             = alicloud_vswitch.default1[0].id
  zone_id                = alicloud_vswitch.default1[0].zone_id
  security_group_id      = alicloud_security_group.security_group.id
  cpu                    = var.cpu
  memory                 = var.memory
  restart_policy         = var.restart_policy
  containers = [{
    image             = "registry-vpc.${data.alicloud_regions.default.regions[0].id}.aliyuncs.com/eci_open/nginx:alpine"
    name              = "nginx"
    working_dir       = "/tmp/nginx"
    image_pull_policy = "IfNotPresent"
    commands          = ["/bin/sh", "-c", "sleep 9999"]
    volume_mounts = [{
      mount_path = "/tmp/example"
      read_only  = false
      name       = "empty1"
    }]
    ports = [{
      port     = 80
      protocol = "TCP"
    }]
    environment_vars = [{
      key   = "name"
      value = "nginx"
    }]
    liveness_probe = [{
      period_seconds        = "5"
      initial_delay_seconds = "5"
      success_threshold     = "1"
      failure_threshold     = "3"
      timeout_seconds       = "1"
      exec = [{
        commands = ["cat /tmp/healthy"]
      }]
    }]
    readiness_probe = [{
      period_seconds        = "5"
      initial_delay_seconds = "5"
      success_threshold     = "1"
      failure_threshold     = "3"
      timeout_seconds       = "1"
      exec = [{
        commands = ["cat /tmp/healthy"]
      }]
    }]
  }]
  init_containers = [{
    name              = "init-busybox"
    image             = "registry-vpc.${data.alicloud_regions.default.regions[0].id}.aliyuncs.com/eci_open/busybox:1.30"
    image_pull_policy = "IfNotPresent"
    commands          = ["echo"]
    args              = ["hello initcontainer"]
  }]
  volumes = [{
    name = "empty1"
    type = "EmptyDirVolume"
    }, {
    name = "empty2"
    type = "EmptyDirVolume"
  }]
}
