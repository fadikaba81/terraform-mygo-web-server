output "availability_zone" {
  value       = data.aws_availability_zones.availability.names
  description = "availability_zone"
}