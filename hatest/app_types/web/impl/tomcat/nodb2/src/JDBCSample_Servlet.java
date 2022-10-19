import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/*")
public class JDBCSample_Servlet extends HttpServlet {
  private static final long serialVersionUID = 1L;     

  public JDBCSample_Servlet() {
    super();
  }

  protected void doGet(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
    try {
      String id = request.getPathInfo().split("/")[1];
      String probe = request.getParameter("probe");
      // System.out.println("doGet: id: " + id + " probe: " + probe);

      if (id.equals("1")) {
        response.setStatus(200);
        response.getWriter().println("chris");
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