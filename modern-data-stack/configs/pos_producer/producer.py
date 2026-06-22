import json
import os
import random
import time
import uuid
from datetime import datetime, timezone

import psycopg2
from kafka import KafkaProducer

KAFKA_BOOTSTRAP_SERVERS = os.environ.get("KAFKA_BOOTSTRAP_SERVERS", "kafka:9092")
KAFKA_TOPIC = os.environ.get("KAFKA_TOPIC", "pos_transactions")
SALES_DB_DSN = os.environ.get(
    "SALES_DB_DSN", "postgresql://sales_user:sales_pass@sales_db:5432/sales_db"
)
SLEEP_SECONDS = float(os.environ.get("SLEEP_SECONDS", "2"))

STORES = ["STORE-01", "STORE-02", "STORE-03"]
PAYMENT_METHODS = ["credit_card", "debit_card", "cash", "pix"]
DISCOUNTS = [0, 0, 0, 0.05, 0.1, 0.15]


def load_catalog():
    conn = psycopg2.connect(SALES_DB_DSN)
    with conn, conn.cursor() as cur:
        cur.execute("SELECT employee_id FROM employees")
        employee_ids = [row[0] for row in cur.fetchall()]
        cur.execute("SELECT customer_id FROM customers")
        customer_ids = [row[0] for row in cur.fetchall()]
        cur.execute("SELECT product_id, unit_price FROM products WHERE NOT discontinued")
        products = cur.fetchall()
    conn.close()
    return employee_ids, customer_ids, products


def build_cart_events(employee_ids, customer_ids, products):
    transaction_id = str(uuid.uuid4())
    event_timestamp = datetime.now(timezone.utc).isoformat()
    store_id = random.choice(STORES)
    register_id = random.randint(1, 4)
    employee_id = random.choice(employee_ids)
    customer_id = random.choice(customer_ids) if random.random() > 0.2 else None
    payment_method = random.choice(PAYMENT_METHODS)

    cart_size = random.randint(1, min(4, len(products)))
    for product_id, unit_price in random.sample(products, k=cart_size):
        yield {
            "transaction_id": transaction_id,
            "event_timestamp": event_timestamp,
            "store_id": store_id,
            "register_id": register_id,
            "employee_id": employee_id,
            "customer_id": customer_id,
            "product_id": product_id,
            "quantity": random.randint(1, 3),
            "unit_price": float(unit_price),
            "discount": random.choice(DISCOUNTS),
            "payment_method": payment_method,
        }


def main():
    employee_ids, customer_ids, products = load_catalog()
    producer = KafkaProducer(
        bootstrap_servers=[KAFKA_BOOTSTRAP_SERVERS],
        value_serializer=lambda v: json.dumps(v).encode("utf-8"),
    )
    print(f"Emulador de PDV iniciado - publicando no topico '{KAFKA_TOPIC}'", flush=True)
    while True:
        for event in build_cart_events(employee_ids, customer_ids, products):
            producer.send(KAFKA_TOPIC, value=event)
            print(f"Venda registrada: {event}", flush=True)
        producer.flush()
        time.sleep(SLEEP_SECONDS)


if __name__ == "__main__":
    main()
