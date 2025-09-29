# Use a imagem oficial do Apache Cassandra
FROM cassandra:latest

# Exponha a porta padrão do Cassandra
EXPOSE 9042

# Copie o arquivo de exemplo para o container
COPY ./resources/files/available_rooms.csv /available_rooms.csv

# Comando de entrada padrão do Cassandra
CMD ["cassandra", "-f"]