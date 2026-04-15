package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Thuoc;
import model.ThuocCha;
import repository.DonViRepository;
import repository.LoaiThuocRepository;
import repository.ThuocRepository;
import repository.ThuocChaRepository;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/kho")
public class ThuocServlet extends HttpServlet {
    private final ThuocRepository repository = new ThuocRepository();
    private final ThuocChaRepository thuocChaRepo = new ThuocChaRepository(); // Thêm để lấy list thuốc cha cho form
    private final LoaiThuocRepository loaiRepo = new LoaiThuocRepository();
    private final DonViRepository donViRepo = new DonViRepository();
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

        req.setAttribute("totalTypes", thuocChaRepo.getAll().size());

        setTrangThaiThuoc(list);
        req.setAttribute("listThuoc", list);
        req.setAttribute("listLoai", loaiRepo.getAllLoai());
        req.setAttribute("totalAmount", repository.getTotalStock());
        req.setAttribute("warningCount", repository.countWarning());
        req.setAttribute("expiredCount", repository.countExpired());

        req.getRequestDispatcher("/WEB-INF/views/danh-sach-thuoc.jsp").forward(req, resp);
    }

    private void showAddForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Sửa lỗi: Nạp listThuocCha để hiển thị tên thuốc trong dropdown thêm mới
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
            // Cần listThuocCha nếu bạn cho phép đổi tên thuốc khi sửa lô
            req.setAttribute("listThuocCha", thuocChaRepo.getAll());
            req.getRequestDispatcher("/WEB-INF/views/sua-thuoc.jsp").forward(req, resp);
        } else {
            resp.sendRedirect("kho");
        }
    }

    private void showDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Thuoc thuoc = repository.getById(id);
        if (thuoc != null) {
            setTrangThaiThuoc(Arrays.asList(thuoc));
            req.setAttribute("thuoc", thuoc);
            req.getRequestDispatcher("/WEB-INF/views/chi-tiet-thuoc.jsp").forward(req, resp);
        } else {
            resp.sendRedirect("kho?error=not_found");
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

        try {
            soLuong = Integer.parseInt(soLuongStr);
        } catch (NumberFormatException e) {
            soLuong = -1; // Đánh dấu lỗi nếu nhập chữ
        }

        // Kiểm tra số lượng phải lớn hơn 0
        if (soLuong <= 0) {
            // Chuyển hướng về lại trang add kèm thông báo lỗi
            resp.sendRedirect("kho?action=add&error=invalid_quantity");
            return;
        }

        // --- Nếu pass validate thì mới chạy tiếp đoạn code cũ của bạn ---
        int idTenThuoc = Integer.parseInt(req.getParameter("idTenThuoc"));
        Date hanSD = dateFormat.parse(req.getParameter("hanSuDung"));

        ThuocCha tc = new ThuocCha();
        tc.setId(idTenThuoc);

        Thuoc thuoc = new Thuoc();
        thuoc.setThuocCha(tc);
        thuoc.setSoLuongTon(soLuong);
        thuoc.setHanSuDung(hanSD);
        thuoc.setNgayNhapThuoc(new Date());

        repository.add(thuoc);
        resp.sendRedirect("kho?msg=inserted");
    }

    private void updateThuoc(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        // 1. Lấy ID trước để nếu có lỗi còn biết đường quay lại đúng trang sửa
        int id = Integer.parseInt(req.getParameter("id"));

        // 2. Lấy số lượng và kiểm tra
        String soLuongStr = req.getParameter("soLuong");
        int soLuong = 0;
        try {
            soLuong = Integer.parseInt(soLuongStr);
        } catch (NumberFormatException e) {
            soLuong = -1;
        }

        // 3. Validate: Nếu số lượng <= 0, đá về trang edit của chính ID đó
        if (soLuong <= 0) {
            resp.sendRedirect("kho?action=edit&id=" + id + "&error=invalid_quantity");
            return;
        }

        // --- Nếu pass validate thì thực hiện logic cũ ---
        int idTenThuoc = Integer.parseInt(req.getParameter("idTenThuoc"));
        Date ngayNhap = dateFormat.parse(req.getParameter("ngayNhap"));
        Date hanSD = dateFormat.parse(req.getParameter("hanSuDung"));

        ThuocCha tc = new ThuocCha();
        tc.setId(idTenThuoc);

        Thuoc thuoc = new Thuoc();
        thuoc.setId(id);
        thuoc.setThuocCha(tc);
        thuoc.setSoLuongTon(soLuong);
        thuoc.setNgayNhapThuoc(ngayNhap);
        thuoc.setHanSuDung(hanSD);

        repository.update(thuoc);
        resp.sendRedirect("kho?msg=updated");
    }

    private void setTrangThaiThuoc(List<Thuoc> list) {
        Date now = new Date();
        for (Thuoc t : list) {
            Date ngayNhap = t.getNgayNhapThuoc();
            if (ngayNhap == null) {
                t.setTrangThaiThuoc("Đang cập nhật");
                continue;
            }

            long diffMillis = now.getTime() - ngayNhap.getTime();
            long diffDays = diffMillis / (1000 * 60 * 60 * 24);

            if (diffDays < 0) {
                t.setTrangThaiThuoc("Hàng chờ nhập"); // Ngày nhập ở tương lai
            } else if (diffDays <= 7) {
                t.setTrangThaiThuoc("Lô mới");        // Từ 0 đến 7 ngày
            } else if (diffDays > 7 && diffDays <= 90) {
                t.setTrangThaiThuoc("Lô cũ");         // Từ ngày thứ 8 đến ngày 90 -> Sẽ vào đây!
            } else {
                t.setTrangThaiThuoc("Hàng tồn kho");  // Trên 90 ngày
            }
        }
    }
}