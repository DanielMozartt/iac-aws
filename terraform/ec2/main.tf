#Define a região do projeto.
provider "aws" {
  region = "us-east-1"
}

#Define o tipo da EC2 com base na entrada recebida pelo usuário em -var="", valor padrão sem declarar é t4g.micro.
locals {
  is_arm           = length(regexall("^t4g", var.ec2_type)) > 0
  canonical_arch   = local.is_arm ? "arm64" : "amd64"
  aws_architecture = local.is_arm ? "arm64" : "x86_64"
}

#Seleciona a AMI correta baseada na arquitetura escolhida.
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-${local.canonical_arch}-server-*"]
  }

  filter {
    name   = "architecture"
    values = [local.aws_architecture]
  }
}


#Captura meu ip atual para acessos nas portas privadas.
data "http" "meu_ip" {
  url = "https://checkip.amazonaws.com"
}

locals {

  cidr = ["${chomp(data.http.meu_ip.response_body)}/32"]
}

#Define o grupo de segurança para a EC2.
resource "aws_security_group" "k3s_mzhtml_sg" {
  name        = "k3s-mzhtml-sg"
  description = "Security Group para a aplicacao mzhtml"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = local.cidr
    description = "SSH"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = local.cidr
    description = "K3s API Server"
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
  }

  tags = {
    Name = "mzhtml"
  }
}

#Cria um Key Pair AWS para acesso SSH
locals {
  public_key_path = var.public_key_path
}

resource "aws_key_pair" "chave_ec2_mzhtml" {
  key_name   = "chave-acesso-ec2-simples"
  public_key = file(var.public_key_path)
}

#Cria a instância EC2 t2.micro ou t3.micro.
resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_type

  key_name                    = aws_key_pair.chave_ec2_mzhtml.key_name
  vpc_security_group_ids      = [aws_security_group.k3s_mzhtml_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              # Atualiza os pacotes e instala o curl caso a AMI não tenha por padrão
              apt-get update -y && apt-get install -y curl
             
              sleep 60

              # Baixa o script k3s_deployment.sh de implementação do k3s do github e faz a implementação da imagem docker contendo o html estático no k3s via deployment, services e ingress.
              curl -sfL https://raw.githubusercontent.com/DanielMozartt/iac-aws/main/shell/k3s_deployment.sh | sh -
            EOF

  tags = {
    Name = "mzhtml"
  }
}
