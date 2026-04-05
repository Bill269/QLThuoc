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
        String tenLoai = req.getParameter("tenLoai");
        Boolean trangThai = Boolean.parseBoolean(req.getParameter("trangThai"));

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