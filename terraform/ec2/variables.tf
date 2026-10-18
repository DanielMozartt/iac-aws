variable "ec2_type" {
  type        = string
  default     = "t3.micro"
  description = "Tipo da instância t2.micro, t3.micro ou t4g.micro)"
}

variable "public_key_path" {
  description = "Caminho da chave pública no Linux"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  sensitive   = true
}

variable "username" {
  type        = string
  description = "Usuário do sistema operacional da AMI"
}