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
      pds.setInitialPoolSize(4);
      pds.setMinPoolSize(4);
      pds.setMaxPoolSize(4);
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
  
  private Connection getConnectionNoWait() throws SqlException (
    Connection conn;
    synchonized(nextConnection) {
      if (nextConnection == null) {
        throw new SqlException("no connection available with no wait")
      } else
        Connection conn = nextConnection;
        nextConnection = null;
    }
    return conn;
  )

  private void poolBackground() {
    Connection conn;
    while (true) {
      synchonized(nextConnection) {
        conn = nextConnection;
      }
      if (conn == null) {
        try {
          conn = pds.getConnection();
          synchonized(nextConnection) {
            nextConnection = conn;
          }
        } catch (Exception e) {
          nextConnection = null;
          logger.log(Level.INFO, "Exception getting connection in background ", e);
        }
      } else {
        Thread.sleep(0,100); // Sleep 100 nanoseconds so we don't spin
      }
    }
  }

  protected void doGet(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
    String id = "";
    String probe = "";

    try (Connection conn = pds.getConnectionNoWait()) {
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