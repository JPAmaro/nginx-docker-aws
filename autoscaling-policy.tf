/*
 * Scale up alarm
 */
resource "aws_autoscaling_policy" "aws-cpu-policy" {
	name                   = "aws-cpu-policy"
	autoscaling_group_name = "${aws_autoscaling_group.aws.name}"
	adjustment_type        = "ChangeInCapacity"
	scaling_adjustment     = "1"
	cooldown               = "300"
	policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "aws-cpu-alarm" {
	alarm_name          = "aws-cpu-alarm"
	alarm_description   = "aws-cpu-alarm"
	comparison_operator = "GreaterThanOrEqualToThreshold"
	evaluation_periods  = "2"
	metric_name         = "CPUUtilization"
	namespace           = "AWS/EC2"
	period              = "120"
	statistic           = "Average"
	threshold           = "60"

  dimensions = {
		"AutoScalingGroupName" = "${aws_autoscaling_group.aws.name}"
	}

  actions_enabled = true
	alarm_actions   = ["${aws_autoscaling_policy.aws-cpu-policy.arn}"]
}


/*
 * Scale down alarm
 */
resource "aws_autoscaling_policy" "aws-cpu-policy-scaledown" {
	name                   = "aws-cpu-policy-scaledown"
	autoscaling_group_name = "${aws_autoscaling_group.aws.name}"
	adjustment_type        = "ChangeInCapacity"
	scaling_adjustment     = "-1"
	cooldown               = "300"
	policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "aws-cpu-alarm-scaledown" {
	alarm_name          = "aws-cpu-alarm-scaledown"
	alarm_description   = "aws-cpu-alarm-scaledown"
	comparison_operator = "LessThanOrEqualToThreshold"
	evaluation_periods  = "2"
	metric_name         = "CPUUtilization"
	namespace           = "AWS/EC2"
	period              = "120"
	statistic           = "Average"
	threshold           = "50"

  dimensions = {
		"AutoScalingGroupName" = "${aws_autoscaling_group.aws.name}"
	}

	actions_enabled = true
	alarm_actions   = ["${aws_autoscaling_policy.aws-cpu-policy-scaledown.arn}"]
}
