package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import repository.ThuocRepository;
import repository.HoaDonRepository; // Đảm bảo đã import HoaDonRepository
import java.io.IOException;

@WebServlet("/ban-hang")
public class BanHangServlet extends HttpServlet {
    private final ThuocRepository repo = new ThuocRepository();
    private final HoaDonRepository hdRepo = new HoaDonRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String search = req.getParameter("txtSearch");
        if (search == null) search = "";

        if ("sell".equals(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                User user = (User) req.getSession().getAttribute("currentUser");
                int userId = (user != null) ? user.getId() : 1;
                repo.banThuoc(id, userId);
                req.getSession().setAttribute("message", "Đã bán 1 đơn vị thuốc!");
                req.getSession().setAttribute("messageType", "success");
            } catch (Exception e) {
                req.getSession().setAttribute("message", "Lỗi: " + e.getMessage());
                req.getSession().setAttribute("messageType", "danger");
            }
            resp.sendRedirect("ban-hang");
            return;
        }


        // 2. LOGIC BÁN HÀNG GỐC
        if (search == null) search = "";

        req.setAttribute("listThuoc", repo.getThuocDangConHang(search));
        req.setAttribute("totalAmount", repo.getTotalStock());
        req.setAttribute("warningCount", repo.countWarning());
        req.setAttribute("expiredCount", repo.countExpired());
        req.setAttribute("lastSearch", search);

        // Xử lý message thông báo
        HttpSession session = req.getSession();
        if (session.getAttribute("message") != null) {
            req.setAttribute("message", session.getAttribute("message"));
            req.setAttribute("messageType", session.getAttribute("messageType"));
            session.removeAttribute("message");
            session.removeAttribute("messageType");
        }

        req.getRequestDispatcher("/WEB-INF/views/ban-hang.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8"); // Chống lỗi font khi xử lý dữ liệu
        String action = req.getParameter("action");
        HttpSession session = req.getSession();

        if ("sell".equals(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                User user = (User) session.getAttribute("currentUser");
                int userId = (user != null) ? user.getId() : 1;

                // Gọi hàm banThuoc có kiểm tra hạn sử dụng (như đã sửa ở ThuocRepository trước đó)
                // Lưu ý: Đảm bảo ThuocRepository.banThuoc trả về String hoặc ném Exception nếu hết hạn
                repo.banThuoc(id, userId);

                session.setAttribute("message", "Bán hàng thành công! Kho đã được cập nhật.");
                session.setAttribute("messageType", "success");
            } catch (Exception e) {
                // Nếu lỗi do hết hạn hoặc hết hàng, e.getMessage() sẽ hiển thị thông báo đó
                session.setAttribute("message", "Giao dịch thất bại: " + e.getMessage());
                session.setAttribute("messageType", "danger");
            }
        }
        resp.sendRedirect(req.getContextPath() + "/ban-hang");
    }
}