from database import Base
from sqlalchemy import Column, Integer, String, Date, DECIMAL, ForeignKey, TIMESTAMP, Text, Enum
from sqlalchemy.orm import relationship
from datetime import datetime

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String(50), nullable=False, unique=True)
    email = Column(String(100), nullable=False, unique=True)
    password = Column(Text, nullable=False)
    transactions = relationship("Transaction", back_populates="user")
    
class Category(Base):
    __tablename__ = "categories"

    id = Column(Integer, primary_key=True, index=True)
    cat_name = Column(String(100), nullable=False)
    type = Column(Enum("ex", "in", name="transaction_type"), nullable=False)
    img_url = Column(Text)

    transactions = relationship("Transaction", back_populates="category")


class Transaction(Base):
    __tablename__ = "transactions"

    id = Column(Integer, primary_key=True, index=True)
    amount = Column(DECIMAL(10, 2), nullable=False)
    description = Column(Text, nullable=True)
    date = Column(TIMESTAMP, default=datetime.utcnow, nullable=False)
    category_id = Column(Integer, ForeignKey("categories.id", ondelete="CASCADE"), nullable=False)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)

    category = relationship("Category", back_populates="transactions")
    user = relationship("User", back_populates="transactions")
