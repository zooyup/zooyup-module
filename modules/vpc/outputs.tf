output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = length(aws_subnet.public) > 0 ? aws_subnet.public[*].id : []
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = length(aws_subnet.private) > 0 ? aws_subnet.private[*].id : []
}

output "db_subnet_ids" {
  description = "List of IDs of database subnets"
  value       = length(aws_subnet.db) > 0 ? aws_subnet.db[*].id : []
}

output "etc_subnet_ids" {
  description = "List of IDs of etc subnets"
  value       = length(aws_subnet.etc) > 0 ? aws_subnet.etc[*].id : []
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = length(aws_internet_gateway.this) > 0 ? aws_internet_gateway.this[0].id : null
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = length(aws_nat_gateway.this) > 0 ? aws_nat_gateway.this[*].id : null
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = length(aws_route_table.public) > 0 ? aws_route_table.public.id : null
}

output "private_route_table_ids" {
  description = "List of private route table IDs"
  value       = length(aws_route_table.private) > 0 ? aws_route_table.private[*].id : null
}

output "db_route_table_id" {
  description = "The ID of the database route table"
  value       = length(aws_route_table.db) > 0 ? aws_route_table.db[0].id : null
}

output "etc_route_table_id" {
  description = "The ID of the etc route table"
  value       = length(aws_route_table.etc) > 0 ? aws_route_table.etc[0].id : null
} 