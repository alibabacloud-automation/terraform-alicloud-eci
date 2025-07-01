
output "vpc_id" {
  description = "The id of vpc."
  value       = alicloud_vpc.default.id
}

output "security_group_id" {
  description = "The id of security group."
  value       = alicloud_security_group.security_group.id
}

output "image_cache_id" {
  description = "The id of eci image cache."
  value       = module.image_cache.image_cache_id
}


output "container_group_id" {
  description = "The id of eci container group."
  value       = module.container_group.container_group_id
}

output "container_group_status" {
  description = "The status of eci container group."
  value       = module.container_group.container_group_status
}