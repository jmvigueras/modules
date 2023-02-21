#---------------------------------------------------------------------
# Create https load balancing to vm spokes as backend
# - Create public IP
# - Create forwarding rule to target proxy
# - Create target proxies (https and http)
# - Create url-map 
# - Create backend groups and endopoints (NON_GCP_PRIVATE_IP_PORT)
#---------------------------------------------------------------------
## Create frontend for https
resource "google_compute_global_address" "elb_frontend_pip_2" {
  name         = "${var.prefix}-elb-frontend-eip-3"
  address_type = "EXTERNAL"
}
## ELB Frontend forwarding rule to proxy
resource "google_compute_global_forwarding_rule" "elb_fwd-rule_https" {
  name = "${var.prefix}-elb-fwd-rule-https"

  ip_address            = google_compute_global_address.elb_frontend_pip_2.id
  ip_protocol           = "TCP"
  port_range            = "443"
  load_balancing_scheme = "EXTERNAL"
  target                = google_compute_target_https_proxy.elb_https_proxy.id
}
resource "google_compute_global_forwarding_rule" "elb_fwd-rule_http" {
  name = "${var.prefix}-elb-fwd-rule-http"

  ip_address            = google_compute_global_address.elb_frontend_pip_2.id
  ip_protocol           = "TCP"
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL"
  target                = google_compute_target_http_proxy.elb_http_proxy.id
}
## SSL certificate to upload
resource "google_compute_ssl_certificate" "elb_https_cert" {
  name        = "${var.prefix}-elb-ssl-cert"
  private_key = file("assets/domain.key")
  certificate = file("assets/domain.crt")
}
## Create HTTP(S) Proxy
resource "google_compute_target_https_proxy" "elb_https_proxy" {
  name             = "${var.prefix}-elb-https-proxy"
  url_map          = google_compute_url_map.elb_https_l7.id
  ssl_certificates = [google_compute_ssl_certificate.elb_https_cert.id]
}
resource "google_compute_target_http_proxy" "elb_http_proxy" {
  name    = "${var.prefix}-elb-http-proxy"
  url_map = google_compute_url_map.elb_https_l7.id
}

## Create LB with URL MAP to backend network endpoint
resource "google_compute_url_map" "elb_https_l7" {
  name = "${var.prefix}-elb-https-l7"

  default_service = google_compute_backend_service.bck-end-srv_net-endpoint.id

  /*
  host_rule {
    hosts        = ["fortinet.local"]
    path_matcher = "allpaths"
  }
  path_matcher {
    name            = "allpaths"
    default_service = google_compute_region_backend_service.elb_https_bck-srv.id

    path_rule {
      paths   = ["/*"]
      service = google_compute_region_backend_service.elb_https_bck-srv.id
    }
  }
  */
}
## Create health-check
resource "google_compute_health_check" "bck-end-srv_health-check" {
  name = "${var.prefix}-http-health-check"
  http_health_check {
    port = "80"
  }
}
## Create BackEnd Service Load Balancer
resource "google_compute_backend_service" "bck-end-srv_net-endpoint" {
  name = "${var.prefix}-bck-end-to-net-endpoint"

  backend {
    balancing_mode        = "RATE"
    max_rate_per_endpoint = 100
    group                 = google_compute_network_endpoint_group.net-endpoint_group.id
  }

  health_checks = [google_compute_health_check.bck-end-srv_health-check.id]
}
/*
## Create Network endpoint
resource "google_compute_network_endpoint" "net-endpoint_http" {
  network_endpoint_group = google_compute_network_endpoint_group.net-endpoint_group.name
  port                   = "80"
  ip_address             = local.ilb_vm_ip
}
*/
## Create Network endpoint to VPC spokes vm
resource "google_compute_network_endpoint" "net-endpoint_spoke_http" {
  count                  = length(module.vm_spoke.vm["ip"])
  network_endpoint_group = google_compute_network_endpoint_group.net-endpoint_group.name
  port                   = "80"
  ip_address             = module.vm_spoke.vm["ip"][count.index]
}
## Create Network endpoint group
resource "google_compute_network_endpoint_group" "net-endpoint_group" {
  name                  = "${var.prefix}-net-endpoint-group"
  network               = local.fgt-vpc_name["public"]
  network_endpoint_type = "NON_GCP_PRIVATE_IP_PORT"
}

