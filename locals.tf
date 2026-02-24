locals {
  avx_transit_vpc_id                               = data.aviatrix_transit_gateway.avx_transit_gw.vpc_id
  avx_transit_asn                                  = data.aviatrix_transit_gateway.avx_transit_gw.local_as_number
  avx_transit_gw_name                              = data.aviatrix_transit_gateway.avx_transit_gw.gw_name
  avx_transit_ha_gw_name                           = data.aviatrix_transit_gateway.avx_transit_gw.ha_gw_name
  avx_transit_gw_eip                               = data.aviatrix_transit_gateway.avx_transit_gw.eip
  avx_transit_ha_gw_eip                            = data.aviatrix_transit_gateway.avx_transit_gw.ha_eip
  aws_customer_gateway_name                        = "${local.avx_transit_gw_name}-${var.connection_name}"
  aws_ha_customer_gateway_name                     = "${local.avx_transit_ha_gw_name}-${var.connection_name}"
  aws_tgw_primary_connection_name                  = "${var.connection_name}-primary"
  aws_tgw_ha_connection_name                       = "${var.connection_name}-ha"
  preshared_key                                    = "${random_password.psk_prefix.result}${random_password.psk_body.result}"
  aws_tgw_asn                                      = data.aws_ec2_transit_gateway.aws_tgw.amazon_side_asn
  aws_tgw_primary_connection_tunnel1_outside_ip    = aws_vpn_connection.primary.tunnel1_address
  aws_tgw_primary_connection_tunnel2_outside_ip    = aws_vpn_connection.primary.tunnel2_address
  aws_tgw_ha_connection_tunnel1_outside_ip         = aws_vpn_connection.ha.tunnel1_address
  aws_tgw_ha_connection_tunnel2_outside_ip         = aws_vpn_connection.ha.tunnel2_address
  aws_tgw_primary_connection_tunnel1_vgw_inside_ip = aws_vpn_connection.primary.tunnel1_vgw_inside_address
  aws_tgw_primary_connection_tunnel2_vgw_inside_ip = aws_vpn_connection.primary.tunnel2_vgw_inside_address
  aws_tgw_ha_connection_tunnel1_vgw_inside_ip      = aws_vpn_connection.ha.tunnel1_vgw_inside_address
  aws_tgw_ha_connection_tunnel2_vgw_inside_ip      = aws_vpn_connection.ha.tunnel2_vgw_inside_address
  aws_tgw_primary_connection_tunnel1_cgw_inside_ip = aws_vpn_connection.primary.tunnel1_cgw_inside_address
  aws_tgw_primary_connection_tunnel2_cgw_inside_ip = aws_vpn_connection.primary.tunnel2_cgw_inside_address
  aws_tgw_ha_connection_tunnel1_cgw_inside_ip      = aws_vpn_connection.ha.tunnel1_cgw_inside_address
  aws_tgw_ha_connection_tunnel2_cgw_inside_ip      = aws_vpn_connection.ha.tunnel2_cgw_inside_address
  prepend_as_path                                  = [for i in range(var.number_of_prepends) : local.avx_transit_asn]
}
