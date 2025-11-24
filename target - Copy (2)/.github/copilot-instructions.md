## Quick context

This is a small Jakarta EE (Servlet/JSP) banking web app. Key pieces:
- Servlets: `AuthServlet` (`/auth`), `AccountServlet` (`/account`), `TransferServlet` (`/transfer`) — see `*.java` in project root.
- Data access: `AccountDAO.java` contains all DB operations (deposit/withdraw/transfer and statements).
- DB connection: `DBConnection.java` holds the JDBC URL and credentials; schema in `pro.sql`.
- Views: simple JSP pages (`index.jsp`, `dashboard.jsp`, `profile.jsp`, `transfer.jsp`, `statement.jsp`).

## Big picture architecture (what to know first)
- Single-process webapp using Jakarta Servlets and JSPs. No service bus or microservices — all logic lives in the WAR.
- `AccountDAO.transfer(...)` uses explicit JDBC transactions (turns off autoCommit, updates balances, inserts statements, commits/rollbacks). Be careful when modifying it — keep transactional boundaries intact.
- Authentication is session-based: on successful login `AuthServlet` stores `account` in the HttpSession and JSPs expect it (see `dashboard.jsp` and `profile.jsp`).

## Project-specific conventions & patterns
- PIN rules: PIN is enforced as 4 digits in servlets (`pin.matches("\\d{4}")`). Keep that when adding registration or PIN flows.
- Passwords are stored as BCrypt hashes (`org.mindrot.jbcrypt.BCrypt`). Any new code verifying/saving PINs should use that same library.
- DAO pattern: `AccountDAO` returns model `Account` and also contains helper methods like `addStatement(...)`. Prefer extending `AccountDAO` rather than duplicating DB logic.
- Inline SQL is used across DAO and some servlets (e.g., `daoUpdateProfile` inside `AccountServlet`). Search for SQL edits when changing DB columns.

## Integration points / external dependencies
- Relational DB: MySQL — schema file is `pro.sql`. JDBC URL and credentials are in `DBConnection.java`:
  - URL: `jdbc:mysql://localhost:3306/bankdb?useSSL=false&serverTimezone=UTC`
  - USER/PASS: `root` / `your_password_here` (replace before running)
- Libraries required (not checked into repo):
  - MySQL JDBC driver (mysql-connector-java)
  - BCrypt (jbcrypt: `org.mindrot.jbcrypt`)
  Add these JARs to `WEB-INF/lib` or configure them in your IDE/Maven if you migrate to a build system.

## How to run / developer workflows (practical)
Two recommended quick workflows — IDE (fast) and manual Tomcat deploy.

1) IDE (recommended)
   - Import the folder as a Java Web / Dynamic Web Project in Eclipse or as a Java EE/Tomcat run configuration in IntelliJ.
   - Add the MySQL connector and jBCrypt jars to the project classpath (or to `WEB-INF/lib`).
   - Create the database from `pro.sql` and update password in `DBConnection.java`.
   - Run on an Apache Tomcat server from the IDE.

2) Manual Tomcat deploy
   - Compile sources to `WEB-INF/classes` and place required JARs into `WEB-INF/lib`.
   - Create WAR and drop into Tomcat `webapps` directory.
   - Ensure `bankdb` exists and `DBConnection.java` credentials are set.

Notes: There is no `pom.xml` or Gradle file in the repo. If you prefer reproducible builds, convert project to Maven/Gradle and add dependencies for `mysql-connector-java` and `jbcrypt`.

## Common edits and examples (concrete)
- If you add a new servlet, you may annotate it with `@WebServlet("/path")` (project relies on annotations). `web.xml` is minimal and only defines the welcome page.
- To change DB schema: update `pro.sql`, then adjust `AccountDAO.mapRow(...)` and SQL queries that select or set columns (search for literal column names like `balance`, `pin_hash`, `account_number`).
- When modifying transfers, preserve the transaction semantics in `AccountDAO.transfer(...)` — it must update both balances and both statements in the same DB transaction.

## Safety & credentials
- DB password in `DBConnection.java` is a placeholder — do not commit real credentials. Prefer setting via environment or moving to a properties file before sharing.

## Where to look first when troubleshooting
- `DBConnection.java` — DB connectivity issues.
- `AccountDAO` — balance calculation, statement insertion, transactions.
- `AuthServlet` and `AccountServlet` — registration/login flows and session handling.
- `pro.sql` — DB schema mismatch errors.

If anything here is unclear or you want me to include precise build commands for your preferred tool (Maven/Gradle) or target Tomcat version, tell me which you use and I will update this file.