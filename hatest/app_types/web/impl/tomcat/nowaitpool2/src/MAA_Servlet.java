/*
 ** Copyright (c) 2023 Oracle and/or its affiliates.
 ** Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/
 */

package com.oracle.maa.tomcat;

import java.io.IOException;

import java.util.logging.*;

import java.lang.Thread;

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

// MAA Tip: Load the servlet on Startup
@WebServlet(name="MAA_Servlet", urlPatterns="/*", loadOnStartup=1)
public class MAA_Servlet extends HttpServlet {
  private static final long serialVersionUID = 1L;     
  private static Logger logger = Logger.getLogger("com.oracle.maa.tomcat.maa_servlet");

  static String get_id_sql = "select username from demo where id = ?"; 

  static String dbPassword = System.getenv("HATEST_DB_MAIN_PASSWORD");
  static String dbUser     = System.getenv("HATEST_DB_MAIN_USER");
  static String dbURL      = System.getenv("HATEST_JDBC_URL");
  final  int    poolSize   = 10;
  final  int    sqlTries = 2;

  static PoolDataSource pds;
  static Connection nextConnection = null;

  public MAA_Servlet() {
    super();
  }

  public void init() {
    logger.info("Servlet starting");

    // Load JDBC driver and create the pool datasource
    try {
      pds = PoolDataSourceFactory.getPoolDataSource();
      pds.setConnectionFactoryClassName("oracle.jdbc.pool.OracleDataSource");
      pds.setURL(dbURL);
      pds.setUser(dbUser);
      pds.setPassword(dbPassword);
      pds.setInitialPoolSize(poolSize);
      pds.setMinPoolSize(poolSize);
      pds.setMaxPoolSize(poolSize);
      pds.setConnectionWaitTimeout(0);

      Runnable r = new Runnable() {
        public void run() {
          poolBackground();
        }
      };
      new Thread(r).start();

    } catch (SQLException e) {
      e.printStackTrace();
    }
  }
  
  public Connection getConnectionNoWait() throws SQLException {
    Connection conn;
    synchronized(this) {
      if (nextConnection == null) {
        throw new SQLException("no connection available with no wait");
      } else
        conn = nextConnection;
        nextConnection = null;
    }
    return conn;
  }

  public void poolBackground() {
    Connection conn;
    while (true) {
      synchronized(this) {
        conn = nextConnection;
      }
      if (conn == null) {
        try {
          conn = pds.getConnection();
          PreparedStatement stmt = conn.prepareStatement(get_id_sql); 
          synchronized(this) {
            nextConnection = conn;
          }
        } catch (Exception e) {
          nextConnection = null;
          logger.log(Level.INFO, "Exception getting connection in background ", e);
        }
      } else {
        try {
          Thread.sleep(0,100); // Sleep 100 nanoseconds so we don't spin
        } catch (InterruptedException e) {
          Thread.currentThread().interrupt();
          logger.log(Level.SEVERE, "pool background interrupted ", e);
        }
      }
    }
  }

  protected void doGet(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
    int sqlTry = 1;
    String id = "";
    String probe = "";
    id = request.getPathInfo().split("/")[1];
    probe = request.getParameter("probe");
    logger.info("id: " + id + " probe: " + probe);

    while (true) {
      try (Connection conn = getConnectionNoWait()) {
        PreparedStatement stmt = conn.prepareStatement(get_id_sql); 
        stmt.setString(1, id);
        ResultSet rs = stmt.executeQuery(); 
        if (rs.next()) {
          response.setStatus(200);
          response.getWriter().println(rs.getString(1));
        } else {
          response.setStatus(201);
        }
        break;
      } catch (Exception e) {
        if (sqlTry < sqlTries) {
          logger.log(Level.SEVERE, "Exception processing probe# " + probe + " , retrying", e);
          sqlTry++;
        } else {
          response.setStatus(500);
          response.setHeader("Exception", e.toString());
          logger.log(Level.SEVERE, "Exception processing probe# " + probe, e);
          break;
        }
      }
    }
  }

  public void destroy() { }
}