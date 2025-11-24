package com.example.bank.servlets;

import com.example.bank.dao.AccountDAO;
import com.example.bank.model.Account;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/transfer")
public class TransferServlet extends HttpServlet {
    private AccountDAO dao = new AccountDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect("index.jsp");
            return;
        }
        Account a = (Account) session.getAttribute("account");
        try {
            int toAcc = Integer.parseInt(req.getParameter("toAcc"));
            double amt = Double.parseDouble(req.getParameter("amount"));
            String pin = req.getParameter("pin");
            // verify pin
            if (!org.mindrot.jbcrypt.BCrypt.checkpw(pin, a.getPinHash())) {
                req.setAttribute("error", "Invalid PIN");
                req.getRequestDispatcher("transfer.jsp").forward(req, resp);
                return;
            }
            boolean ok = dao.transfer(a.getAccountNumber(), toAcc, amt);
            if (ok) session.setAttribute("account", dao.findByAccountNumber(a.getAccountNumber()));
            req.setAttribute("message", ok ? "Transfer successful" : "Transfer failed");
            req.getRequestDispatcher("transfer.jsp").forward(req, resp);
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }
}
