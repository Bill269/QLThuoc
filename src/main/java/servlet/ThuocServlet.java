package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Thuoc;
import repository.ThuocRepository;

@WebServlet("/thuoc")
public class ThuocServlet extends HttpServlet {
    private final ThuocRepository repository = new ThuocRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                repository.delete(id);
            } catch (Exception e) {
                req.getSession().setAttribute("error", "Không thể xóa thuốc.");
            }
            resp.sendRedirect(req.getContextPath() + "/thuoc");
            return;
        }

        req.setAttribute("dsThuoc", repository.getAll());
        req.setAttribute("totalAmount", repository.getTotalStock());
        req.setAttribute("warningCount", repository.countWarning());
        req.setAttribute("expiredCount", repository.countExpired());
        req.getRequestDispatcher("/WEB-INF/views/danh-sach-thuoc.jsp").forward(req, resp);
    }
}