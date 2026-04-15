package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.LoaiThuoc;
import model.User;
import repository.LoaiThuocRepository;

import java.io.IOException;
import java.util.List;

@WebServlet("/loai-thuoc")
public class LoaiThuocServlet extends HttpServlet {

    private final LoaiThuocRepository repo = new LoaiThuocRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        if (currentUser == null || !"ADMIN".equals(currentUser.getNhomQuyen())) {
            resp.sendRedirect(req.getContextPath() + "/thuoc");
            return;
        }

        String action = req.getParameter("action");

        try {

            if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));

                if (repo.isLoaiThuocDaDung(id)) {
                    resp.sendRedirect("loai-thuoc?error=has_products");
                    return;
                }

                repo.delete(id);
                resp.sendRedirect("loai-thuoc?msg=deleted");
                return;
            }

            if ("edit".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                LoaiThuoc lt = repo.getById(id);
                req.setAttribute("loaiEdit", lt);
            }

            List<LoaiThuoc> list = repo.getAll();
            req.setAttribute("listLoai", list);

            req.setAttribute("pageTitle", "Quản Lý Loại Thuốc");
            req.getRequestDispatcher("/WEB-INF/views/quan-ly-loai.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("loai-thuoc?error=1");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        String tenLoai = req.getParameter("tenLoai") != null ? req.getParameter("tenLoai").trim() : "";
        Boolean trangThai = Boolean.parseBoolean(req.getParameter("trangThai"));
        String idStr = req.getParameter("id");

        String errorMsg = null;
// Regex mới: Cho phép chữ, số, tiếng Việt và KHOẢNG TRẮNG (\s). Không cho ký tự đặc biệt.
        String regex = "^[a-zA-Z0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂÂÊÔƠưăâêôơẠ-ỹ\\s]+$";

// --- BỘ LỌC VALIDATE ĐÃ SẮP XẾP LẠI ---

// 1. Kiểm tra trống
        if (tenLoai == null || tenLoai.trim().isEmpty()) {
            errorMsg = "Tên loại thuốc không được để trống!";
        }
        else {
            Integer currentId = (idStr != null && !idStr.isEmpty()) ? Integer.parseInt(idStr) : null;

            // 2. Kiểm tra Trùng tên (Đưa lên trước để ưu tiên báo lỗi tồn tại)
            if (repo.isTenLoaiExists(tenLoai, currentId)) {
                errorMsg = "Tên loại thuốc này đã tồn tại!";
            }
            // 3. Kiểm tra Ký tự đặc biệt (Regex đã cho phép khoảng trắng)
            else if (!tenLoai.matches(regex)) {
                errorMsg = "Tên loại không được chứa ký tự đặc biệt!";
            }
            // 4. Kiểm tra Độ dài (Phải từ 6 đến 39 ký tự)
            else if (tenLoai.length() <= 5 || tenLoai.length() >= 40) {
                errorMsg = "Tên loại phải trên 5 và dưới 40 ký tự!";
            }
        }

        // Nếu có bất kỳ lỗi nào ở trên, quay xe ngay lập tức
        if (errorMsg != null) {
            req.getSession().setAttribute("error", errorMsg);
            // Kiểm tra nếu là action update thì gửi thêm id và action về URL
            if ("update".equals(action)) {
                resp.sendRedirect("loai-thuoc?action=edit&id=" + idStr);
            } else {
                resp.sendRedirect("loai-thuoc");
            }
            return;
        }

        try {
            if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                LoaiThuoc lt = new LoaiThuoc(id, tenLoai, trangThai);
                repo.update(lt);
            } else if ("insert".equals(action)) {
                LoaiThuoc lt = new LoaiThuoc();
                lt.setTenLoai(tenLoai);
                lt.setTrangThai(trangThai);
                repo.add(lt);
            }
            resp.sendRedirect("loai-thuoc");
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi thao tác dữ liệu!");
            resp.sendRedirect("loai-thuoc");
        }
    }
}