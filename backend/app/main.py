from fastapi import FastAPI, HTTPException, Depends
from sqlalchemy.orm import Session
from models import Transaction, User, Category
from database import get_db
from pydantic import BaseModel,EmailStr
from sqlalchemy.exc import IntegrityError
from passlib.context import CryptContext

app = FastAPI()
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

class UserAuth(BaseModel):
    email: str
    password: str

class UserUpdate(BaseModel):
    username: str | None = None
    email: EmailStr | None = None
    password: str | None = None

class CategoryResponse(BaseModel):
    id: int
    cat_name: str
    type: str
    img_url: str | None


class UserCreate(BaseModel):
    username: str
    email: EmailStr
    password: str

class TransactionCreate(BaseModel):
    amount: float
    description: str | None = None
    user_id: int
    category_id: int

    class Config:
        from_attributes = True
        
def hash_password(password: str) -> str:
    return pwd_context.hash(password)

@app.get("/get_user/{user_id}")
def get_user(user_id: int, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.id == user_id).first()
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")
    return {"username": db_user.username,"email": db_user.email}

@app.post("/sign_up/")
def sign_up(user: UserCreate, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.email == user.email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")

    hashed_password = hash_password(user.password)

    new_user = User(username=user.username, email=user.email, password=hashed_password)

    try:
        db.add(new_user)
        db.commit()
        db.refresh(new_user)
    except IntegrityError:
        db.rollback()
        raise HTTPException(status_code=500, detail="Error saving user to database")

    return {"message": "User created successfully", "user_id": new_user.id}

@app.put("/update_user/{user_id}")
def update_user(user_id: int, user: UserUpdate, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.id == user_id).first()
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")

    # Update the fields if provided in the request
    if user.username:
        db_user.username = user.username
    if user.email:
        db_user.email = user.email
    if user.password:
        db_user.password = hash_password(user.password)

    try:
        db.commit()
        db.refresh(db_user)
    except IntegrityError:
        db.rollback()
        raise HTTPException(status_code=400, detail="Error updating user")

    return {"message": "User updated successfully", "user_id": db_user.id}

@app.delete("/delete_user/{user_id}")
def delete_user(user_id: int, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.id == user_id).first()
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")

    # Delete all transactions associated with the user
    transactions = db.query(Transaction).filter(Transaction.user_id == user_id).all()
    if transactions:
        for transaction in transactions:
            db.delete(transaction)

    # Now delete the user
    db.delete(db_user)
    db.commit()

    return {"message": "User and associated transactions deleted successfully"}

@app.post("/auth/")
def authenticate_user(user: UserAuth, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.email == user.email).first()
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")

    if not pwd_context.verify(user.password, db_user.password):
        raise HTTPException(status_code=401, detail="Invalid credentials")

    return {"message": "Authenticated successfully"}


@app.post("/add_transaction/", response_model=TransactionCreate)
def add_transaction(data: TransactionCreate, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == data.user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    category = db.query(Category).filter(Category.id == data.category_id).first()
    if not category:
        raise HTTPException(status_code=404, detail="Category not found")

    new_transaction = Transaction(
        amount=data.amount,
        description=data.description,
        user_id=data.user_id,
        category_id=data.category_id,
    )

    # Debugging output
    print(f"Adding transaction: {new_transaction}")

    try:
        db.add(new_transaction)
        db.commit()
        db.refresh(new_transaction)

        # Debugging output
        print(f"Transaction added successfully: {new_transaction.id}")

    except Exception as e:
        db.rollback()
        print(f"Error: {e}")
        raise HTTPException(status_code=500, detail="Error adding transaction")

    return TransactionCreate(
        amount=new_transaction.amount,
        description=new_transaction.description,
        user_id=new_transaction.user_id,
        category_id=new_transaction.category_id,
    )


@app.get("/get_transactions/")
def get_transactions(db: Session = Depends(get_db)):
    return db.query(Transaction).all()


@app.get("/get_transactions/{user_id}")
def get_transactions_by_user(user_id: int, db: Session = Depends(get_db)):
    transactions = db.query(Transaction).filter(Transaction.user_id == user_id).all()
    if not transactions:
        raise HTTPException(
            status_code=404, detail="No transactions found for this user"
        )
    return transactions


@app.get("/get_categories/", response_model=list[CategoryResponse])
def get_categories(db: Session = Depends(get_db)):
    categories = db.query(Category).all()
    return categories


@app.put("/update_transaction/{transaction_id}")
def update_transaction(
    transaction_id: int, data: TransactionCreate, db: Session = Depends(get_db)
):
    transaction = db.query(Transaction).filter(Transaction.id == transaction_id).first()
    if transaction is None:
        raise HTTPException(status_code=404, detail="Transaction not found")

    transaction.amount = data.amount
    transaction.description = data.description
    transaction.user_id = data.user_id
    transaction.category_id = data.category_id

    db.commit()
    db.refresh(transaction)
    return transaction


@app.delete("/delete_transaction/{transaction_id}")
def delete_transaction(transaction_id: int, db: Session = Depends(get_db)):
    transaction = db.query(Transaction).filter(Transaction.id == transaction_id).first()
    if transaction is None:
        raise HTTPException(status_code=404, detail="Transaction not found")

    db.delete(transaction)
    db.commit()
    return {"message": "Transaction deleted successfully"}
