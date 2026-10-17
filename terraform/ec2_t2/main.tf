#Define o sistema ubuntu para ser usado na ec2.
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}

#Cria um Key Pair AWS para acesso SSH
locals {
  public_key_path = var.os_type == "windows" ? var.public_key_path_windows : var.public_key_path_linux
}

resource "aws_key_pair" "chave_ec2" {
  key_name   = "chave-acesso-simples"
  public_key = file(local.public_key_path)
}

#Utiliza o módulo de Security Group dinâmico.
module "security_group" {
  source = "../modules/security-group"

  security_group_name = "sg_acesso_ec2_t2"
  description         = "Security Group para EC2 T2 com K3s"
  ingress_rules       = local.ingress_ports

  tags = {
    Name = "mzhtml"
  }
}

#Cria a instância EC2 t2.micro.
resource "aws_instance" "maquina_simples" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  key_name                    = aws_key_pair.chave_ec2.key_name
  security_groups             = [module.security_group.security_group_name]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              # Atualiza os pacotes e instala o curl caso a AMI não tenha por padrão
              apt-get update -y && apt-get install -y curl
             
              sleep 60

              # Baixa o script k3s_deployment.sh de implementação do k3s do github e faz a implementação da imagem docker contendo o html estático no k3s via deployment, services e ingress.
              curl -sfL https://raw.githubusercontent.com/DanielMozartt/iac-aws/refs/heads/main/shell/k3s_deployment.sh | sh -
            EOF

  tags = {
    Name = "mzhtml"
  }
}
