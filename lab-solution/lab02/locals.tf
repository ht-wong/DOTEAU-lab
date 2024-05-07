# DONE
locals {
  app             = var.app
  env             = var.env
  revision        = var.revision
  terraform       = true
  resource_prefix = join("/", [local.app, local.env])
  # 挑战
  network_components          = ["vpcs", "subnets", "RouteTables", "igws", "Addresses", "NatGateways", "SecurityGroups"]
  network_network_console_url = { for c in local.network_components : c => "https://${var.region}.console.aws.amazon.com/vpcconsole/home?region=${var.region}#${c}:VpcId=${aws_vpc.main.id}" }
}