package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.HoaDon;
import repository.HoaDonRepository;
import java.io.IOException;
import java.util.List;

@WebServlet("/hoa-don") // Đường dẫn mới cho phần hóa đơn
public class HoaDonServlet extends HttpServlet {
    private final HoaDonRepository hdRepo = new HoaDonRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String searchId = req.getParameter("txtSearchId");
        List<HoaDon> list = hdRepo.getLichSuBanHangGop(searchId);
        // Lấy chi tiết cho từng hóa đơn (nếu Repository của bạn chưa gán chi tiết ở bước trên)
        for (HoaDon hd : list) {
            hd.setChiTietList(hdRepo.getChiTietByHoaDonId(hd.getId()));
        }
        req.setAttribute("listHD", list);
        req.setAttribute("lastSearchId", searchId);
        req.getRequestDispatcher("/WEB-INF/views/lich-su-ban-hang.jsp").forward(req, resp);
    }
}