package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.LoaiThuoc;
import model.Thuoc;
import repository.LoaiThuocRepository;
import repository.ThuocRepository;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/thuoc")
public class ThuocServlet extends HttpServlet {
    private final ThuocRepository repository = new ThuocRepository();
    private final LoaiThuocRepository loaiRepo = new LoaiThuocRepository();
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "add":
                    showAddForm(req, resp);
                    break;
                case "edit":
                    showEditForm(req, resp);
                    break;
                case "detail":
                    showDetail(req, resp);
                    break;
                case "delete":
                    deleteThuoc(req, resp);
                    break;
                default:
                    listThuoc(req, resp);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("thuoc?error=system_error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Thiết lập tiếng Việt cho dữ liệu từ Form gửi lên
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        try {
            if ("insert".equals(action)) {
                insertThuoc(req, resp);
            } else if ("update".equals(action)) {
                updateThuoc(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("thuoc?error=action_failed");
        }
    }

    // 1. Hiển thị danh sách kèm tìm kiếm và thống kê
    private void listThuoc(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String txtSearch = req.getParameter("txtSearch");
        String selLoai = req.getParameter("selLoai");

        // Gọi hàm search có lọc theo tên và loại
        List<Thuoc> list = repository.searchThuoc(txtSearch, selLoai);

        // Đẩy dữ liệu ra View
        req.setAttribute("listThuoc", list);
        req.setAttribute("listLoai", loaiRepo.getAll());

        // Cập nhật các con số thống kê (Badge trên giao diện)
        req.setAttribute("totalAmount", repository.getTotalStock());
        req.setAttribute("warningCount", repository.countWarning()); // Sắp hết hạn (30 ngày)
        req.setAttribute("expiredCount", repository.countExpired()); // Đã hết hạn (Bị khóa)

        // Giữ lại giá trị tìm kiếm cũ trên input
        req.setAttribute("lastSearch", txtSearch);
        req.setAttribute("lastLoai", selLoai);

        req.getRequestDispatcher("/WEB-INF/views/danh-sach-thuoc.jsp").forward(req, resp);
    }

    // 2. Form thêm mới
    private void showAddForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("listLoai", loaiRepo.getAll());
        req.getRequestDispatcher("/WEB-INF/views/them-thuoc.jsp").forward(req, resp);
    }

    // 3. Form chỉnh sửa
    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Thuoc t = repository.getById(id);

        if (t != null) {
            req.setAttribute("thuocToEdit", t);
            req.setAttribute("listLoai", loaiRepo.getAll());
            req.getRequestDispatcher("/WEB-INF/views/sua-thuoc.jsp").forward(req, resp);
        } else {
            resp.sendRedirect("thuoc");
        }
    }

    // 4. Xem chi tiết
    private void showDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        req.setAttribute("thuoc", repository.getById(id));
        req.getRequestDispatcher("/WEB-INF/views/chi-tiet-thuoc.jsp").forward(req, resp);
    }

    // 5. Xử lý xóa
    private void deleteThuoc(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));
        repository.delete(id);
        resp.sendRedirect("thuoc?msg=deleted");
    }

    private void insertThuoc(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String ten = req.getParameter("ten");
        String loai = req.getParameter("loai"); // Lấy String trực tiếp
        int soLuong = Integer.parseInt(req.getParameter("soLuong"));
        float gia = Float.parseFloat(req.getParameter("giaBan")); // Lấy giá bán
        Date hanSD = dateFormat.parse(req.getParameter("hanSuDung"));

        // Kiểm tra logic hạn dùng
        if (hanSD.before(new Date())) {
            req.setAttribute("error", "Hạn sử dụng không được là ngày trong quá khứ!");
            showAddForm(req, resp);
            return;
        }

        // Gọi Constructor 5 tham số: (ten, loai, soLuong, hanSD, gia)
        repository.add(new Thuoc(ten, loai, soLuong, hanSD, gia));
        resp.sendRedirect("thuoc?msg=inserted");
    }

    // 7. Xử lý cập nhật DB
    private void updateThuoc(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));
        String ten = req.getParameter("ten");
        String loai = req.getParameter("loai"); // Lấy String trực tiếp
        int soLuong = Integer.parseInt(req.getParameter("soLuong"));
        float gia = Float.parseFloat(req.getParameter("giaBan"));
        Date hanSD = dateFormat.parse(req.getParameter("hanSuDung"));

        // Gọi Constructor 6 tham số: (id, ten, loai, soLuong, hanSD, gia)
        repository.update(new Thuoc(id, ten, loai, soLuong, hanSD, gia));
        resp.sendRedirect("thuoc?msg=updated");
    }
}