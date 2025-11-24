package com.example.bank.servlets;

import com.example.bank.dao.AccountDAO;
import com.example.bank.model.Account;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/account")
public class AccountServlet extends HttpServlet {
    private AccountDAO dao = new AccountDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect("index.jsp");
            return;
        }
        Account a = (Account) session.getAttribute("account");
        String action = req.getParameter("action");
        try {
            if ("deposit".equals(action)) {
                double amt = Double.parseDouble(req.getParameter("amount"));
                if (dao.deposit(a.getAccountNumber(), amt)) {
                    // refresh session account
                    session.setAttribute("account", dao.findByAccountNumber(a.getAccountNumber()));
                } else {
                    req.setAttribute("error", "Deposit failed");
                }
                resp.sendRedirect("dashboard.jsp");
            } else if ("withdraw".equals(action)) {
                double amt = Double.parseDouble(req.getParameter("amount"));
                if (dao.withdraw(a.getAccountNumber(), amt)) {
                    session.setAttribute("account", dao.findByAccountNumber(a.getAccountNumber()));
                } else {
                    req.setAttribute("error", "Withdraw failed or insufficient funds");
                }
                resp.sendRedirect("dashboard.jsp");
            } else if ("updateProfile".equals(action)) {
                String name = req.getParameter("name");
                String email = req.getParameter("email");
                String newPin = req.getParameter("pin");
                Account existing = dao.findByAccountNumber(a.getAccountNumber());
                boolean updated = false;
                if (name != null && !name.trim().isEmpty()) existing.setName(name.trim());
                if (email != null && !email.trim().isEmpty()) existing.setEmail(email.trim());
                if (newPin != null && !newPin.trim().isEmpty()) {
                    if (!newPin.matches("\\d{4}")) {
                        req.setAttribute("error", "PIN must be 4 digits.");
                        req.getRequestDispatcher("profile.jsp").forward(req, resp);
                        return;
                    }
                    existing.setPinHash(BCrypt.hashpw(newPin, BCrypt.gensalt()));
                }
                // persist updates: simplistic approach: update by reusing DAO update methods (not implemented separate)
                // We'll update email/name/pin with a simple SQL here for brevity:
                daoUpdateProfile(existing);
                session.setAttribute("account", dao.findByAccountNumber(existing.getAccountNumber()));
                resp.sendRedirect("profile.jsp");
            } else if ("statement".equals(action)) {
                List<String> statements = dao.getStatements(a.getAccountNumber());
                req.setAttribute("statements", statements);
                req.getRequestDispatcher("statement.jsp").forward(req, resp);
            } else {
                resp.sendRedirect("dashboard.jsp");
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    // inline helper to update profile (name, email, pin)
    private void daoUpdateProfile(Account a) throws Exception {
        String sql = "UPDATE accounts SET name = ?, email = ?, pin_hash = ? WHERE account_number = ?";
        try (java.sql.Connection c = com.example.bank.util.DBConnection.getConnection();
             java.sql.PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, a.getName());
            ps.setString(2, a.getEmail());
            ps.setString(3, a.getPinHash());
            ps.setInt(4, a.getAccountNumber());
            ps.executeUpdate();
            // add statement
            com.example.bank.dao.AccountDAO adi = new com.example.bank.dao.AccountDAO();
            adi.addStatement(a.getAccountNumber(), "Profile updated");
        }
    }
}
