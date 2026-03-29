package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.LoaiThuoc;
import model.Thuoc;
import repository.DonViRepository;
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
            resp.sendRedirect("thuoc?error=system_error");
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
            resp.sendRedirect("thuoc?error=action_failed");
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

        req.getRequestDispatcher("/WEB-INF/views/danh-sach-thuoc.jsp").forward(req, resp);
    }

    private void showAddForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("listLoai", loaiRepo.getAllLoai());
        req.setAttribute("listDonVi", donViRepo.getAll()); // Thêm list Đơn vị
        req.getRequestDispatcher("/WEB-INF/views/them-thuoc.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Thuoc t = repository.getById(id);
        if (t != null) {
            req.setAttribute("thuocToEdit", t);
            req.setAttribute("listLoai", loaiRepo.getAllLoai());
            req.setAttribute("listDonVi", donViRepo.getAll()); // Thêm list Đơn vị
            req.getRequestDispatcher("/WEB-INF/views/sua-thuoc.jsp").forward(req, resp);
        } else {
            resp.sendRedirect("thuoc");
        }
    }

    private void showDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Thuoc thuoc = repository.getById(id);
        if (thuoc != null) {
            List<Thuoc> listTam = new java.util.ArrayList<>();
            listTam.add(thuoc);

            setTrangThaiThuoc(listTam);
            req.setAttribute("thuoc", thuoc);
            req.getRequestDispatcher("/WEB-INF/views/chi-tiet-thuoc.jsp").forward(req, resp);
        } else {
            resp.sendRedirect("thuoc?error=not_found");
        }
    }

    private void deleteThuoc(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        repository.delete(Integer.parseInt(req.getParameter("id")));
        resp.sendRedirect("thuoc?msg=deleted");
    }

    private void insertThuoc(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String ten = req.getParameter("ten");
        int idLoai = Integer.parseInt(req.getParameter("idLoai"));
        int idDonVi = Integer.parseInt(req.getParameter("idDonVi"));
        int soLuong = Integer.parseInt(req.getParameter("soLuong"));
        float gia = Float.parseFloat(req.getParameter("giaBan"));
        Date ngayNhap = dateFormat.parse(req.getParameter("ngayNhap"));
        Date hanSD = dateFormat.parse(req.getParameter("hanSuDung"));

        Thuoc thuoc = new Thuoc(ten, idLoai, "", soLuong, ngayNhap, hanSD, gia, idDonVi, "");
        setTrangThaiThuoc(java.util.Arrays.asList(thuoc)); // cập nhật trạng thái

        repository.add(new Thuoc(ten, idLoai, "", soLuong, ngayNhap, hanSD, gia, idDonVi, ""));
        resp.sendRedirect("thuoc?msg=inserted");
    }

    private void updateThuoc(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));
        String ten = req.getParameter("ten");
        int idLoai = Integer.parseInt(req.getParameter("idLoai"));
        int idDonVi = Integer.parseInt(req.getParameter("idDonVi"));
        int soLuong = Integer.parseInt(req.getParameter("soLuong"));
        float gia = Float.parseFloat(req.getParameter("giaBan"));
        Date ngayNhap = dateFormat.parse(req.getParameter("ngayNhap"));
        Date hanSD = dateFormat.parse(req.getParameter("hanSuDung"));

        Thuoc thuoc = new Thuoc(id, ten, idLoai, "", soLuong, ngayNhap, hanSD, gia, idDonVi, "");
        setTrangThaiThuoc(java.util.Arrays.asList(thuoc)); // cập nhật trạng thái

        repository.update(new Thuoc(id, ten, idLoai, "", soLuong, ngayNhap, hanSD, gia, idDonVi, ""));
        resp.sendRedirect("thuoc?msg=updated");
    }

    private void setTrangThaiThuoc(List<Thuoc> list) {
        Date now = new Date();
        for (Thuoc t : list) {
            Date ngayNhap = t.getNgayNhapThuoc();
            if (ngayNhap == null) {
                t.setTrangThaiThuoc("Không xác định");
                continue;
            }

            long diffMillis = now.getTime() - ngayNhap.getTime();
            long diffDays = diffMillis / (1000 * 60 * 60 * 24);

            if (diffDays < 0) {
                t.setTrangThaiThuoc("Chưa nhập"); // ngày nhập nằm ở tương lai
            } else if (diffDays <= 7) {
                t.setTrangThaiThuoc("Lô mới");
            } else if (diffDays <= 90) {
                t.setTrangThaiThuoc("Lô cũ");
            } else {
                t.setTrangThaiThuoc("Hàng tồn kho");
            }
        }
    }
}