# terraform-aws-tgw-ipsec-bgp-to-avx-transit
This module creates IPSec/BGP connections between AWS TGW and Aviatrix Transit GW

[![diagram](diagram.png "diagram")](https://github.com/jye-aviatrix/terraform-aws-tgw-ipsec-bgp-to-avx-transit/blob/master/diagram.png)

From AWS TGW side, two VPN connections will be created, shown as 
- VPN Connection 1 ({ConnectionName}-Primary)
- VPN Connection 2 ({ConnectionName}-Ha)

Each VPN Connection have two tunnels, shown as:
- VPN Connection 1
  - Tunnel-1 <span style="color:red">Tunnel to Avx Primary GW</span>
  - Tunnel-2 <span style="color:cyan">Tunnel to Avx Primary GW</span>
- VPN Connection 2
  - Tunnel-1 <span style="color:red">Tunnel to Avx HA GW</span>
  - Tunnel-2 <span style="color:cyan">Tunnel to Avx HA GW</span>

On Aviatrix side, two connections will be created:
  - {ConnectionName}-Tunnel1
  - {ConnectionName}-Tunnel2

Each connection will connect to TGW as this methods

  - {ConnectionName}-Tunnel1
    - <span style="color:red">Towards tunnel1 endpoint in {ConnectionName}-Primary </span>
    -  <span style="color:red">Towards tunnel1 endpoint in {ConnectionName}-Ha </span>
  - {ConnectionName}-Tunnel2
    - <span style="color:cyan">Towards tunnel2 endpoint in {ConnectionName}-Primary </span>
    - <span style="color:cyan">Towards tunnel2 endpoint in {ConnectionName}-Ha </span>