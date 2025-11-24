package com.example.bank.model;

import java.util.Date;

public class Account {
    private int accountNumber;
    private String name;
    private String email;
    private String pinHash;
    private double balance;
    private Date createdAt;

    public Account() {}

    public Account(int accountNumber, String name, String email, String pinHash, double balance) {
        this.accountNumber = accountNumber;
        this.name = name;
        this.email = email;
        this.pinHash = pinHash;
        this.balance = balance;
    }

    // getters & setters
    public int getAccountNumber() { return accountNumber; }
    public void setAccountNumber(int accountNumber) { this.accountNumber = accountNumber; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPinHash() { return pinHash; }
    public void setPinHash(String pinHash) { this.pinHash = pinHash; }
    public double getBalance() { return balance; }
    public void setBalance(double balance) { this.balance = balance; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
