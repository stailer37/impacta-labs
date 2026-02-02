# Dockerfile para o Encurtador de URLs com Redis
FROM python:3.11-slim

# Metadados
LABEL maintainer="Manus AI"
LABEL description="URL Shortener with Redis - Laboratory"
LABEL version="1.0.0"

# Definir diretório de trabalho
WORKDIR /app

# Instalar dependências do sistema
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copiar arquivos de requisitos primeiro (para cache do Docker)
COPY requirements.txt .

# Instalar dependências Python
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código da aplicação
COPY ./scripts/utils.py .
COPY ./scripts/redis_demo.py .
COPY ./scripts/api.py .

# Criar usuário não-root para segurança
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app

# Mudar para usuário não-root
USER appuser

# Expor porta da API
EXPOSE 5000

# Variáveis de ambiente
ENV PYTHONUNBUFFERED=1
ENV BASE_URL=http://localhost:5000
ENV REDIS_HOST=redis
ENV REDIS_PORT=6379

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5000/ || exit 1

# Comando padrão: iniciar API
CMD ["python", "api.py"]
