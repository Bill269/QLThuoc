package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.LoaiThuoc;
import model.Thuoc;
import model.User;
import repository.LoaiThuocRepository;
import repository.ThuocRepository;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/thuoc")
public class ThuocServlet extends HttpServlet {
    private final ThuocRepository repository = new ThuocRepository();
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    private final LoaiThuocRepository loaiRepo = new LoaiThuocRepository();

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
            resp.sendRedirect("thuoc");
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
            resp.sendRedirect("thuoc?error=post_failed");
        }
    }

    private void listThuoc(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String txtSearch = req.getParameter("txtSearch");
        String selLoai = req.getParameter("selLoai");

        List<Thuoc> list = repository.searchThuoc(txtSearch, selLoai);

        req.setAttribute("listThuoc", list);

        req.setAttribute("totalAmount", repository.getTotalStock());
        req.setAttribute("warningCount", repository.countWarning());
        req.setAttribute("expiredCount", repository.countExpired());

        req.setAttribute("listLoai", loaiRepo.getAll());
        req.setAttribute("lastSearch", txtSearch);
        req.setAttribute("lastLoai", selLoai);

        req.getRequestDispatcher("/WEB-INF/views/danh-sach-thuoc.jsp").forward(req, resp);
    }

    private void showAddForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        List<LoaiThuoc> listLoai = loaiRepo.getAll();
        req.setAttribute("listLoai", listLoai);
        req.getRequestDispatcher("/WEB-INF/views/them-thuoc.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        req.setAttribute("thuocToEdit", repository.getById(id));

        List<LoaiThuoc> listLoai = loaiRepo.getAll();
        req.setAttribute("listLoai", listLoai);
        req.getRequestDispatcher("/WEB-INF/views/sua-thuoc.jsp").forward(req, resp);
    }

    private void showDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        req.setAttribute("thuoc", repository.getById(id));
        req.getRequestDispatcher("/WEB-INF/views/chi-tiet-thuoc.jsp").forward(req, resp);
    }

    private void deleteThuoc(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));
        repository.delete(id);
        resp.sendRedirect("thuoc");
    }

    private void insertThuoc(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String ten = req.getParameter("ten");
        String loai = req.getParameter("loai");
        int soLuong = Integer.parseInt(req.getParameter("soLuong"));
        Date hanSD = dateFormat.parse(req.getParameter("hanSuDung"));

        repository.add(new Thuoc(ten, loai, soLuong, hanSD));
        resp.sendRedirect("thuoc");
    }

    private void updateThuoc(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));
        String ten = req.getParameter("ten");
        String loai = req.getParameter("loai");
        int soLuong = Integer.parseInt(req.getParameter("soLuong"));
        Date hanSD = dateFormat.parse(req.getParameter("hanSuDung"));

        repository.update(new Thuoc(id, ten, loai, soLuong, hanSD));
        resp.sendRedirect("thuoc");
    }


}