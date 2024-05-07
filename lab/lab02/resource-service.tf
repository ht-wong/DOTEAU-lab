# ############################# Task 6 ##################################
/*
# Target Group
# ELB
resource "aws_lb" "elb" {
  # 要等待 target group 构建完成
  depends_on = 
  name_prefix        = "elb-"
  load_balancer_type = "application"
  # 使用 elb sg
  security_groups    = 
  # 部署在 public subnets
  subnets            = 
}

resource "aws_lb_listener" "app" {
    load_balancer_arn = 
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.app.arn
    }
}

resource "aws_lb_target_group" "app" {
  name     = "app-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = 

  health_check {
    path               = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
  # 将所有 app instance 添加到 app target group 中
  target_group_arn = 
  # 添加 Instance ID
  target_id        = 
  port             = 8080
}

# 需要判断检测 ELB 正常工作，APP 运行正常
resource "terraform_data" "health_check_elb" {}
*/