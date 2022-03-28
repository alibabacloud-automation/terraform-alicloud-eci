Terraform Module for creating ECI resources on Alibaba Cloud.


terraform-alicloud-eci
=====================================================================

[English](README.md) | 简体中文

本 Module 用于在阿里云自动化创建和管理弹性容器实例，包括实例、镜像缓存、虚拟节点等。

本 Module 支持创建以下资源:

* [alicloud_eci_container_group](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/eci_container_group)
* [alicloud_eci_image_cache](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/eci_image_cache)
* [alicloud_eci_virtual_node](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/eci_virtual_node)

## 用法

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

## 示例

* [Clickhouse 完整示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-eci/tree/main/examples/complete)

## 注意事项

* 本 Module 使用的 AccessKey 和 SecretKey 可以直接从 `profile` 和 `shared_credentials_file`
  中获取。如果未设置，可通过下载安装 [aliyun-cli](https://github.com/aliyun/aliyun-cli#installation) 后进行配置.

## 要求

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > = 0.13.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | > = 1.145.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | > = 1.145.0 |

## 提交问题

如果在使用该 Terraform Module
的过程中有任何问题，可以直接创建一个 [Provider Issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new)，我们将根据问题描述提供解决方案。

**注意:** 不建议在该 Module 仓库中直接提交 Issue。

## 作者

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## 许可

MIT Licensed. See LICENSE for full details.

## 参考

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)
