
output "image_cache_id" {
  description = "The id of eci image cache."
  value       = concat(alicloud_eci_image_cache.image_cache[*].id, [""])[0]
}

output "virtual_node_id" {
  description = "The id of eci virtual node."
  value       = concat(alicloud_eci_virtual_node.virtual_node[*].id, [""])[0]
}

output "container_group_id" {
  description = "The id of eci container group."
  value       = concat(alicloud_eci_container_group.container_group[*].id, [""])[0]
}

output "container_group_status" {
  description = "The status of eci container group."
  value       = concat(alicloud_eci_container_group.container_group[*].status, [""])[0]
}