#Escolhe o Nginx como servidor web.
FROM nginx:alpine

#Remove os arquivos padrão do Nginx
RUN rm -rf /usr/share/nginx/html/*

#Copia todo o conteúdo do projeto que está na subpasta html para a pasta do Nginx.
COPY html/ /usr/share/nginx/html/

#Expôe a porta 80.
EXPOSE 80

#Executa o comando padrão do Nginx ao iniciar.
CMD ["nginx", "-g", "daemon off;"]
