# Cria a chave SSH id_rsa.pub se não existir.
if (-not(Get-ChildItem $HOME\.ssh\id_rsa.pub -ErrorAction SilentlyContinue)) {
    ssh-keygen -t rsa -b 4096 -f $HOME\.ssh\id_rsa -N ""
}

# Inicializa e aplica o Terraform
terraform -chdir=terraform/ec2_t2 init -upgrade
terraform -chdir=terraform/ec2_t2 plan -var="os_type=windows"
terraform -chdir=terraform/ec2_t2 apply -var="os_type=windows" -auto-approve

# Exporta o output em JSON
terraform -chdir=terraform/ec2_t2 output -json | Out-File -FilePath terraform/ec2_t2/ip_publico.json -Encoding utf8

Start-Sleep 10

# Armazena o IP público em uma variável PowerShell
$IP_PUBLICO = terraform -chdir=terraform/ec2_t2 output -raw public_ip

# Lê o script de implementação do k3s e joga direto no interpretador bash do Linux remoto.
Get-Content -Raw ".\shell\k3s_deployment.sh" | ssh -i "$HOME\.ssh\id_rsa" "ubuntu@$IP_PUBLICO" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "curl -sfL https://raw.githubusercontent.com/DanielMozartt/iac-aws/refs/heads/main/shell/k3s_deployment.sh | sh -"

Start-Sleep 100

# Abre o Edge direto no IP público da ec2.
Start-Process msedge.exe -ArgumentList "https://$IP_PUBLICO"
