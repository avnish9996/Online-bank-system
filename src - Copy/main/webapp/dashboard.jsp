<%@ page import="com.example.bank.model.Account" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Secure Banking</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%
      Account a = (Account) session.getAttribute("account");
      if (a == null) { response.sendRedirect("index.jsp"); return; }
    %>

    <header>
        <h1>🏦 Dashboard</h1>
        <p>Welcome back, <%= a.getName() %>!</p>
    </header>

    <div class="container">
        <!-- Account Info Box -->
        <div class="card" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; margin-bottom: 2rem;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <p style="font-size: 0.9rem; opacity: 0.9;">Account Number</p>
                    <h3 style="margin: 0; font-size: 1.5rem;"><%= a.getAccountNumber() %></h3>
                </div>
                <div style="text-align: right;">
                    <p style="font-size: 0.9rem; opacity: 0.9;">Available Balance</p>
                    <h2 style="margin: 0; font-size: 2rem;">₹<%= String.format("%.2f", a.getBalance()) %></h2>
                </div>
            </div>
        </div>

        <!-- Action Cards -->
        <div class="row">
            <!-- Deposit -->
            <div class="col">
                <div class="card">
                    <h3>💰 Deposit Money</h3>
                    <form action="account" method="post">
                        <input type="hidden" name="action" value="deposit"/>
                        <div class="form-group">
                            <label for="depositAmt">Amount (₹)</label>
                            <input type="number" id="depositAmt" name="amount" required min="0" step="0.01" placeholder="Enter amount" class="form-input">
                        </div>
                        <button type="submit" class="btn btn-primary">Deposit Now</button>
                    </form>
                </div>
            </div>

            <!-- Withdraw -->
            <div class="col">
                <div class="card">
                    <h3>🏧 Withdraw Money</h3>
                    <form action="account" method="post">
                        <input type="hidden" name="action" value="withdraw"/>
                        <div class="form-group">
                            <label for="withdrawAmt">Amount (₹)</label>
                            <input type="number" id="withdrawAmt" name="amount" required min="0" step="0.01" placeholder="Enter amount" class="form-input">
                        </div>
                        <button type="submit" class="btn btn-success">Withdraw Now</button>
                    </form>
                </div>
            </div>

            <!-- Transfer -->
            <div class="col">
                <div class="card">
                    <h3>🔄 Transfer Money</h3>
                    <p>Send money to another account securely.</p>
                    <a href="transfer.jsp" class="btn btn-primary">Go to Transfer</a>
                </div>
            </div>
        </div>

        <!-- Secondary Actions -->
        <div class="row" style="margin-top: 2rem;">
            <div class="col">
                <div class="card">
                    <h3>👤 Account Profile</h3>
                    <p>View and update your personal information.</p>
                    <a href="profile.jsp" class="btn btn-primary">View Profile</a>
                </div>
            </div>

            <div class="col">
                <div class="card">
                    <h3>📋 Transaction History</h3>
                    <p>View all your deposits, withdrawals, and transfers.</p>
                    <form action="account" method="post" style="margin: 0;">
                        <input type="hidden" name="action" value="statement"/>
                        <button type="submit" class="btn btn-primary">View Statements</button>
                    </form>
                </div>
            </div>

            <div class="col">
                <div class="card">
                    <h3>🚪 Logout</h3>
                    <p>Sign out of your account securely.</p>
                    <a href="logout" class="btn btn-danger">Logout</a>
                </div>
            </div>
        </div>

        <!-- Success/Error Messages -->
        <% 
            String error = (String) request.getAttribute("error");
            String message = (String) request.getAttribute("message");
        %>
        <% if (error != null && !error.isEmpty()) { %>
            <div class="alert alert-danger col-full">
                ⚠️ <strong>Error:</strong> <%= error %>
            </div>
        <% } %>
        <% if (message != null && !message.isEmpty()) { %>
            <div class="alert alert-success col-full">
                ✓ <strong>Success:</strong> <%= message %>
            </div>
        <% } %>
    </div>

    <footer>
        <p>&copy; 2025 Secure Banking System. All rights reserved.</p>
    </footer>
</body>
</html>
