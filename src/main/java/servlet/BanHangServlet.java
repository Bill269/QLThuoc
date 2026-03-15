package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import repository.ThuocRepository;
import java.io.IOException;

@WebServlet("/ban-hang")
public class BanHangServlet extends HttpServlet {
    private final ThuocRepository repo = new ThuocRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("sell".equals(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                User user = (User) req.getSession().getAttribute("currentUser");
                int userId = (user != null) ? user.getId() : 1;
                repo.banThuoc(id, userId);
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/ban-hang");
            return;
        }

        String search = req.getParameter("txtSearch");
        req.setAttribute("listThuoc", repo.getThuocDangConHang(search));
        req.setAttribute("totalAmount", repo.getTotalStock());
        req.setAttribute("warningCount", repo.countWarning());
        req.setAttribute("expiredCount", repo.countExpired());
        req.setAttribute("lastSearch", search);
        req.getRequestDispatcher("/WEB-INF/views/ban-hang.jsp").forward(req, resp);
    }
}