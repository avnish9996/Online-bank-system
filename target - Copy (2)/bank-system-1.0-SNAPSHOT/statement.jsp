<%@ page import="java.util.List" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction Statement - Secure Banking</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%
      if (session.getAttribute("account")==null) { response.sendRedirect("index.jsp"); return; }
      List<String> st = (List<String>) request.getAttribute("statements");
    %>

    <header>
        <h1>📋 Transaction Statement</h1>
        <p>Your account activity history</p>
    </header>

    <div class="container">
        <div class="card">
            <h2>Recent Transactions (Latest First)</h2>
            <% if (st != null && !st.isEmpty()) { %>
                <table>
                    <thead>
                        <tr>
                            <th>Transaction</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (String e: st) { %>
                            <tr>
                                <td>
                                    <% 
                                        if (e.contains("Deposit") || e.contains("Received")) {
                                    %>
                                        <span style="color: var(--success); font-weight: bold;">✓</span>
                                    <% } else if (e.contains("Withdraw") || e.contains("Transfer")) { %>
                                        <span style="color: var(--danger); font-weight: bold;">→</span>
                                    <% } %>
                                    <%= e %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="alert alert-info col-full">
                    ℹ️ No transactions yet. Start by making a deposit or transfer.
                </div>
            <% } %>
        </div>

        <div style="margin-top: 2rem;">
            <a href="dashboard.jsp" class="btn btn-primary">← Back to Dashboard</a>
        </div>
    </div>

    <footer>
        <p>&copy; 2025 Secure Banking System. All rights reserved.</p>
    </footer>
</body>
</html>
