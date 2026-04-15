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
import java.util.List;

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
                req.setAttribute("listHanDung", chaRepo.getAllHanDung()); // Bổ sung cho CBB
                req.getRequestDispatcher("/WEB-INF/views/them-thuoc-cha.jsp").forward(req, resp);
                return;
            }

            if ("edit_form".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("detail_thuoc_cha", chaRepo.getById(id));
                req.setAttribute("loai", chaRepo.getAllLoaiThuoc());
                req.setAttribute("donVi", chaRepo.getAllDonViTinh());
                req.setAttribute("listHanDung", chaRepo.getAllHanDung()); // Bổ sung cho CBB
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
        String tenThuoc = req.getParameter("tenThuoc");
        String moTa = req.getParameter("moTa");
        String idStr = req.getParameter("id");
        Integer loai = Integer.parseInt(req.getParameter("loai"));
        Integer donVi = Integer.parseInt(req.getParameter("donVi"));
        Boolean tinhTrang = Boolean.parseBoolean(req.getParameter("tinhTrang"));
        String hanDung = req.getParameter("hanDung");

        // Ép kiểu giá bán để kiểm tra
        Double giaBan = 0.0;
        try {
            giaBan = Double.parseDouble(req.getParameter("giaBan"));
        } catch (Exception e) { giaBan = -1.0; }

        String error = null;
        String regex = "^[a-zA-Z0-9À-ỹ\\s]+$"; // Không khoảng trắng, không ký tự đặc biệt
        Integer currentId = (idStr != null && !idStr.isEmpty()) ? Integer.parseInt(idStr) : null;

        // --- BỘ LỌC VALIDATE THEO THỨ TỰ ƯU TIÊN ---

        // 1. Validate Tên Thuốc
        if (tenThuoc == null || tenThuoc.trim().isEmpty()) {
            error = "Tên dược phẩm không được để trống!";
        } else if (chaRepo.isTenThuocExists(tenThuoc, currentId)) {
            error = "Tên dược phẩm này đã tồn tại!";
        } else if (tenThuoc.length() < 5 || tenThuoc.length() > 40) {
            error = "Tên phải từ 5 đến 40 ký tự!";
        } else if (!tenThuoc.matches(regex)) {
            error = "Tên không được chứa ký tự đặc biệt!";
        }

        // 2. Validate Mô tả (Nếu tên đã pass thì check tiếp mô tả)
        else if (moTa == null || moTa.trim().isEmpty()) {
            error = "Mô tả không được để trống!";
        } else if (moTa.length() < 5 || moTa.length() > 40) {
            error = "Mô tả phải từ 5 đến 40 ký tự!";
        } else if (!moTa.matches(regex)) {
            error = "Mô tả không được chứa ký tự đặc biệt!";
        }

        // 3. Validate Giá bán
        else if (giaBan <= 0) {
            error = "Giá bán mặc định phải lớn hơn 0!";
        }

        // Nếu có lỗi, quay lại form và hiển thị thông báo
        if (error != null) {
            req.setAttribute("error", error);
            // Giữ lại dữ liệu cũ để người dùng không phải nhập lại
            req.setAttribute("detail_thuoc_cha", new ThuocCha(currentId != null ? currentId : 0, tenThuoc, loai, donVi, giaBan, tinhTrang, hanDung, moTa, null, null));

            // Quay lại đúng form tương ứng
            if ("update".equals(action)) {
                req.setAttribute("loai", chaRepo.getAllLoaiThuoc());
                req.setAttribute("donVi", chaRepo.getAllDonViTinh());
                req.setAttribute("listHanDung", chaRepo.getAllHanDung());
                req.getRequestDispatcher("/WEB-INF/views/sua-thuoc-cha.jsp").forward(req, resp);
            } else {
                req.setAttribute("loai", chaRepo.getAllLoaiThuoc());
                req.setAttribute("donVi", chaRepo.getAllDonViTinh());
                req.setAttribute("listHanDung", chaRepo.getAllHanDung());
                req.getRequestDispatcher("/WEB-INF/views/them-thuoc-cha.jsp").forward(req, resp);
            }
            return;
        }

        // --- NẾU KHÔNG CÓ LỖI THÌ GIỮ NGUYÊN LOGIC CŨ CỦA BẠN ---
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