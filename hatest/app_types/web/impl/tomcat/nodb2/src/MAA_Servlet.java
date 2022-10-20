/*
 ** Copyright (c) 2023 Oracle and/or its affiliates.
 ** Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/
 */

package com.oracle.maa.tomcat;

import java.io.IOException;

import java.util.logging.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// MAA Tip: Load the servlet on Startup
@WebServlet(name="MAA_Servlet", urlPatterns="/*", loadOnStartup=1)
public class MAA_Servlet extends HttpServlet {
  private static final long serialVersionUID = 1L;     
  private static Logger logger = Logger.getLogger("com.oracle.maa.tomcat.maa_servlet");

  public MAA_Servlet() {
    super();
  }

  public void init() {
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