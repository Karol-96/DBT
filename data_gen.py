import psycopg2
from datetime import datetime, timedelta
import random

def create_database():
    # Connect to default postgres database first
    conn = psycopg2.connect(
        dbname="postgres",
        user="postgres",
        password="P@ssword7178",  # Replace with your password
        host="localhost"
    )
    conn.autocommit = True
    cur = conn.cursor()
    
    # Create new database
    try:
        cur.execute("CREATE DATABASE customer_data")
    except psycopg2.errors.DuplicateDatabase:
        print("Database already exists")
    
    cur.close()
    conn.close()

def create_tables_and_data():
    # Connect to our new database
    conn = psycopg2.connect(
        dbname="customer_data",
        user="postgres",
        password="your_password",  # Replace with your password
        host="localhost"
    )
    cur = conn.cursor()
    
    # Create raw_data schema
    cur.execute("CREATE SCHEMA IF NOT EXISTS raw_data")
    
    # Create tables
    cur.execute("""
    CREATE TABLE IF NOT EXISTS raw_data.customers (
        customer_id SERIAL PRIMARY KEY,
        full_name TEXT,
        email TEXT UNIQUE,
        signup_date TIMESTAMP
    )""")
    
    cur.execute("""
    CREATE TABLE IF NOT EXISTS raw_data.orders (
        order_id SERIAL PRIMARY KEY,
        customer_id INT REFERENCES raw_data.customers(customer_id),
        total_amount NUMERIC,
        order_date TIMESTAMP
    )""")
    
    cur.execute("""
    CREATE TABLE IF NOT EXISTS raw_data.website_activity (
        activity_id SERIAL PRIMARY KEY,
        customer_id INT REFERENCES raw_data.customers(customer_id),
        activity_type TEXT,
        activity_timestamp TIMESTAMP
    )""")
    
    # Generate sample data
    # Sample customers
    sample_customers = [
        ("John Doe", "john@example.com"),
        ("Jane Smith", "jane@example.com"),
        ("Bob Johnson", "bob@example.com"),
        ("Alice Brown", "alice@example.com"),
        ("Charlie Wilson", "charlie@example.com")
    ]
    
    for name, email in sample_customers:
        signup_date = datetime.now() - timedelta(days=random.randint(1, 365))
        cur.execute("""
        INSERT INTO raw_data.customers (full_name, email, signup_date)
        VALUES (%s, %s, %s)
        """, (name, email, signup_date))
    
    # Sample orders
    for _ in range(20):  # Generate 20 orders
        customer_id = random.randint(1, len(sample_customers))
        total_amount = round(random.uniform(10.0, 500.0), 2)
        order_date = datetime.now() - timedelta(days=random.randint(1, 180))
        cur.execute("""
        INSERT INTO raw_data.orders (customer_id, total_amount, order_date)
        VALUES (%s, %s, %s)
        """, (customer_id, total_amount, order_date))
    
    # Sample website activity
    activity_types = ["page_view", "add_to_cart", "checkout", "login"]
    for _ in range(50):  # Generate 50 activities
        customer_id = random.randint(1, len(sample_customers))
        activity_type = random.choice(activity_types)
        activity_timestamp = datetime.now() - timedelta(days=random.randint(1, 90))
        cur.execute("""
        INSERT INTO raw_data.website_activity (customer_id, activity_type, activity_timestamp)
        VALUES (%s, %s, %s)
        """, (customer_id, activity_type, activity_timestamp))
    
    conn.commit()
    cur.close()
    conn.close()

if __name__ == "__main__":
    create_database()
    create_tables_and_data()
    print("Database, tables created and sample data inserted successfully!")