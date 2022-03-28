
output "vpc_id" {
  description = "The id of vpc."
  value       = module.vpc.this_vpc_id
}

output "security_group_id" {
  description = "The id of security group."
  value       = alicloud_security_group.security_group.id
}

output "image_cache_id" {
  description = "The id of eci image cache."
  value       = module.example.image_cache_id
}

output "virtual_node_id" {
  description = "The id of eci virtual node."
  value       = module.example.virtual_node_id
}

output "container_group_id" {
  description = "The id of eci container group."
  value       = module.example.container_group_id
}

output "container_group_status" {
  description = "The status of eci container group."
  value       = module.example.container_group_status
}