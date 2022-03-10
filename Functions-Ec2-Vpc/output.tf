output "vpc_id" {
  description = "List of IDs of instances"
  value       = ["${aws_vpc.default.id}"]
}
output "vpc_name" {
  description = "List of IDs of instances"
  value       = ["${aws_vpc.default.tags.Name}"]
}
output "vpc_cidr" {
  description = "List of IDs of instances"
  value       = ["${aws_vpc.default.cidr_block}"]
}
