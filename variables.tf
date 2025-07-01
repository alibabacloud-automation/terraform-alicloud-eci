variable "vswitch_id" {
  description = "The ID of the VSwitch."
  type        = string
  default     = null
}

variable "resource_group_id" {
  description = "The ID of the resource group."
  type        = string
  default     = null
}

variable "security_group_id" {
  description = "The ID of the security group."
  type        = string
  default     = null
}

variable "zone_id" {
  description = "The ID of the zone"
  type        = string
  default     = null
}


#alicloud_eci_image_cache
variable "create_image_cache" {
  description = "Controls if image cache should be created"
  type        = bool
  default     = false
}

variable "image_cache_name" {
  description = "The name of the image cache."
  type        = string
  default     = null
}

variable "images" {
  description = "The images to be cached. The image name must be versioned."
  type        = list(string)
  default     = null
}

variable "eip_instance_id" {
  description = "The instance ID of the Elastic IP Address (EIP). "
  type        = string
  default     = null
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
  default     = null
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
  type        = list(map(string))
  default     = []
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
  default     = null
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

variable "instance_type" {
  description = "The instance type of the container group."
  type        = string
  default     = null
}


variable "image_registry_credential" {
  description = "The image registry credential."
  type = list(object({
    user_name = string
    password  = string
    server    = string
  }))
  default = []
}

variable "containers" {
  description = "The list of containers."
  type = list(object({
    name              = string
    image             = string
    cpu               = optional(string, null)
    gpu               = optional(string, null)
    memory            = optional(string, null)
    image_pull_policy = optional(string, null)
    working_dir       = optional(string, null)
    commands          = optional(list(string), null)
    args              = optional(list(string), null)
    ports = optional(list(object({
      port     = optional(string, null)
      protocol = optional(string, null)
    })), [])
    environment_vars = optional(list(object({
      key   = optional(string, null)
      value = optional(string, null)
      field_ref = optional(list(object({
        field_path = optional(string, null)
      })), [])
    })), [])
    volume_mounts = optional(list(object({
      mount_path = optional(string, null)
      read_only  = optional(bool, null)
      name       = optional(string, null)
    })), [])
    liveness_probe = optional(list(object({
      period_seconds        = optional(number, null)
      initial_delay_seconds = optional(number, null)
      success_threshold     = optional(number, null)
      failure_threshold     = optional(number, null)
      timeout_seconds       = optional(number, null)
      exec = optional(list(object({
        commands = optional(list(string), null)
      })), [])
    })), [])
    readiness_probe = optional(list(object({
      period_seconds        = optional(number, null)
      initial_delay_seconds = optional(number, null)
      success_threshold     = optional(number, null)
      failure_threshold     = optional(number, null)
      timeout_seconds       = optional(number, null)
      exec = optional(list(object({
        commands = optional(list(string), null)
      })), [])
    })), [])
  }))
  default = []
}

variable "init_containers" {
  description = "The list of init containers."
  type = list(object({
    name              = optional(string, null)
    image             = optional(string, null)
    cpu               = optional(string, null)
    gpu               = optional(string, null)
    memory            = optional(string, null)
    image_pull_policy = optional(string, null)
    working_dir       = optional(string, null)
    commands          = optional(list(string), null)
    args              = optional(list(string), null)
    ports = optional(list(object({
      port     = optional(number, null)
      protocol = optional(string, null)
    })), [])
    environment_vars = optional(list(object({
      key   = optional(string, null)
      value = optional(string, null)
      field_ref = optional(list(object({
        field_path = string
      })), [])
    })), [])
    volume_mounts = optional(list(object({
      mount_path = optional(string, null)
      read_only  = optional(bool, null)
      name       = optional(string, null)
    })), [])
  }))
  default = []
}

variable "volumes" {
  description = "The list of volumes."
  type = list(object({
    name = optional(string, null)
    type = optional(string, null)
  }))

  default = []
}

