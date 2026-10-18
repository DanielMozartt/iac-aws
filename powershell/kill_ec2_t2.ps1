#Define a codificação de texto para UTF8 para garantir a tradução correta de carácteres de texto especiais.
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

#Define a política de execução de scripts da sessão atual em bypass para o usuário atual.
if ((Get-ExecutionPolicy -List -ErrorAction SilentlyContinue).Scope -in @('Process', 'CurrentUser') -notin "Bypass") {
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
} 

#Direciona para o diretório raiz do projeto.
$dir = git rev-parse --show-toplevel
Set-Location "$dir"

# Deleta a instância ec2_t2.
terraform -chdir=terraform/ec2 destroy -var="ec2_type=t2.micro" -auto-approve