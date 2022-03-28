#alicloud_eci_image_cache
variable "create_image_cache" {
  description = "Controls if image cache should be created"
  type        = bool
  default     = false
}

variable "image_cache_name" {
  description = "The name of the image cache."
  type        = string
  default     = ""
}

variable "images" {
  description = "The images to be cached. The image name must be versioned."
  type        = list(string)
  default     = null
}

variable "vswitch_id" {
  description = "The ID of the VSwitch."
  type        = string
  default     = ""
}

variable "resource_group_id" {
  description = "The ID of the resource group."
  type        = string
  default     = ""
}

variable "security_group_id" {
  description = "The ID of the security group."
  type        = string
  default     = ""
}

variable "zone_id" {
  description = "The ID of the zone"
  type        = string
  default     = ""
}

variable "eip_instance_id" {
  description = "The instance ID of the Elastic IP Address (EIP). "
  type        = string
  default     = ""
}

# alicloud_eci_virtual_node
variable "create_virtual_node" {
  description = "Controls if virtual node should be created"
  type        = bool
  default     = false
}

variable "virtual_node_name" {
  description = "The name of the virtual node."
  type        = string
  default     = ""
}

variable "enable_public_network" {
  description = "Whether to enable public network."
  type        = bool
  default     = false
}

variable "kube_config" {
  description = "The kube config for the k8s cluster. It needs to be connected after Base64 encoding."
  type        = string
  default     = null
}

variable "taints" {
  description = "The taint."
  type        = map(string)
  default     = {}
}

variable "virtual_node_tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
#alicloud_eci_container_group
variable "create_container_group" {
  description = "Controls if container group should be created"
  type        = bool
  default     = false
}

variable "container_group_name" {
  description = "The name of the container group."
  type        = string
  default     = ""
}

variable "cpu" {
  description = "The amount of CPU resources allocated to the container group."
  type        = number
  default     = 8.0
}

variable "memory" {
  description = "The amount of memory resources allocated to the container group."
  type        = number
  default     = 16.0
}

variable "restart_policy" {
  description = "The restart policy of the container group. Default to Always."
  type        = string
  default     = "Always"
}

variable "container_image" {
  description = "The image of the container."
  type        = string
  default     = ""
}

variable "container_name" {
  description = "The name of the container."
  type        = string
  default     = ""
}

variable "container_working_dir" {
  description = "The working directory of the container."
  type        = string
  default     = ""
}

variable "container_image_pull_policy" {
  description = "The restart policy of the image."
  type        = string
  default     = "IfNotPresent"
}

variable "container_commands" {
  description = "The commands run by the init container."
  type        = list(string)
  default     = []
}

variable "volume_mounts" {
  description = "The structure of volumeMounts."
  type        = map(string)
  default     = {}
}

variable "ports" {
  description = "The structure of port."
  type        = map(string)
  default     = {}
}

variable "environment_vars" {
  description = "The structure of environmentVars."
  type        = map(string)
  default     = {}
}

variable "init_container_name" {
  description = "The name of the init container."
  type        = string
  default     = ""
}

variable "init_container_image" {
  description = "The image of the container."
  type        = string
  default     = ""
}

variable "init_container_image_pull_policy" {
  description = "The restart policy of the image."
  type        = string
  default     = "IfNotPresent"
}

variable "init_container_commands" {
  description = "The commands run by the init container."
  type        = list(string)
  default     = []
}

variable "init_container_args" {
  description = "The arguments passed to the commands."
  type        = list(string)
  default     = []
}

variable "volumes" {
  description = "The list of volumes."
  type        = map(string)
  default     = {}
}

