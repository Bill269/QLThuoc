package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Thuoc;
import model.ThuocCha;
import repository.LoaiThuocRepository;
import repository.ThuocRepository;
import repository.ThuocChaRepository;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

@WebServlet("/kho")
public class ThuocServlet extends HttpServlet {
    private final ThuocRepository repository = new ThuocRepository();
    private final ThuocChaRepository thuocChaRepo = new ThuocChaRepository();
    private final LoaiThuocRepository loaiRepo = new LoaiThuocRepository();
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "add": showAddForm(req, resp); break;
                case "edit": showEditForm(req, resp); break;
                case "detail": showDetail(req, resp); break; // Hàm này đã được sửa
                case "delete": deleteThuoc(req, resp); break;
                default: listThuoc(req, resp); break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("kho?error=system_error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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
            resp.sendRedirect("kho?error=action_failed");
        }
    }

    private void listThuoc(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String txtSearch = req.getParameter("txtSearch");
        String selLoai = req.getParameter("selLoai");

        List<Thuoc> list = repository.searchThuoc(txtSearch, selLoai);

        setTrangThaiThuoc(list);
        req.setAttribute("listThuoc", list);
        req.setAttribute("listLoai", loaiRepo.getAllLoai());
        req.setAttribute("totalAmount", repository.getTotalStock());
        req.setAttribute("warningCount", repository.countWarning());
        req.setAttribute("expiredCount", repository.countExpired());
        req.setAttribute("totalTypes", thuocChaRepo.getAll().size());

        req.getRequestDispatcher("/WEB-INF/views/danh-sach-thuoc.jsp").forward(req, resp);
    }

    // --- CẬP NHẬT QUAN TRỌNG: HIỂN THỊ CHI TIẾT VÀ LỊCH SỬ LÔ ---
    private void showDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));

        // 1. Lấy thông tin chi tiết của lô hàng hiện tại (Đã có giờ:phút:giây từ Repository)
        Thuoc thuoc = repository.getById(id);

        if (thuoc != null) {
            setTrangThaiThuoc(Arrays.asList(thuoc));

            // 2. Lấy toàn bộ lịch sử các lô hàng của ĐÚNG loại thuốc này
            // Hàm này sẽ trả về danh sách sắp xếp theo thời gian nhập mới nhất lên đầu
            List<Thuoc> lichSuNhap = repository.getHistoryByThuocCha(thuoc.getThuocCha().getId());

            req.setAttribute("thuoc", thuoc);
            req.setAttribute("lichSuNhap", lichSuNhap); // Đẩy list này ra JSP để vẽ bảng lịch sử

            req.getRequestDispatcher("/WEB-INF/views/chi-tiet-thuoc.jsp").forward(req, resp);
        } else {
            resp.sendRedirect("kho?error=not_found");
        }
    }

    private void showAddForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("listThuocCha", thuocChaRepo.getThuocChaDangBan());
        req.setAttribute("listLoai", loaiRepo.getAllLoai());
        req.getRequestDispatcher("/WEB-INF/views/them-thuoc.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Thuoc t = repository.getById(id);
        if (t != null) {
            req.setAttribute("thuocToEdit", t);
            req.setAttribute("listLoai", loaiRepo.getAllLoai());
            req.setAttribute("listThuocCha", thuocChaRepo.getAll());
            req.getRequestDispatcher("/WEB-INF/views/sua-thuoc.jsp").forward(req, resp);
        } else {
            resp.sendRedirect("kho");
        }
    }

    private void deleteThuoc(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));
        if (repository.isThuocDaBan(id)) {
            resp.sendRedirect("kho?error=has_invoice");
            return;
        }
        repository.delete(id);
        resp.sendRedirect("kho?msg=deleted");
    }

    private void insertThuoc(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String soLuongStr = req.getParameter("soLuong");
        int soLuong = 0;
        try { soLuong = Integer.parseInt(soLuongStr); } catch (Exception e) { soLuong = -1; }

        if (soLuong <= 0) {
            resp.sendRedirect("kho?action=add&error=invalid_quantity");
            return;
        }

        Date hanSD = dateFormat.parse(req.getParameter("hanSuDung"));
        int idTenThuoc = Integer.parseInt(req.getParameter("idTenThuoc"));

        ThuocCha tc = new ThuocCha();
        tc.setId(idTenThuoc);

        Thuoc thuoc = new Thuoc();
        thuoc.setThuocCha(tc);
        thuoc.setSoLuongTon(soLuong);
        thuoc.setHanSuDung(hanSD);

        // NgayNhapThuoc được Repository xử lý bằng GETDATE() trong SQL
        repository.add(thuoc);
        resp.sendRedirect("kho?msg=inserted");
    }

    private void updateThuoc(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));
        Thuoc currentThuoc = repository.getById(id);

        int soLuong = Integer.parseInt(req.getParameter("soLuong"));
        Date hanSDMoi = dateFormat.parse(req.getParameter("hanSuDung"));
        int idTenThuoc = Integer.parseInt(req.getParameter("idTenThuoc"));

        Thuoc thuoc = new Thuoc();
        thuoc.setId(id);
        ThuocCha tc = new ThuocCha();
        tc.setId(idTenThuoc);
        thuoc.setThuocCha(tc);
        thuoc.setSoLuongTon(soLuong);
        thuoc.setHanSuDung(hanSDMoi);

        // QUAN TRỌNG: Giữ nguyên NgayNhapThuoc cũ (có đủ giờ phút giây) để không bị ghi đè thành 00:00
        if (currentThuoc != null) {
            thuoc.setNgayNhapThuoc(currentThuoc.getNgayNhapThuoc());
        }

        repository.update(thuoc);
        resp.sendRedirect("kho?msg=updated");
    }

    private void setTrangThaiThuoc(List<Thuoc> list) {
        Date now = new Date();
        for (Thuoc t : list) {
            if (t.getNgayNhapThuoc() == null) {
                t.setTrangThaiThuoc("Đang cập nhật");
                continue;
            }
            long diffMillis = now.getTime() - t.getNgayNhapThuoc().getTime();
            long diffDays = diffMillis / (1000 * 60 * 60 * 24);

            if (diffDays < 0) t.setTrangThaiThuoc("Hàng chờ nhập");
            else if (diffDays <= 7) t.setTrangThaiThuoc("Lô mới");
            else if (diffDays <= 90) t.setTrangThaiThuoc("Lô cũ");
            else t.setTrangThaiThuoc("Hàng tồn kho");
        }
    }
}