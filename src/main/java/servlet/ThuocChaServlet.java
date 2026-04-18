package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ThuocCha;
import model.User;
import repository.ThuocChaRepository;

import java.io.IOException;

@WebServlet("/thuoc")
public class ThuocChaServlet extends HttpServlet {
    private final ThuocChaRepository chaRepo = new ThuocChaRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        if (currentUser == null || !"ADMIN".equals(currentUser.getNhomQuyen())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                if (chaRepo.isThuocDaCoLo(id)) {
                    resp.sendRedirect(req.getContextPath() + "/thuoc?error=has_lots");
                    return;
                }
                chaRepo.deleteById(id);
                resp.sendRedirect(req.getContextPath() + "/thuoc?msg=deleted");
                return;
            }

            if ("add_form".equals(action)) {
                req.setAttribute("loai", chaRepo.getAllLoaiThuoc());
                req.setAttribute("donVi", chaRepo.getAllDonViTinh());
                req.getRequestDispatcher("/WEB-INF/views/them-thuoc-cha.jsp").forward(req, resp);
                return;
            }

            if ("edit_form".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("detail_thuoc_cha", chaRepo.getById(id));
                req.setAttribute("loai", chaRepo.getAllLoaiThuoc());
                req.setAttribute("donVi", chaRepo.getAllDonViTinh());
                req.getRequestDispatcher("/WEB-INF/views/sua-thuoc-cha.jsp").forward(req, resp);
                return;
            }

            if ("detail".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("detail_thuoc_cha", chaRepo.getById(id));
                req.getRequestDispatcher("/WEB-INF/views/xem-chi-tiet-thuoc.jsp").forward(req, resp);
                return;
            }

            if ("search".equals(action)) {
                String timKiem = req.getParameter("timKiem");
                req.setAttribute("listThuocCha", chaRepo.search(timKiem));
            } else {
                req.setAttribute("listThuocCha", chaRepo.getAll());
            }

            req.getRequestDispatcher("/WEB-INF/views/danh-sach-thuoc-cha.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("thuoc?error=1");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        // Lấy dữ liệu từ form
        String tenThuoc = req.getParameter("tenThuoc");
        String moTa = req.getParameter("moTa");
        String idStr = req.getParameter("id");
        String loaiStr = req.getParameter("loai");
        String donViStr = req.getParameter("donVi");
        String giaBanStr = req.getParameter("giaBan");
        String tinhTrangStr = req.getParameter("tinhTrang");
        String hanDung = req.getParameter("hanDung");

        Integer currentId = (idStr != null && !idStr.isEmpty()) ? Integer.parseInt(idStr) : null;
        Integer loai = (loaiStr != null) ? Integer.parseInt(loaiStr) : 0;
        Integer donVi = (donViStr != null) ? Integer.parseInt(donViStr) : 0;
        Boolean tinhTrang = Boolean.parseBoolean(tinhTrangStr);

        Double giaBan = 0.0;
        try {
            giaBan = Double.parseDouble(giaBanStr);
        } catch (Exception e) { giaBan = -1.0; }

        String error = null;

        // REGEX CẢI TIẾN: Hỗ trợ toàn bộ tiếng Việt, số, khoảng trắng và các dấu cơ bản (.,()-)
        // Lưu ý: \p{L} là đại diện cho bất kỳ chữ cái nào trong Unicode (bao gồm tiếng Việt)
        String regex = "^[\\p{L}0-9\\s,().\\-]+$";

        // 1. Validate Tên Thuốc
        if (tenThuoc == null || tenThuoc.trim().isEmpty()) {
            error = "Tên dược phẩm không được để trống!";
        } else if (tenThuoc.length() < 5 || tenThuoc.length() > 40) {
            error = "Tên phải từ 5 đến 40 ký tự!";
        } else if (!tenThuoc.matches(regex)) {
            error = "Tên không được chứa ký tự đặc biệt!";
        } else if (chaRepo.isTenThuocExists(tenThuoc, currentId)) {
            error = "Tên dược phẩm này đã tồn tại!";
        }

        // 2. Validate Mô tả
        else if (moTa == null || moTa.trim().isEmpty()) {
            error = "Mô tả không được để trống!";
        } else if (moTa.length() < 5 || moTa.length() > 255) { // Tăng giới hạn mô tả cho thoải mái
            error = "Mô tả phải từ 5 đến 255 ký tự!";
        } else if (!moTa.matches(regex)) {
            error = "Mô tả không được chứa ký tự đặc biệt!";
        }

        // 3. Validate Giá bán
        else if (giaBan <= 0) {
            error = "Giá bán mặc định phải lớn hơn 0!";
        }

        if (error != null) {
            req.setAttribute("error", error);
            // Gán dữ liệu vào object để hiển thị lại trên form (Tránh mất công nhập lại)
            ThuocCha tcOld = new ThuocCha(currentId != null ? currentId : 0, tenThuoc, loai, donVi, giaBan, tinhTrang, hanDung, moTa, null, null);
            req.setAttribute("detail_thuoc_cha", tcOld);
            req.setAttribute("loai", chaRepo.getAllLoaiThuoc());
            req.setAttribute("donVi", chaRepo.getAllDonViTinh());

            String path = "update".equals(action) ? "/WEB-INF/views/sua-thuoc-cha.jsp" : "/WEB-INF/views/them-thuoc-cha.jsp";
            req.getRequestDispatcher(path).forward(req, resp);
            return;
        }

        try {
            if ("update".equals(action)) {
                ThuocCha tc = new ThuocCha(currentId, tenThuoc, loai, donVi, giaBan, tinhTrang, hanDung, moTa, null, null);
                chaRepo.update(tc);
            } else if ("add".equals(action)) {
                ThuocCha tc = new ThuocCha(tenThuoc, loai, donVi, giaBan, tinhTrang, hanDung, moTa, null, null);
                chaRepo.add(tc);
            }
            resp.sendRedirect("thuoc?msg=success");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("thuoc?error=system");
        }
    }
}