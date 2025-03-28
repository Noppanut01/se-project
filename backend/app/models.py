from database import Base
from sqlalchemy import Column, Integer, String, Date, DECIMAL, ForeignKey, TIMESTAMP, Text
from sqlalchemy.orm import relationship
from datetime import datetime

class User(Base):
    __tablename__ = "User"

    user_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    name = Column(String(255), nullable=False)
    email = Column(String(255), unique=True, nullable=False)
    password = Column(String(255), nullable=False)
    account_type = Column(String(50), nullable=False)

    pockets = relationship("Pocket", back_populates="admin")
    transactions = relationship("Transaction", back_populates="user")
    notifications = relationship("Notification", back_populates="user")


class Pocket(Base):
    __tablename__ = "Pocket"

    pocket_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    pocket_name = Column(String(255), nullable=False)
    admin_id = Column(Integer, ForeignKey("users.user_id"), nullable=False)

    admin = relationship("User", back_populates="pockets")
    members = relationship("PocketMember", back_populates="pocket")
    transactions = relationship("Transaction", back_populates="pocket")


class Notification(Base):
    __tablename__ = "Notification"

    notification_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("users.user_id"), nullable=False)
    message = Column(Text, nullable=False)
    status = Column(String(50), default="unread")
    created_at = Column(TIMESTAMP, default=datetime.utcnow)

    user = relationship("User", back_populates="notifications")


class PocketMember(Base):
    __tablename__ = "PocketMember"

    pocket_id = Column(Integer, ForeignKey("pockets.pocket_id"), primary_key=True)
    user_id = Column(Integer, ForeignKey("users.user_id"), primary_key=True)
    role = Column(String(100), nullable=False)

    pocket = relationship("Pocket", back_populates="members")
    user = relationship("User")


class Category(Base):
    __tablename__ = "Category"

    category_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("users.user_id"), nullable=False)
    pocket_id = Column(Integer, ForeignKey("pockets.pocket_id"), nullable=False)
    category_name = Column(String(255), nullable=False)

    transactions = relationship("Transaction", back_populates="category")


class Budget(Base):
    __tablename__ = "Budget"

    budget_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    pocket_id = Column(Integer, ForeignKey("pockets.pocket_id"), nullable=False)
    category_id = Column(Integer, ForeignKey("categories.category_id"), nullable=False)
    amount_limit = Column(DECIMAL(10,2), nullable=False)
    start_date = Column(Date, nullable=False)
    end_date = Column(Date, nullable=False)


class Transaction(Base):
    __tablename__ = "Transaction"
    transaction_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("users.user_id"), nullable=False)
    pocket_id = Column(Integer, ForeignKey("pockets.pocket_id"), nullable=False)
    category_id = Column(Integer, ForeignKey("categories.category_id"), nullable=False)
    name = Column(String(255), nullable=False)
    amount = Column(DECIMAL(10,2), nullable=False)
    type = Column(String(50), nullable=False)
    note = Column(Text)
    date_time = Column(TIMESTAMP, default=datetime.utcnow)
    user = relationship("User", back_populates="transactions")
    pocket = relationship("Pocket", back_populates="transactions")
    category = relationship("Category", back_populates="transactions")