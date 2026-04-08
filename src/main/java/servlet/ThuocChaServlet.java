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

                // 1. Kiểm tra ràng buộc
                if (chaRepo.isThuocDaCoLo(id)) {
                    // Chuyển hướng về trang danh sách kèm mã lỗi và DỪNG LUÔN
                    resp.sendRedirect(req.getContextPath() + "/thuoc?error=has_lots");
                    return;
                }

                // 2. Nếu không vướng lô hàng thì mới xóa
                chaRepo.deleteById(id);

                // 3. Chuyển hướng báo thành công và DỪNG LUÔN
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
        try {
            String action = req.getParameter("action");
            String tenThuoc = req.getParameter("tenThuoc");
            Integer loai = Integer.parseInt(req.getParameter("loai"));
            Integer donVi = Integer.parseInt(req.getParameter("donVi"));
            Double giaBan = Double.parseDouble(req.getParameter("giaBan"));
            Boolean tinhTrang = Boolean.parseBoolean(req.getParameter("tinhTrang"));

            if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                ThuocCha tc = new ThuocCha(id, tenThuoc, loai, donVi, giaBan, tinhTrang);
                chaRepo.update(tc);
            } else if ("add".equals(action)) {
                ThuocCha tc = new ThuocCha(tenThuoc, loai, donVi, giaBan, tinhTrang);
                chaRepo.add(tc);
            }
            resp.sendRedirect("thuoc?msg=success");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("thuoc?error=post");
        }
    }
}