package com.example.bank.dao;

import com.example.bank.model.Account;
import com.example.bank.util.DBConnection;
import java.sql.*;
import java.util.*;

public class AccountDAO {

    public Account create(String name, String email, String pinHash, double initialDeposit) throws SQLException {
        String sql = "INSERT INTO accounts (name,email,pin_hash,balance) VALUES (?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, pinHash);
            ps.setDouble(4, initialDeposit);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int accNo = rs.getInt(1);
                    addStatement(accNo, "Account created with initial deposit: ₹" + String.format("%.2f", initialDeposit));
                    return findByAccountNumber(accNo);
                }
            }
        }
        return null;
    }

    public Account findByAccountNumber(int accNo) throws SQLException {
        String sql = "SELECT * FROM accounts WHERE account_number = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, accNo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Account a = mapRow(rs);
                    return a;
                }
            }
        }
        return null;
    }

    public Account findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM accounts WHERE email = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public boolean updateBalance(int accNo, double newBalance) throws SQLException {
        String sql = "UPDATE accounts SET balance = ? WHERE account_number = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setDouble(1, newBalance);
            ps.setInt(2, accNo);
            return ps.executeUpdate() == 1;
        }
    }

    public List<String> getStatements(int accNo) throws SQLException {
        String sql = "SELECT entry, created_at FROM statements WHERE account_number = ? ORDER BY created_at DESC";
        List<String> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, accNo);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Timestamp ts = rs.getTimestamp("created_at");
                    String entry = rs.getString("entry");
                    list.add("[" + ts.toString() + "] " + entry);
                }
            }
        }
        return list;
    }

    public void addStatement(int accNo, String text) throws SQLException {
        String sql = "INSERT INTO statements (account_number, entry) VALUES (?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, accNo);
            ps.setString(2, text);
            ps.executeUpdate();
        }
    }

    public boolean deposit(int accNo, double amount) throws SQLException {
        Account a = findByAccountNumber(accNo);
        if (a == null || amount <= 0) return false;
        double nb = a.getBalance() + amount;
        if (updateBalance(accNo, nb)) {
            addStatement(accNo, "Deposited: ₹" + String.format("%.2f", amount) + " | Balance: ₹" + String.format("%.2f", nb));
            return true;
        }
        return false;
    }

    public boolean withdraw(int accNo, double amount) throws SQLException {
        Account a = findByAccountNumber(accNo);
        if (a == null || amount <= 0 || amount > a.getBalance()) return false;
        double nb = a.getBalance() - amount;
        if (updateBalance(accNo, nb)) {
            addStatement(accNo, "Withdrawn: ₹" + String.format("%.2f", amount) + " | Balance: ₹" + String.format("%.2f", nb));
            return true;
        }
        return false;
    }

    public boolean transfer(int fromAcc, int toAcc, double amount) throws SQLException {
        Connection c = null;
        try {
            c = DBConnection.getConnection();
            c.setAutoCommit(false);
            Account aFrom = findByAccountNumber(fromAcc);
            Account aTo = findByAccountNumber(toAcc);
            if (aFrom == null || aTo == null || amount <= 0 || amount > aFrom.getBalance()) {
                return false;
            }
            double nbFrom = aFrom.getBalance() - amount;
            double nbTo = aTo.getBalance() + amount;

            // update balances in same transaction
            try (PreparedStatement ps1 = c.prepareStatement("UPDATE accounts SET balance = ? WHERE account_number = ?");
                 PreparedStatement ps2 = c.prepareStatement("UPDATE accounts SET balance = ? WHERE account_number = ?")) {
                ps1.setDouble(1, nbFrom); ps1.setInt(2, fromAcc); ps1.executeUpdate();
                ps2.setDouble(1, nbTo);   ps2.setInt(2, toAcc);   ps2.executeUpdate();
            }

            // insert statements
            try (PreparedStatement ps3 = c.prepareStatement("INSERT INTO statements (account_number, entry) VALUES (?,?)");
                 PreparedStatement ps4 = c.prepareStatement("INSERT INTO statements (account_number, entry) VALUES (?,?)")) {
                ps3.setInt(1, fromAcc);
                ps3.setString(2, "Transferred ₹" + String.format("%.2f", amount) + " to Account #" + toAcc);
                ps3.executeUpdate();

                ps4.setInt(1, toAcc);
                ps4.setString(2, "Received ₹" + String.format("%.2f", amount) + " from Account #" + fromAcc);
                ps4.executeUpdate();
            }

            c.commit();
            return true;
        } catch (SQLException ex) {
            if (c != null) c.rollback();
            throw ex;
        } finally {
            if (c != null) c.setAutoCommit(true);
            if (c != null) c.close();
        }
    }

    public List<Account> listAll() throws SQLException {
        String sql = "SELECT * FROM accounts";
        List<Account> res = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) res.add(mapRow(rs));
        }
        return res;
    }

    private Account mapRow(ResultSet rs) throws SQLException {
        Account a = new Account();
        a.setAccountNumber(rs.getInt("account_number"));
        a.setName(rs.getString("name"));
        a.setEmail(rs.getString("email"));
        a.setPinHash(rs.getString("pin_hash"));
        a.setBalance(rs.getDouble("balance"));
        a.setCreatedAt(rs.getTimestamp("created_at"));
        return a;
    }
}
