# Configuração de portas para o ambiente EC2 T2
data "http" "meu_ip" {
  url = "https://ifconfig.me"
}

locals {

  ingress_ports = [
    {
      port        = 22
      protocol    = "tcp"
      cidr_blocks = ["${chomp(data.http.meu_ip.response_body)}/32"]
      description = "SSH"
    },
    {
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP"
    },
    {
      port        = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS"
    },
    {
      port        = 6443
      protocol    = "tcp"
      cidr_blocks = ["${chomp(data.http.meu_ip.response_body)}/32"]
      description = "K3s API Server"
    }
  ]
}
