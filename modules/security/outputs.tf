output "security_group" {
  value = aws_security_group.ec2
}

output "ec2_service_role" {
  value = aws_iam_role.ec2_role
}
