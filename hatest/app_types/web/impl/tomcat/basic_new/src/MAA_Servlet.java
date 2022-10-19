package com.oracle.maa.tomcat;

import java.io.IOException;
import java.io.PrintWriter;

import java.util.logging.*;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.DriverManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// MAA Tip: Load on Startup
@WebServlet(name="MAA_Servlet", urlPatterns="/*", loadOnStartup=1)
public class MAA_Servlet extends HttpServlet {
  private static final long serialVersionUID = 1L;     
  private static Logger logger = Logger.getLogger("com.oracle.maa.tomcat.maa_servlet");

  static String get_id_sql = "select username from demo where id = ?"; 

  static String dbPassword = System.getenv("HATEST_DB_MAIN_PASSWORD");
  static String dbUser     = System.getenv("HATEST_DB_MAIN_USER");
  static String dbURL      = System.getenv("HATEST_JDBC_URL");

  public MAA_Servlet() {
    super();
  }

  public void init() {
    logger.setLevel(Level.ALL);
    logger.info("Servlet starting");

    // Load JDBC driver
    try {
      DriverManager.registerDriver (new oracle.jdbc.OracleDriver());
    } catch (SQLException e) {
      logger.log(Level.SEVERE, "Exception loading the JDBC driver", e);
    }
  }
  
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
    String id = "";
    String probe = "";

    try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
      id = request.getPathInfo().split("/")[1];
      probe = request.getParameter("probe");
      logger.info("id: " + id + " probe: " + probe);

      PreparedStatement stmt = conn.prepareStatement(get_id_sql); 
      stmt.setString(1, id);
      ResultSet rs = stmt.executeQuery(); 
      if (rs.next()) {
        response.setStatus(200);
        response.getWriter().println(rs.getString(1));
      } else {
        response.setStatus(201);
      }
    } catch (Exception e) {
      response.setStatus(500);
      response.setHeader("Exception", e.toString());
      logger.log(Level.SEVERE, "Exception processing probe# " + probe, e);
    }
  }

  public void destroy() { }
}