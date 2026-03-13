package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Thuoc;
import repository.ThuocRepository;
import java.io.IOException;

@WebServlet("/detail")
public class ThuocDetailServlet extends HttpServlet {
    private final ThuocRepository repository = new ThuocRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");

        try {
            if (idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);

                Thuoc thuoc = repository.getById(id);

                if (thuoc != null) {
                    req.setAttribute("thuoc", thuoc);
                    req.getRequestDispatcher("/WEB-INF/views/chi-tiet-thuoc.jsp").forward(req, resp);
                    return;
                }
            }
        } catch (NumberFormatException e) {
            System.err.println("Lỗi ID không phải là số: " + idStr);
        } catch (Exception e) {
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/thuoc");
    }
}