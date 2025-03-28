from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from database import get_db
from pydantic import BaseModel
from models import Transaction  # Import the updated SQLAlchemy model

app = FastAPI()

# Pydantic Model for Input
class TransactionCreate(BaseModel):
    name: str
    amount: float
    type: str
    user_id: int
    pocket_id: int
    category_id: int
    note: str | None = None

# Insert Data into PostgreSQL
@app.post("/add_transaction/")
def add_transaction(data: TransactionCreate, db: Session = Depends(get_db)):
    new_transaction = Transaction(
        name=data.name,
        amount=data.amount,
        type=data.type,
        user_id=data.user_id,
        pocket_id=data.pocket_id,
        category_id=data.category_id,
        note=data.note
    )
    db.add(new_transaction)
    db.commit()
    db.refresh(new_transaction)
    return new_transaction

# Fetch All Transactions from PostgreSQL
@app.get("/get_transactions/")
def get_transactions(db: Session = Depends(get_db)):
    return db.query(Transaction).all()