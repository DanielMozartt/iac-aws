variable "ec2_t2" {
  description = "Tipo da ec2 (Padrão t2.micro)"
  type        = string
  default     = "t2.micro"
}

variable "ec2_t3" {
  description = "Tipo da ec2 t3.micro"
  type        = string
  default     = "t3.micro"
}

variable "tipo_t3" {
  type        = bool
  default     = false
  description = "Se for true usa T3, se for false usa T2"
}

variable "ec2_type" {
  description = "Tipo da ec2: t2 ou t3"
  type        = string
  default     = "t2"
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