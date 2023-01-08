output "aws_region" {
  description = "Region set for aws"
  value       = var.aws_region
}

output "ec2_public_dns" {
  description = "EC2 public dns."
  value       = aws_instance.data_eng.ec2_public_dns
}

ouutput "private_key" {
  description = "EC2 private key"
  value       = tls_private_key.teraform_custom_key.private_key_pem
  sensitive   = true
}