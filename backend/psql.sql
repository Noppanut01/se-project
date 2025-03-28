-- User Table
CREATE TABLE "User" (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    account_type VARCHAR(50) NOT NULL
);
-- Pocket Table
CREATE TABLE "Pocket" (
    pocket_id SERIAL PRIMARY KEY,
    admin_id INT NOT NULL,
    pocket_name VARCHAR(255) NOT NULL,
    FOREIGN KEY (admin_id) REFERENCES "User"(user_id) ON DELETE CASCADE
);
-- Notification Table
CREATE TABLE "Notification" (
    notification_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    message TEXT NOT NULL,
    status VARCHAR(50) DEFAULT 'unread',
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES "User"(user_id) ON DELETE CASCADE
);
-- Pocket_Member Table
CREATE TABLE "Pocket_Member" (
    pocket_id INT NOT NULL,
    user_id INT NOT NULL,
    role VARCHAR(100) NOT NULL,
    PRIMARY KEY (pocket_id, user_id),
    FOREIGN KEY (pocket_id) REFERENCES "Pocket"(pocket_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES "User"(user_id) ON DELETE CASCADE
);
-- Category Table
CREATE TABLE "Category" (
    category_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    pocket_id INT NOT NULL,
    category_name VARCHAR(255) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES "User"(user_id) ON DELETE CASCADE,
    FOREIGN KEY (pocket_id) REFERENCES "Pocket"(pocket_id) ON DELETE CASCADE
);
-- Budget Table
CREATE TABLE "Budget" (
    budget_id SERIAL PRIMARY KEY,
    pocket_id INT NOT NULL,
    category_id INT NOT NULL,
    amount_limit FLOAT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    FOREIGN KEY (pocket_id) REFERENCES "Pocket"(pocket_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES "Category"(category_id) ON DELETE CASCADE
);
-- Transaction Table
CREATE TABLE "Transaction" (
    transaction_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    pocket_id INT NOT NULL,
    amount FLOAT NOT NULL,
    type VARCHAR(50) NOT NULL,
    category_id INT NOT NULL,
    note TEXT,
    date_time TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES "User"(user_id) ON DELETE CASCADE,
    FOREIGN KEY (pocket_id) REFERENCES "Pocket"(pocket_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES "Category"(category_id) ON DELETE CASCADE
);