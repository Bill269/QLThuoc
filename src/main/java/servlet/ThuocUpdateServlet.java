package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import model.Thuoc;
import model.User;
import repository.ThuocRepository;

@WebServlet("/edit")
public class ThuocUpdateServlet extends HttpServlet {

    private static final ThuocRepository repository = new ThuocRepository();
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");

        if (currentUser == null || !"ADMIN".equals(currentUser.getNhomQuyen())) {
            resp.sendRedirect(req.getContextPath() + "/thuoc");
            return;
        }

        try {
            Long id = Long.valueOf(req.getParameter("id"));
            Thuoc thuocToEdit = repository.getById(id);

            if (thuocToEdit != null) {
                req.setAttribute("thuocToEdit", thuocToEdit);
                req.getRequestDispatcher("/WEB-INF/views/sua-thuoc.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/thuoc");
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/thuoc");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        try {
            Long id = Long.valueOf(req.getParameter("id"));
            String tenThuoc = req.getParameter("ten");
            String loaiThuoc = req.getParameter("loai");
            int soLuongTon = Integer.parseInt(req.getParameter("soLuong"));
            Date hanSuDung = dateFormat.parse(req.getParameter("hanSuDung"));

            Thuoc updatedThuoc = new Thuoc(id, tenThuoc, loaiThuoc, soLuongTon, hanSuDung);
            repository.update(updatedThuoc);

            resp.sendRedirect(req.getContextPath() + "/thuoc");

        } catch (Exception e) {
            String errorMsg = "Lỗi: Dữ liệu không hợp lệ. Vui lòng kiểm tra ngày tháng/số lượng.";
            System.err.println("Lỗi cập nhật thuốc: " + e.getMessage());

            try {
                Long id = Long.valueOf(req.getParameter("id"));
                Thuoc thuocToEdit = repository.getById(id);

                req.setAttribute("thuocToEdit", thuocToEdit);
                req.setAttribute("error", errorMsg);

                req.getRequestDispatcher("/WEB-INF/views/sua-thuoc.jsp").forward(req, resp);
            } catch (Exception ex) {
                resp.sendRedirect(req.getContextPath() + "/thuoc");
            }
        }
    }
}