-- Create bank database
CREATE DATABASE IF NOT EXISTS bankdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bankdb;

-- Create accounts table
CREATE TABLE IF NOT EXISTS accounts (
  account_number INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  pin_hash VARCHAR(100) NOT NULL,
  balance DOUBLE NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create statements table
CREATE TABLE IF NOT EXISTS statements (
  id INT PRIMARY KEY AUTO_INCREMENT,
  account_number INT NOT NULL,
  entry TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (account_number) REFERENCES accounts(account_number) ON DELETE CASCADE
);
