output "ipv4" {
  value = "${local.ip_vm} + ${nonsensitive(random_password.vm_user.result)}"
}

output "fqdn" {
  value = aws_route53_record.www.fqdn
}
