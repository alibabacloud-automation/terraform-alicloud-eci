images                           = ["registry-vpc.cn-beijing.aliyuncs.com/eci_open/nginx:alpine"]
kube_config                      = "kube config"
cpu                              = 8.0
memory                           = 16.0
restart_policy                   = "Always"
container_name                   = "nginx"
container_image                  = "registry-vpc.cn-beijing.aliyuncs.com/eci_open/nginx:alpine"
container_working_dir            = "/tmp/nginx"
container_image_pull_policy      = "IfNotPresent"
container_commands               = ["/bin/sh", "-c", "sleep 9999"]
init_container_name              = "init-busybox"
init_container_image             = "registry-vpc.cn-beijing.aliyuncs.com/eci_open/busybox:1.30"
init_container_image_pull_policy = "IfNotPresent"
init_container_commands          = ["echo"]
init_container_args              = ["hello initcontainer"]
taints     = {
    effect = "NoSchedule"
    key    = "Tf1"
    value  = "Test1"
}
volume_mounts  = {
    mount_path = "/tmp/test"
    read_only  = false
    name       = "empty1"
}
environment_vars  = {
    key           = "test"
    value         = "busybox"
}
volumes    = {
    name   = "empty1"
    type   = "EmptyDirVolume"
}