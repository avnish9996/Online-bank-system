# Bank System — local run instructions

This is a small Jakarta EE (Servlet/JSP) banking webapp. I scaffolded a minimal Maven layout so you can run it locally using the Jetty plugin.

Prerequisites
- JDK 17+ installed (you have Java 24 — that's fine).
- Maven (https://maven.apache.org/) installed and available as `mvn` in PATH.
- A local MySQL server and a database created from `pro.sql`.

Quick run (PowerShell)
1. Edit `DBConnection.java` to set your MySQL password (the file currently has `your_password_here`).
2. From the project root run:

```powershell
mvn -DskipTests jetty:run
```

3. Open http://localhost:8080 in your browser.

If you prefer Tomcat, you can build a WAR with `mvn package` and drop the generated `target/bank-system-1.0-SNAPSHOT.war` into Tomcat's `webapps`.

Notes
- The project uses BCrypt for PIN hashing (`org.mindrot.jbcrypt`). Ensure the dependency is present in your Maven local repo (Maven will download it).
- DB schema is in `pro.sql`. The app expects a MySQL database named `bankdb` by default.
