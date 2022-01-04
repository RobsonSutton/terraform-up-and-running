resource "aws_lb" "web_server_lb" {                             # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
  name               = "web-server-lb"                          # Name load balancer
  load_balancer_type = "application"                            # use application load balancer for HTTP (layer 7 - OSI) 
  subnets            = data.aws_subnet_ids.default.ids          # resource will scale up and down lb's within seperate AZ's (not just 1 static resource)
  security_groups    = [aws_security_group.web_server_lb_sg.id] # Assign ALB security group
}

resource "aws_lb_listener" "http" {            # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
  load_balancer_arn = aws_lb.web_server_lb.arn # Assign to web server load balancer
  port              = 80
  protocol          = "HTTP"

  # Configure default response for traffic not matching lb listener rules
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: Page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "web_server_lb_tg" { # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
  name     = "web-server-lb-tg"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  # Define health check for load balancer checking instances managed by ASG
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "web_server_lb_lr" { # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_server_lb_tg.arn
  }
}

resource "aws_security_group" "web_server_lb_sg" { # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
  name = "web-server-lb-sg"

  # Allow only inbound http traffic
  ingress {
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
  }

  # Allow all outbound network traffic
  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
  }
}