package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import repository.UserRepository;
import java.io.IOException;

@WebServlet("/users")
public class UserServlet extends HttpServlet {
    UserRepository repo = new UserRepository();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String idStr = req.getParameter("id");

        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);

                if ("delete".equals(action)) {
                    repo.delete(id);
                    resp.sendRedirect("users");
                    return;
                }
                if ("edit".equals(action)) {
                    User user = repo.getById(id);
                    if (user != null) {
                        req.setAttribute("userToEdit", user);
                        req.getRequestDispatcher("/WEB-INF/views/sua-user.jsp").forward(req, resp);
                        return;
                    }
                }
            } catch (NumberFormatException e) {
                System.err.println("Lỗi: ID không phải là số: " + idStr);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        req.setAttribute("userList", repo.getAll());
        req.getRequestDispatcher("/WEB-INF/views/quan-ly-user.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String idStr = req.getParameter("userId");
        User u = new User(req.getParameter("username"), req.getParameter("password"), req.getParameter("role"));

        try {
            if (idStr != null && !idStr.isEmpty()) {
                u.setId(Integer.parseInt(idStr));
                repo.save(u, true);
            } else {
                repo.save(u, false);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        resp.sendRedirect("users");
    }
}