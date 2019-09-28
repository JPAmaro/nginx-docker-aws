/*
 * Creating launch configuration
 */
resource "aws_launch_configuration" "aws" {
  image_id        = "${lookup(var.ec2_amis, var.aws_region)}"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.docker_aws_ec2.id}"]
  user_data       = "${file("user_data.sh")}"

  lifecycle {
    create_before_destroy = true
  }
}

/*
 * Creating auto-scaling group
 */
resource "aws_autoscaling_group" "aws" {
  name                 = "docker-aws-autoscaling-group"
  launch_configuration = "${aws_launch_configuration.aws.id}"
  vpc_zone_identifier  = "${aws_subnet.private.*.id}"

  desired_capacity = 3
  max_size = 6
  min_size = 1

  health_check_type = "ELB"

  tag {
    key = "Name"
    value = "docker-aws-asg"
    propagate_at_launch = true
  }
}

/*
 * ALB DNS is generated dynamically, return URL
 */
output "url" {
  value = "http://${aws_alb.docker_aws_alb.dns_name}/"
}
