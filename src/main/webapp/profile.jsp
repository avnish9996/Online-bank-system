<%@ page import="com.example.bank.model.Account" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - Secure Banking</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%
      Account a = (Account) session.getAttribute("account");
      if (a == null) { response.sendRedirect("index.jsp"); return; }
    %>

    <header>
        <h1>👤 My Profile</h1>
        <p>Update your account information</p>
    </header>

    <div class="container">
        <div class="row">
            <div class="col">
                <div class="card">
                    <h2>Account Information</h2>
                    <form action="account" method="post">
                        <input type="hidden" name="action" value="updateProfile"/>
                        
                        <div class="form-group">
                            <label for="accNumber">Account Number</label>
                            <input type="text" id="accNumber" value="<%= a.getAccountNumber() %>" disabled class="form-input">
                            <small style="color: #888;">Account number cannot be changed</small>
                        </div>

                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input type="text" id="name" name="name" value="<%= a.getName() %>" required class="form-input">
                        </div>

                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" value="<%= a.getEmail() %>" required class="form-input">
                        </div>

                        <div class="form-group">
                            <label for="pin">New PIN (4 digits to change)</label>
                            <input type="password" id="pin" name="pin" placeholder="Leave blank to keep current PIN" maxlength="4" class="form-input">
                            <small style="color: #888;">Enter only if you want to change your PIN</small>
                        </div>

                        <button type="submit" class="btn btn-primary">Update Profile</button>
                    </form>
                </div>
            </div>

            <div class="col">
                <div class="card" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;">
                    <h3>📌 Account Details</h3>
                    <div style="margin-top: 1.5rem;">
                        <p><strong>Account Type:</strong> Savings</p>
                        <p><strong>Status:</strong> Active ✓</p>
                        <p><strong>Current Balance:</strong><br><span style="font-size: 1.8rem;">₹<%= String.format("%.2f", a.getBalance()) %></span></p>
                        <p style="font-size: 0.85rem; opacity: 0.8;">Member since <%= a.getCreatedAt() %></p>
                    </div>
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

        <div style="margin-top: 2rem;">
            <a href="dashboard.jsp" class="btn btn-primary">← Back to Dashboard</a>
        </div>
    </div>

    <footer>
        <p>&copy; 2025 Secure Banking System. All rights reserved.</p>
    </footer>
</body>
</html>
