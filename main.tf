# Create primary customer gateway maps to Aviatrix Primary GW
resource "aws_customer_gateway" "primary" {
  bgp_asn    = local.avx_transit_asn
  ip_address = local.avx_transit_gw_eip
  type       = "ipsec.1"

  tags = {
    Name = local.aws_customer_gateway_name
  }
}

# Create primary customer gateway maps to Aviatrix HA GW
resource "aws_customer_gateway" "ha" {
  bgp_asn    = local.avx_transit_asn
  ip_address = local.avx_transit_ha_gw_eip
  type       = "ipsec.1"

  tags = {
    Name = local.aws_ha_customer_gateway_name
  }
}

# Generate pre-shared key prefix, can only be alphabets
resource "random_password" "psk_prefix" {
  length  = 1
  special = false
  lower   = true
  numeric = false
  upper   = true
}

# Generate pre-shared key body
resource "random_password" "psk_body" {
  length  = 31
  special = false
  lower   = true
  numeric = true
  upper   = true
}

# Create first VPN connection towards Aviatrix Primary GW
resource "aws_vpn_connection" "primary" {
  customer_gateway_id = aws_customer_gateway.primary.id
  transit_gateway_id  = data.aws_ec2_transit_gateway.aws_tgw.id
  type                = aws_customer_gateway.primary.type
  tags = {
    Name = local.aws_tgw_primary_connection_name
  }
  tunnel1_preshared_key = local.preshared_key
  tunnel2_preshared_key = local.preshared_key
}

# Create second VPN connection towards Aviatrix HA GW
resource "aws_vpn_connection" "ha" {
  customer_gateway_id = aws_customer_gateway.ha.id
  transit_gateway_id  = data.aws_ec2_transit_gateway.aws_tgw.id
  type                = aws_customer_gateway.ha.type
  tags = {
    Name = local.aws_tgw_ha_connection_name
  }
  tunnel1_preshared_key = local.preshared_key
  tunnel2_preshared_key = local.preshared_key
}


resource "aviatrix_transit_external_device_conn" "tunnel1" {
  count                         = var.create_avx_side_connection ? 1 : 0
  vpc_id                        = local.avx_transit_vpc_id
  connection_name               = "${var.connection_name}-tunnel1"
  gw_name                       = local.avx_transit_gw_name
  connection_type               = "bgp"
  enable_ikev2                  = true
  bgp_local_as_num              = local.avx_transit_asn
  bgp_remote_as_num             = local.aws_tgw_asn
  remote_gateway_ip             = "${local.aws_tgw_primary_connection_tunnel1_outside_ip},${local.aws_tgw_ha_connection_tunnel1_outside_ip}"
  local_tunnel_cidr             = "${local.aws_tgw_primary_connection_tunnel1_cgw_inside_ip}/30,${local.aws_tgw_ha_connection_tunnel1_cgw_inside_ip}/30"
  remote_tunnel_cidr            = "${local.aws_tgw_primary_connection_tunnel1_vgw_inside_ip}/30,${local.aws_tgw_ha_connection_tunnel1_vgw_inside_ip}/30"
  pre_shared_key                = local.preshared_key
  enable_learned_cidrs_approval = var.enable_learned_cidrs_approval
  approved_cidrs                = var.approved_cidrs
  prepend_as_path               = local.prepend_as_path
  manual_bgp_advertised_cidrs   = var.manual_bgp_advertised_cidrs
  lifecycle {
    ignore_changes = [backup_bgp_remote_as_num, backup_remote_gateway_ip, disable_activemesh, ha_enabled, local_tunnel_cidr, remote_gateway_ip, remote_tunnel_cidr]
  }

}

resource "aviatrix_transit_external_device_conn" "tunnel2" {
  count                         = var.create_avx_side_connection ? 1 : 0
  vpc_id                        = local.avx_transit_vpc_id
  connection_name               = "${var.connection_name}-tunnel2"
  gw_name                       = local.avx_transit_gw_name
  connection_type               = "bgp"
  enable_ikev2                  = true
  bgp_local_as_num              = local.avx_transit_asn
  bgp_remote_as_num             = local.aws_tgw_asn
  remote_gateway_ip             = "${local.aws_tgw_primary_connection_tunnel2_outside_ip},${local.aws_tgw_ha_connection_tunnel2_outside_ip}"
  local_tunnel_cidr             = "${local.aws_tgw_primary_connection_tunnel2_cgw_inside_ip}/30,${local.aws_tgw_ha_connection_tunnel2_cgw_inside_ip}/30"
  remote_tunnel_cidr            = "${local.aws_tgw_primary_connection_tunnel2_vgw_inside_ip}/30,${local.aws_tgw_ha_connection_tunnel2_vgw_inside_ip}/30"
  pre_shared_key                = local.preshared_key
  enable_learned_cidrs_approval = var.enable_learned_cidrs_approval
  approved_cidrs                = var.approved_cidrs
  prepend_as_path               = local.prepend_as_path
  manual_bgp_advertised_cidrs   = var.manual_bgp_advertised_cidrs
  lifecycle {
    ignore_changes = [backup_bgp_remote_as_num, backup_remote_gateway_ip, disable_activemesh, ha_enabled, local_tunnel_cidr, remote_gateway_ip, remote_tunnel_cidr]
  }
}
