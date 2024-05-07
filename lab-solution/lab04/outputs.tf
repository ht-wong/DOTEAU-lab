output "revision" { value = var.revision }

output "az_names" {
  value = data.aws_availability_zones.available.names
}

output "vpc_console_url" {
  value = local.network_network_console_url
}

# output "demo" {
#   for_each = var.main_sg[each.key].ingress
#   value = each.value[0]
# }

output "ami" {
  value = data.aws_ami.amzn2.id
}