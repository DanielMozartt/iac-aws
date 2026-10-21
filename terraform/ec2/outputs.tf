#Exibe o IP Público da máquina após a criação
output "public_ip" {
  value       = aws_instance.ec2.public_ip
  description = "O IP público da instância EC2"
}