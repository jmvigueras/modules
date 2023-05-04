#---------------------------------------------------------------------------
# GWLB
# - Create GWLB
# - Create Endpoint Service
# - Create Target Group
# - Create Listener 
# - Attach Fortigate IPs to target group
#---------------------------------------------------------------------------
// Create Gateway LB
resource "aws_lb" "gwlb" {
  load_balancer_type               = "gateway"
  name                             = "${var.prefix}-gwlb"
  enable_cross_zone_load_balancing = false
  subnets                          = var.subnet_ids
}
// Create GWLB Service
resource "aws_vpc_endpoint_service" "gwlb_service" {
  acceptance_required        = false
  allowed_principals         = [data.aws_caller_identity.current.arn]
  gateway_load_balancer_arns = [aws_lb.gwlb.arn]
}
// Create Gateway LB target group GENEVE
resource "aws_lb_target_group" "gwlb_target-group" {
  name        = "${var.prefix}-gwlb-tg"
  port        = 6081
  protocol    = "GENEVE"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    port     = var.backend_port
    protocol = var.backend_protocol
    interval = var.backend_interval
  }
}
// Create Gateway LB Listener
resource "aws_lb_listener" "gwlb_listener" {
  load_balancer_arn = aws_lb.gwlb.id

  default_action {
    target_group_arn = aws_lb_target_group.gwlb_target-group.id
    type             = "forward"
  }
}
// Create GWLB target group attachemnt to FGT 1
resource "aws_lb_target_group_attachment" "gwlb_tg_fgt_1" {
  target_group_arn = aws_lb_target_group.gwlb_target-group.arn
  target_id        = var.fgt_1_ip
}
// Create GWLB target group attachemnt to FGT 2
resource "aws_lb_target_group_attachment" "gwlb_tg_fgt_2" {
  target_group_arn = aws_lb_target_group.gwlb_target-group.arn
  target_id        = var.fgt_2_ip
}
// Create VPC endpoints GWLB
resource "aws_vpc_endpoint" "gwlb_endpoints" {
  count             = length(var.subnet_ids)
  service_name      = aws_vpc_endpoint_service.gwlb_service.service_name
  subnet_ids        = [var.subnet_ids[count.index]]
  vpc_endpoint_type = "GatewayLoadBalancer"
  vpc_id            = var.vpc_id

  tags = {
    Name = "${var.prefix}-gwlb-endpoint-az${count.index + 1}"
  }
}


// Principal ARN to discover GWLB Service
data "aws_caller_identity" "current" {}

// Create GWLB NI resource with NI IDs
data "aws_network_interface" "gwlb_ni" {
  count = length(var.subnet_ids)
  filter {
    name   = "description"
    values = ["ELB gwy/${aws_lb.gwlb.name}/*"]
  }
  filter {
    name   = "subnet-id"
    values = ["${var.subnet_ids[count.index]}"]
  }
  filter {
    name   = "status"
    values = ["in-use"]
  }
  filter {
    name   = "attachment.status"
    values = ["attached"]
  }
}



