Terraform Module for creating ECI resources on Alibaba Cloud.

terraform-alicloud-eci
=====================================================================

English | [简体中文](README-CN.md)

This module is used to create a ECI resources under Alibaba Cloud.

These types of resources are supported:

* [alicloud_eci_container_group](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/eci_container_group)
* [alicloud_eci_image_cache](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/eci_image_cache)
* [alicloud_eci_virtual_node](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/eci_virtual_node)

## Usage

<div style="display: block;margin-bottom: 40px;"><div class="oics-button" style="float: right;position: absolute;margin-bottom: 10px;">
  <a href="https://api.aliyun.com/terraform?source=Module&activeTab=document&sourcePath=terraform-alicloud-modules%3A%3Aeci&spm=docs.m.terraform-alicloud-modules.eci&intl_lang=EN_US" target="_blank">
    <img alt="Open in AliCloud" src="https://img.alicdn.com/imgextra/i1/O1CN01hjjqXv1uYUlY56FyX_!!6000000006049-55-tps-254-36.svg" style="max-height: 44px; max-width: 100%;">
  </a>
</div></div>

```hcl
module "example" {
  source             = "terraform-alicloud-modules/eci/alicloud"
  #alicloud_eci_image_cache
  create_image_cache = true
  image_cache_name   = "tf-name"
  image              = "registry-vpc.cn-beijing.aliyuncs.com/eci_open/nginx:alpine"
  security_group_id  = "sg-123456xxx"
  vswitch_id         = "vsw-123456xxx"
  eip_instance_id    = "eip-123456xxx"
  resource_group_id  = "rg-123456xxx"
  #alicloud_eci_virtual_node
  virtual_node_name     = "tf-name"
  create_virtual_node   = true
  enable_public_network = false
  kube_config           = "kube_config"
  taints                = {
    effect = "NoSchedule"
    key    = "Tf1"
    value  = "Test1"
  }
  #alicloud_eci_container_group
  create_container_group           = true
  container_group_name             = "tf-name"
  cpu                              = 8.0
  memory                           = 16.0
  restart_policy                   = "Always"
  container_name                   = "nginx"
  container_working_dir            = "/tmp/nginx"
  container_image_pull_policy      = "IfNotPresent"
  container_commands               = ["/bin/sh", "-c", "sleep 9999"]
  volume_mounts                    = {
    mount_path = "/tmp/test"
    read_only  = false
    name       = "empty1"
  }
  environment_vars                 = {
    key   = "test"
    value = "busybox"
  }
  init_container_name              = "init-busybox"
  init_container_image             = "registry-vpc.cn-beijing.aliyuncs.com/eci_open/busybox:1.30"
  init_container_image_pull_policy = "IfNotPresent"
  init_container_commands          = ["echo"]
  init_container_args              = ["hello initcontainer"]
  volumes                          = {
    name = "empty1"
    type = "EmptyDirVolume"
  }
  ports = {
    port     = 80
    protocol = "TCP"
  }
}
```

## Examples

* [complete example](https://github.com/terraform-alicloud-modules/terraform-alicloud-eci/tree/main/examples/complete)

## Notes

* This module using AccessKey and SecretKey are from `profile` and `shared_credentials_file`. If you have not set them
  yet, please install [aliyun-cli](https://github.com/aliyun/aliyun-cli#installation) and configure it.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > = 0.13.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | > = 1.145.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | > = 1.145.0 |

## Submit Issues

If you have any problems when using this module, please opening
a [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend opening an issue on this repo.

## Authors

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## License

MIT Licensed. See LICENSE for full details.

## Reference

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)
