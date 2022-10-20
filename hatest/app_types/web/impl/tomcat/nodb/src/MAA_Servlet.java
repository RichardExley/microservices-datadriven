package com.oracle.maa.tomcat;

import java.io.IOException;
//import java.io.PrintWriter;

import java.util.logging.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name="MAA_Servlet", urlPatterns="/*")
public class MAA_Servlet extends HttpServlet {
  private static final long serialVersionUID = 1L;     
  private static Logger logger = Logger.getLogger("com.oracle.maa.tomcat.maa_servlet");

  public MAA_Servlet() {
    super();
  }

  public void init() {
    // logger.setLevel(Level.ALL);
    logger.info("Servlet starting");
  }
  
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
    String id = "";
    String probe = "";

    try {
      id = request.getPathInfo().split("/")[1];
      probe = request.getParameter("probe");
      logger.info("id: " + id + " probe: " + probe);

      if (id.equals("1")) {
        response.setStatus(200);
        response.getWriter().println("chris");
      } else {
        response.setStatus(201);
      }
    } catch (Exception e) {
      response.setStatus(500);
      response.setHeader("Exception", e.toString());
      logger.log(Level.SEVERE, "An exception was thrown processing probe# " + probe, e);
    }
  }

  public void destroy() { }
}