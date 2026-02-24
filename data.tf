# Aviatrix Transit Gateway Data Source
data "aviatrix_transit_gateway" "avx_transit_gw" {
  gw_name = var.avx_transit_gw_name
}

# AWS TGW Data Source
data "aws_ec2_transit_gateway" "aws_tgw" {
  id = var.aws_tgw_id
}