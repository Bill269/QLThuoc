package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import repository.UserRepository;

import java.io.IOException;

@WebServlet("/users")
public class UserServlet extends HttpServlet {
    UserRepository repo = new UserRepository();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, IOException {
        String action = req.getParameter("action");
        if ("delete".equals(action)) {
            try { repo.delete(req.getParameter("id")); } catch (Exception e) {}
            resp.sendRedirect("users");
            return;
        }
        req.setAttribute("userList", repo.getAll());
        req.getRequestDispatcher("/WEB-INF/views/quan-ly-user.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User u = new User(req.getParameter("username"), req.getParameter("password"), req.getParameter("role"));
        try { repo.save(u, false); } catch (Exception e) {}
        resp.sendRedirect("users");
    }
}
