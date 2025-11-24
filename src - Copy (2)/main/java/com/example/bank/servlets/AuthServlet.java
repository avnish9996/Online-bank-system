package com.example.bank.servlets;

import com.example.bank.dao.AccountDAO;
import com.example.bank.model.Account;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    private AccountDAO dao = new AccountDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("register".equals(action)) {
                String name = req.getParameter("name");
                String email = req.getParameter("email");
                String pin = req.getParameter("pin");
                double initial = Double.parseDouble(req.getParameter("initial"));

                if (!pin.matches("\\d{4}")) {
                    req.setAttribute("error", "PIN must be 4 digits.");
                    req.getRequestDispatcher("index.jsp").forward(req, resp);
                    return;
                }
                String hash = BCrypt.hashpw(pin, BCrypt.gensalt());
                Account created = dao.create(name, email, hash, initial);
                if (created != null) {
                    req.setAttribute("message", "Account created. Your account #: " + created.getAccountNumber());
                    req.getRequestDispatcher("index.jsp").forward(req, resp);
                } else {
                    req.setAttribute("error", "Registration failed.");
                    req.getRequestDispatcher("index.jsp").forward(req, resp);
                }
            } else if ("login".equals(action)) {
                int accNo = Integer.parseInt(req.getParameter("accNo"));
                String pin = req.getParameter("pin");
                Account a = dao.findByAccountNumber(accNo);
                if (a != null && BCrypt.checkpw(pin, a.getPinHash())) {
                    HttpSession session = req.getSession();
                    session.setAttribute("account", a);
                    resp.sendRedirect("dashboard.jsp");
                } else {
                    req.setAttribute("error", "Invalid credentials.");
                    req.getRequestDispatcher("index.jsp").forward(req, resp);
                }
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }
}
