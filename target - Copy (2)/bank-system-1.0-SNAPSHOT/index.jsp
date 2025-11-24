<%@ page %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure Banking - Login & Register</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header>
        <h1>🏦 Secure Banking System</h1>
        <p>Safe, Fast, and Reliable Banking Services</p>
    </header>

    <div class="container">
        <div class="row">
            <div class="col">
                <div class="card">
                    <h2>🔐 Login to Your Account</h2>
                    <form action="auth" method="post">
                        <input type="hidden" name="action" value="login"/>
                        
                        <div class="form-group">
                            <label for="accNo">Account Number</label>
                            <input type="number" id="accNo" name="accNo" required placeholder="Enter your account number">
                        </div>

                        <div class="form-group">
                            <label for="pin">4-Digit PIN</label>
                            <input type="password" id="pin" name="pin" required placeholder="Enter your PIN" maxlength="4">
                        </div>

                        <button type="submit" class="btn btn-primary">Login</button>
                    </form>
                </div>
            </div>

            <div class="col">
                <div class="card">
                    <h2>✨ Create New Account</h2>
                    <form action="auth" method="post">
                        <input type="hidden" name="action" value="register"/>
                        
                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input type="text" id="name" name="name" required placeholder="John Doe">
                        </div>

                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" required placeholder="john@example.com">
                        </div>

                        <div class="form-group">
                            <label for="newpin">4-Digit PIN</label>
                            <input type="password" id="newpin" name="pin" required placeholder="Choose a 4-digit PIN" maxlength="4">
                        </div>

                        <div class="form-group">
                            <label for="initial">Initial Deposit (₹)</label>
                            <input type="number" id="initial" name="initial" value="0" min="0" step="0.01" placeholder="0.00">
                        </div>

                        <button type="submit" class="btn btn-success">Create Account</button>
                    </form>
                </div>
            </div>
        </div>

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
