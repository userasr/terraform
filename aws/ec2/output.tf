output "Instance-ID" {
  value = aws_instance.analytics-ec2-instance.*.id
}
output "Private-IP" {
  value = [for pvt_ip in aws_instance.analytics-ec2-instance : pvt_ip.private_ip]
}
output "Instance-tags" {
  value = aws_instance.analytics-ec2-instance.*.tags
}
/*output "Connection-String"{
  value = join(" ", "ssh -i ", split("/", data.aws_caller_identity.current.arn)[1], ".pem ec2-user@Private-IP")
}*/
