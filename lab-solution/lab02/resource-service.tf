# ############################# Task 6 ##################################
# Target Group
resource "aws_lb_target_group" "app" {
  name     = "app-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path               = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

# ELB
resource "aws_lb" "elb" {
  name_prefix        = "elb-"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg["elb"].id]
  subnets            = aws_subnet.public[*].id
  depends_on = [aws_lb_target_group.app]
}

resource "aws_lb_listener" "app" {
    load_balancer_arn = aws_lb.elb.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.app.arn
    }
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
  count            = var.n_app
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.app[count.index].id
  port             = 8080
}


data "http" "elb_hc" {
  url = "http://${aws_lb.elb.dns_name}"
  retry {
      attempts=10
      max_delay_ms=10000
  }
}

resource "terraform_data" "health_check_elb" {
  provisioner "local-exec" {
    command = contains([200,201], data.http.elb_hc.status_code)
  }
}