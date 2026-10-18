#Define a codificação de texto para UTF8 para garantir a tradução correta de carácteres de texto especiais.
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

#Define a política de execução de scripts da sessão atual em bypass para o usuário atual.
if ((Get-ExecutionPolicy -List -ErrorAction SilentlyContinue).Scope -in @('Process', 'CurrentUser') -notin "Bypass") {
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
} 

#Direciona para o diretório raiz do projeto.
$dir = git rev-parse --show-toplevel
Set-Location "$dir"

# Cria a chave SSH id_rsa.pub se não existir.
if (-not(Get-ChildItem $HOME\.ssh\id_rsa.pub -ErrorAction SilentlyContinue)) {
    ssh-keygen -t rsa -b 4096 -f $HOME\.ssh\id_rsa -N ""
}

# Inicializa e aplica o Terraform
terraform -chdir=terraform/ec2 init -upgrade
terraform -chdir=terraform/ec2 plan -var="ec2_type=t4g.micro"
terraform -chdir=terraform/ec2 apply -var="ec2_type=t4g.micro" -auto-approve

# Exporta o output em JSON
terraform -chdir=terraform/ec2 output -json | Out-File -FilePath terraform/ec2/ip_publico.json -Encoding utf8

Start-Sleep 10

# Armazena o IP público em uma variável PowerShell
$IP_PUBLICO = terraform -chdir=terraform/ec2 output -raw public_ip

Start-Sleep 100

# Abre o Edge direto no IP público da ec2.
Start-Process msedge.exe -ArgumentList "https://$IP_PUBLICO"
