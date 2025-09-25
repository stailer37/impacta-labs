# Use a imagem oficial do MongoDB
FROM mongo:latest

# Define o diretório de trabalho
WORKDIR /data/db

# Exponha a porta padrão do MongoDB
EXPOSE 27017

# Comando para iniciar o MongoDB standalone
CMD ["mongod", "--bind_ip", "0.0.0.0"]