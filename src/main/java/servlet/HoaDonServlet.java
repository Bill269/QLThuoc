package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import repository.HoaDonRepository;
import java.io.IOException;

@WebServlet("/hoa-don") // Đường dẫn mới cho phần hóa đơn
public class HoaDonServlet extends HttpServlet {
    private final HoaDonRepository hdRepo = new HoaDonRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Thay đổi hàm gọi từ getLichSuBanHang() sang getLichSuBanHangGop()
        req.setAttribute("listHD", hdRepo.getLichSuBanHangGop());
        req.getRequestDispatcher("/WEB-INF/views/lich-su-ban-hang.jsp").forward(req, resp);
    }
}