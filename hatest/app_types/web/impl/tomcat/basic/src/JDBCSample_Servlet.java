import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;
import javax.sql.DataSource;
import java.sql.DatabaseMetaData;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.sql.DriverManager;

/**
 * Servlet implementation class JDBCSample_Servlet
 */
@WebServlet("/*")
public class JDBCSample_Servlet extends HttpServlet {
  private static final long serialVersionUID = 1L;     

  static String get_id_sql = "select username from demo where id = ?"; 

  static String dbPassword = System.getenv("HATEST_DB_MAIN_PASSWORD");
  static String dbUser     = System.getenv("HATEST_DB_MAIN_USER");
  static String dbURL      = System.getenv("HATEST_JDBC_URL");

  /**
    * @see HttpServlet#HttpServlet()
    */
  public JDBCSample_Servlet() {
    super();
  }

  public void init() {
    // Load JDBC driver
    try {
      DriverManager.registerDriver (new oracle.jdbc.OracleDriver());
    } catch (SQLException e) {
      e.printStackTrace();
    }
    /*try {
      Class.forName("oracle.jdbc.OracleDriver");
    } catch (ClassNotFoundException e) {
      e.printStackTrace();
    }
    */
  }
  
  /**
   * Method to get a connection to the Oracle Database and perform few 
   * database operations and display the results on a web page. 
   */
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
    String id = request.getPathInfo().split("/")[1];
    PrintWriter out = response.getWriter();

    try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
      PreparedStatement stmt = conn.prepareStatement(get_id_sql); 
      stmt.setString(1, id);
      ResultSet rs = stmt.executeQuery(); 
      if (rs.next()) {
        response.setStatus(200);
        out.println(rs.getString(1));
      } else {
        response.setStatus(201);
      }
    } catch (Exception e) {
      response.setStatus(500);
      response.setHeader("Exception", e.toString());
      e.printStackTrace();
    }
  }

  public void destroy() { }
}