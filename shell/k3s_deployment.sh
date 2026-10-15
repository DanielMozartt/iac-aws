 #!/bin/bash
    
    # 1. Instalar K3s (servidor + agente)
    curl -sfL https://get.k3s.io | sh -
    
    # Aguarda o K3s iniciar
    sleep 30
    
    # 2. Configurar kubectl para usar o kubeconfig gerado pelo K3s
    export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

    # Adiciona alias kubectl. 
echo 'alias kubectl="sudo k3s kubectl"' >> ~/.bashrc
source ~/.bashrc

kubectl apply -f https://raw.githubusercontent.com/DanielMozartt/iac-aws/main/k3s/deployment.yaml
kubectl apply -f https://raw.githubusercontent.com/DanielMozartt/iac-aws/main/k3s/service.yaml
kubectl apply -f https://raw.githubusercontent.com/DanielMozartt/iac-aws/main/k3s/ingress.yaml