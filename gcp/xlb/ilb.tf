# Create health checks
resource "google_compute_region_health_check" "ilb_health-check_fgt" {
  name               = "${var.prefix}-ilb-fgt-health-check"
  region             = var.region
  check_interval_sec = 2
  timeout_sec        = 2

  tcp_health_check {
    port = var.backend-probe_port
  }
}

# Create FGT active instance group
resource "google_compute_instance_group" "lb_group_fgt-1" {
  name      = "${var.prefix}-lb-group-fgt-1"
  zone      = var.zone1
  instances = [var.fgt_active_self_link]
}

# Create FGT passive instance group
resource "google_compute_instance_group" "lb_group_fgt-2" {
  name      = "${var.prefix}-lb-group-fgt-2"
  zone      = var.zone2
  instances = [var.fgt_passive_self_link]
}

#------------------------------------------------------------------------------------------------------------
# Create iLB
#------------------------------------------------------------------------------------------------------------
# Create Internal Load Balancer
resource "google_compute_region_backend_service" "ilb" {
  provider = google-beta
  name     = "${var.prefix}-ilb"
  region   = var.region
  network  = var.vpc_names["private"]

  backend {
    group = google_compute_instance_group.lb_group_fgt-1.id
  }
  backend {
    group = google_compute_instance_group.lb_group_fgt-2.id
  }

  health_checks = [google_compute_region_health_check.ilb_health-check_fgt.id]
  connection_tracking_policy {
    connection_persistence_on_unhealthy_backends = "NEVER_PERSIST"
  }
}
# Create forwarding rule to ILB
resource "google_compute_forwarding_rule" "ilb_fwd-rule_all" {
  name   = "${var.prefix}-ilb-fwd-rule-ilb"
  region = var.region

  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.ilb.id
  all_ports             = true
  network               = var.vpc_names["private"]
  subnetwork            = var.subnet_names["private"]
  allow_global_access   = true
  ip_address            = var.ilb_ip
}
# Create route to FGT ILB
resource "google_compute_route" "spoke_route_ilb" {
  count        = var.config_route ? length(var.vpc_spoke_names) : 0
  name         = "${var.prefix}-spoke-${count.index+1}-route-ilb"
  dest_range   = "0.0.0.0/0"
  network      = var.vpc_spoke_names[count.index]
  next_hop_ilb = var.ilb_ip
  priority     = 100
}