package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import model.Thuoc;
import repository.ThuocRepository;

@WebServlet("/edit")
public class ThuocUpdateServlet extends HttpServlet {
    private final ThuocRepository repository = new ThuocRepository();
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Thuoc thuoc = repository.getById(id);
            req.setAttribute("thuocToEdit", thuoc);
            req.getRequestDispatcher("/WEB-INF/views/sua-thuoc.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendRedirect("thuoc");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String ten = req.getParameter("ten");
            String loai = req.getParameter("loai");
            int soLuong = Integer.parseInt(req.getParameter("soLuong"));
            java.util.Date hanSD = dateFormat.parse(req.getParameter("hanSuDung"));

            Thuoc t = new Thuoc(id, ten, loai, soLuong, hanSD);
            repository.update(t);
            resp.sendRedirect("thuoc");
        } catch (Exception e) {
            resp.sendRedirect("thuoc?error=update_failed");
        }
    }
}