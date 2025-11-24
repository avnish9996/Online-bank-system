<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transfer Money - Secure Banking</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%
      if (session.getAttribute("account")==null) { response.sendRedirect("index.jsp"); return; }
    %>

    <header>
        <h1>🔄 Transfer Money</h1>
        <p>Send money securely to another account</p>
    </header>

    <div class="container">
        <div class="row">
            <div class="col">
                <div class="card">
                    <h2>Enter Transfer Details</h2>
                    <form action="transfer" method="post">
                        <div class="form-group">
                            <label for="toAcc">Recipient Account Number</label>
                            <input type="number" id="toAcc" name="toAcc" required placeholder="Enter account number" class="form-input">
                        </div>

                        <div class="form-group">
                            <label for="amount">Amount to Transfer (₹)</label>
                            <input type="number" id="amount" name="amount" required min="0" step="0.01" placeholder="0.00" class="form-input">
                        </div>

                        <div class="form-group">
                            <label for="pin">Your PIN (for verification)</label>
                            <input type="password" id="pin" name="pin" required placeholder="Enter your PIN" maxlength="4" class="form-input">
                        </div>

                        <button type="submit" class="btn btn-success">Send Money</button>
                    </form>
                </div>
            </div>

            <div class="col">
                <div class="card" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white;">
                    <h3>💡 Transfer Tips</h3>
                    <ul style="padding-left: 1.5rem;">
                        <li>Ensure recipient account number is correct</li>
                        <li>Verify transfer amount before confirming</li>
                        <li>Your PIN is required for security</li>
                        <li>Transfers are instant</li>
                        <li>Fees: None for transfers between accounts</li>
                    </ul>
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
                ⚠️ <strong>Transfer Failed:</strong> <%= error %>
            </div>
        <% } %>
        <% if (message != null && !message.isEmpty()) { %>
            <div class="alert alert-success col-full">
                ✓ <strong>Transfer Successful!</strong> <%= message %>
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
