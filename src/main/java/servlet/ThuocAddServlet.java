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

@WebServlet("/add")
public class ThuocAddServlet extends HttpServlet {

    private static final ThuocRepository repository = new ThuocRepository();
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");

        if (currentUser == null || !"ADMIN".equals(currentUser.getNhomQuyen())) {
            resp.sendRedirect(req.getContextPath() + "/thuoc");
            return;
        }

        req.setAttribute("pageTitle", "Thêm Thuốc Mới");
        req.getRequestDispatcher("/WEB-INF/views/them-thuoc.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        User currentUser = (User) req.getSession().getAttribute("currentUser");
        if (currentUser == null || !"ADMIN".equals(currentUser.getNhomQuyen())) {
            resp.sendRedirect(req.getContextPath() + "/thuoc");
            return;
        }

        try {
            String tenThuoc = req.getParameter("ten");
            String loaiThuoc = req.getParameter("loai");
            int soLuongTon = Integer.parseInt(req.getParameter("soLuong"));
            Date hanSuDung = dateFormat.parse(req.getParameter("hanSuDung"));


            Thuoc newThuoc = new Thuoc(tenThuoc, loaiThuoc, soLuongTon, hanSuDung);

            repository.add(newThuoc);

            // Thêm thành công thì quay về danh sách
            resp.sendRedirect(req.getContextPath() + "/thuoc");

        } catch (NumberFormatException e) {
            req.setAttribute("error", "Lỗi: Số lượng tồn kho phải là một số nguyên!");
            req.setAttribute("pageTitle", "Thêm Thuốc Mới");
            req.getRequestDispatcher("/WEB-INF/views/them-thuoc.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi dữ liệu: Vui lòng kiểm tra lại thông tin nhập vào.");
            req.setAttribute("pageTitle", "Thêm Thuốc Mới");
            req.getRequestDispatcher("/WEB-INF/views/them-thuoc.jsp").forward(req, resp);
        }
    }
}