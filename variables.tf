variable "avx_transit_gw_name" {
  type = string
  description = "Provide Aviatrix Transit Gateway name"  
}

variable "aws_tgw_id" {
  type = string
  description = "Provide AWS TGW id"
}

variable "connection_name" {
  type = string
  description = "Provide name of the IPSec connection"
}

variable "create_avx_side_connection" {
  type = bool
  description = "Switch to create Aviatrix side connection or not"
  default = false
}

variable "enable_learned_cidrs_approval" {
  type = bool
  description = "(Optional) Enable learned CIDRs approval for the connection."
  default = false
}

variable "approved_cidrs" {
  type = set(string)
  description = "Optional/Computed) Set of approved CIDRs. Requires enable_learned_cidrs_approval to be true."
  default = []
}

variable "number_of_prepends" {
  type = number
  description = "Provide number of AS-Prepends to be inserted"
  default = 0
}

variable "manual_bgp_advertised_cidrs" {
  type = set(string)
  description = "Optional) Configure manual BGP advertised CIDRs for this connection."
  default = []
}