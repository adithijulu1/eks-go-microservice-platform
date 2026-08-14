resource "aws_dx_gateway" "hybrid_gateway" {
  name            = "${var.cluster_name}-dx-gateway"
  amazon_side_asn = 64512
}

resource "aws_dx_gateway_association" "hybrid_gateway_assoc" {
  dx_gateway_id         = aws_dx_gateway.hybrid_gateway.id
  associated_gateway_id = aws_vpn_gateway.main.id
}

resource "aws_vpn_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.cluster_name}-vgw"
  }
}
