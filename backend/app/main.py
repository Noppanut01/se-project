from fastapi import FastAPI
from pydantic import BaseModel
from datetime import datetime, date
from app import database
from psycopg2.extras import RealDictCursor

app = FastAPI()

# DATABASE_URL = "dbname=postgres user=postgres password=postgres host=localhost port=5432"

# def get_db_connection():
#     return psycopg2.connect(DATABASE_URL, cursor_factory=RealDictCursor)

class Transaction(BaseModel):
    description: str
    amount: float

@app.get("/transactions")
def get_transactions():
    conn = database.get_db_connection()
    cursor = conn.cursor()

    today = date.today()
    first_day_of_month = today.replace(day=1)

    cursor.execute("SELECT * FROM transactions WHERE date = %s", (today,))
    transactions_today = cursor.fetchall()

    cursor.execute("SELECT * FROM transactions WHERE date >= %s", (first_day_of_month,))
    transactions_this_month = cursor.fetchall()

    conn.close()
    return {"today": transactions_today, "this_month": transactions_this_month}

@app.post("/add_transaction")
def add_transaction(transaction: Transaction):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute(
        "INSERT INTO transactions (description, amount, date, time) VALUES (%s, %s, %s, %s)",
        (transaction.description, transaction.amount, date.today(), datetime.now().time()),
    )

    conn.commit()
    conn.close()
    return {"message": "Transaction added successfully"}