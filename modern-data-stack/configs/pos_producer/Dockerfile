FROM python:3.12-slim

RUN pip install --no-cache-dir kafka-python psycopg2-binary

WORKDIR /app
COPY producer.py .

CMD ["python", "producer.py"]
