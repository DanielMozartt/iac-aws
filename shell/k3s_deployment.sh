 #!/bin/bash

#Criar um arquivo de SWAP de 2GB
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

#Ajustar a tendência do Linux de usar o SWAP apenas quando necessário
sudo sysctl vm.swappiness=10
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf

    
#Instalar K3s (servidor + agente)
curl -sfL https://get.k3s.io | sh -
    
#Aguarda o K3s iniciar
sleep 60

#Configurar kubectl para usar o kubeconfig gerado pelo K3s
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

#Adiciona alias kubectl para sudo k3s kubectl. 
echo 'alias kubectl="sudo k3s kubectl"' >> ~/.bashrc
source ~/.bashrc

#Aplicar deployment, service e ingress no k3s.
sudo k3s kubectl apply -f https://raw.githubusercontent.com/DanielMozartt/iac-aws/main/k3s/deployment.yaml
sudo k3s kubectl apply -f https://raw.githubusercontent.com/DanielMozartt/iac-aws/main/k3s/service.yaml
sudo k3s kubectl apply -f https://raw.githubusercontent.com/DanielMozartt/iac-aws/main/k3s/ingress.yaml
sudo k3s kubectl apply -f https://raw.githubusercontent.com/DanielMozartt/iac-aws/main/k3s/redirect.yaml

#Deleta o pod com nome iniciado em mzhtml forçando reiniciar.
POD=$(sudo k3s kubectl get pods -n "$NAME" --no-headers -o custom-columns=":metadata.name" | grep "^$PREFIXO_MZHTML" | head -n 1)
sudo k3s kubectl delete pod "$POD" -n "$NAME"
