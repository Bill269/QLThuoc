package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;
import model.Thuoc; // Import model
import model.User;   // Import model
import repository.ThuocRepository; // Import repository

@WebServlet("/thuoc")
public class ThuocServlet extends HttpServlet {
    private static final ThuocRepository repository = new ThuocRepository();

    private void setupAndForwardList(HttpServletRequest req, HttpServletResponse resp, List<Thuoc> dsThuoc) throws ServletException, IOException {
        long totalAmount = repository.getTotalStock();
        long warningCount = repository.countWarning();
        long expiredCount = repository.countExpired();

        java.util.Date ngayHienTai = new java.util.Date();
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.add(java.util.Calendar.DAY_OF_MONTH, 30);
        java.util.Date ngayCanhBao = cal.getTime();

        req.setAttribute("dsThuoc", dsThuoc);
        req.setAttribute("totalAmount", totalAmount);
        req.setAttribute("warningCount", warningCount);
        req.setAttribute("expiredCount", expiredCount);
        req.setAttribute("ngayHienTai", ngayHienTai);
        req.setAttribute("ngayCanhBao", ngayCanhBao);
        req.setAttribute("pageTitle", "Quản Lý Danh Mục Thuốc");

        req.setAttribute("pageTitle", "Quản Lý Danh Mục Thuốc");

        req.getRequestDispatcher("/WEB-INF/views/danh-sach-thuoc.jsp").forward(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        if (action == null || action.isEmpty() || action.equals("list")) {

            List<Thuoc> dsThuoc = repository.getAll();
            setupAndForwardList(req, resp, dsThuoc);

        } else if (action.equals("delete")) {
            if (!"ADMIN".equals(currentUser.getNhomQuyen())) {
                req.setAttribute("error", "Bạn không có quyền thực hiện thao tác xóa!");

                setupAndForwardList(req, resp, repository.getAll());
                return;
            }
            try {
                Long id = Long.valueOf(req.getParameter("id"));
                repository.delete(id);
            } catch (NumberFormatException e) {
                req.getSession().setAttribute("error", "Lỗi: ID thuốc không hợp lệ.");
            }
            resp.sendRedirect(req.getContextPath() + "/thuoc");

        } else if (action.equals("filter")) {
            String loaiThuoc = req.getParameter("loai");
            String filterType = req.getParameter("filter");
            Boolean sapHetHan = null;
            if ("expired".equals(filterType)) {
                sapHetHan = true;
            }
            List<Thuoc> dsLoc = repository.filter(loaiThuoc, sapHetHan);
            setupAndForwardList(req, resp, dsLoc);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/thuoc");
    }
}