variable "name" {
  description = "The name of the resources."
  type        = string
  default     = "tf-example"
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




