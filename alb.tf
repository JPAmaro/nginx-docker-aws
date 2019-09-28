/*
 * Security group for application load balancer
 */
resource "aws_security_group" "docker_aws_alb_sg" {
  name        = "docker-nginx-aws-alb-sg"
  description = "Allow incoming HTTP traffic only"
  vpc_id      = "${aws_vpc.aws.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-security-group-docker-aws"
  }
}

/*
 * Using ALB - instances in private subnets
 */
resource "aws_alb" "docker_aws_alb" {
  name            = "docker-aws-alb"
  security_groups = ["${aws_security_group.docker_aws_alb_sg.id}"]
  subnets         = "${aws_subnet.private.*.id}"

  tags = {
    Name = "docker_aws_alb"
  }
}

/*
 * ALB target group
 */
resource "aws_alb_target_group" "docker-aws-tg" {
  name     = "docker-aws-alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.aws.id}"

  health_check {
    path = "/"
    port = 80
  }
}

/*
 * Listener
 */
resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = "${aws_alb.docker_aws_alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.docker-aws-tg.arn}"
    type             = "forward"
  }
}

/*
 * Target group attach
 */
resource "aws_alb_target_group_attachment" "docker-aws" {
  count            = "${length(var.azs)}"
  target_group_arn = "${aws_alb_target_group.docker-aws-tg.arn}"
  target_id        = "${element(split(",", join(",", aws_instance.docker_aws.*.id)), count.index)}"
  port             = 80
}
