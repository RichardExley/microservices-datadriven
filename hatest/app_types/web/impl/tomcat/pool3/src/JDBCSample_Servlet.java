import java.io.IOException;
import java.io.PrintWriter;

import java.sql.Timestamp;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import oracle.ucp.jdbc.PoolDataSource;
import oracle.ucp.jdbc.PoolDataSourceFactory;

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

  static PoolDataSource pds;

  /**
    * @see HttpServlet#HttpServlet()
    */
  public JDBCSample_Servlet() {
    super();
  }

  public void init() {
    Timestamp timestamp = new Timestamp(System.currentTimeMillis());
    System.out.println("init start: " + timestamp);
  
    // Load JDBC driver
    try {
      pds = PoolDataSourceFactory.getPoolDataSource();
      pds.setConnectionFactoryClassName("oracle.jdbc.pool.OracleDataSource");
      pds.setURL(dbURL);
      pds.setUser(dbUser);
      pds.setPassword(dbPassword);
      pds.setInitialPoolSize(4);
      pds.setMinPoolSize(4);
      pds.setMaxPoolSize(4);
      pds.setConnectionWaitTimeout(0);
      timestamp = new Timestamp(System.currentTimeMillis());
      System.out.println("init before connections: " + timestamp);
    //int totalConnsCount = pds.getStatistics().getTotalConnectionsCount();
      System.out.println("Stats before priming are: " + pds.getStatistics());
      Connection conn1 = pds.getConnection();
      timestamp = new Timestamp(System.currentTimeMillis());
      System.out.println("init after conn1: " + timestamp);
      System.out.println("Stats after priming conn1 are: " + pds.getStatistics());
      Connection conn2 = pds.getConnection();
      Connection conn3 = pds.getConnection();
      Connection conn4 = pds.getConnection();
      timestamp = new Timestamp(System.currentTimeMillis());
      System.out.println("init after conn4: " + timestamp);
      PreparedStatement stmt = conn1.prepareStatement(get_id_sql); 
      stmt.setString(1, "1");
      ResultSet rs = stmt.executeQuery(); 
      rs.next();
      conn1.close();
      conn2.close();
      conn3.close();
      conn4.close();
      //totalConnsCount = pds.getStatistics().getTotalConnectionsCount();
      System.out.println("Stats after priming are: " + pds.getStatistics());
    } catch (SQLException e) {
      e.printStackTrace();
    }
  }
  
  /**
   * Method to get a connection to the Oracle Database and perform few 
   * database operations and display the results on a web page. 
   */
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
    Timestamp timestamp = new Timestamp(System.currentTimeMillis());
    System.out.println("goGet start: " + timestamp);
  
    PrintWriter out = response.getWriter();

    // Get the id requested
    String id = request.getPathInfo().split("/")[1];

    try (Connection conn = pds.getConnection()) {
      timestamp = new Timestamp(System.currentTimeMillis());
      System.out.println("goGet after getConnection: " + timestamp);
      PreparedStatement stmt = conn.prepareStatement(get_id_sql); 
      stmt.setString(1, id);
      ResultSet rs = stmt.executeQuery(); 
      if (rs.next()) {
        response.setStatus(200);
        out.println(rs.getString(1));
        timestamp = new Timestamp(System.currentTimeMillis());
        System.out.println("goGet after 200 output: " + timestamp);
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