#Realizar o login no docker na sessão atual.
docker login

#Criar um construtor Multi-Arquitetura para permitir o docker criar imagem compatível em várias plataformas diferentes.
docker buildx create --use --driver docker-container --name construtor_multi_plataforma

#Criar a imagem docker com o Dockerfile atual compatível com linux amd64 e arm64 e envia para o repositório atualizando a tag automaticamente.
docker buildx build --platform linux/amd64, linux/arm64 --push -t mzti/mzhtml:latest .