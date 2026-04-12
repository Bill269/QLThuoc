package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.GioHangItem;
import model.Thuoc;
import model.User;
import repository.ThuocRepository;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet("/ban-hang")
public class BanHangServlet extends HttpServlet {
    private final ThuocRepository repo = new ThuocRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession();

        // 1. Khởi tạo giỏ hàng
        Map<Integer, GioHangItem> cart = (Map<Integer, GioHangItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new LinkedHashMap<>();
            session.setAttribute("cart", cart);
        }

        // 2. Xử lý các hành động (Action)
        if (action != null) {
            try {
                switch (action) {
                    case "add":
                        int idAdd = Integer.parseInt(req.getParameter("id"));
                        if (cart.containsKey(idAdd)) {
                            GioHangItem item = cart.get(idAdd);
                            // Chỉ cho tăng nếu chưa vượt quá tồn kho
                            if (item.getSoLuong() < item.getThuoc().getSoLuongTon()) {
                                item.setSoLuong(item.getSoLuong() + 1);
                                item.setThanhTien(item.getSoLuong() * item.getThuoc().getThuocCha().getGiaBanMacDinh());
                            }
                        } else {
                            Thuoc t = repo.getById(idAdd);
                            if (t != null && t.getSoLuongTon() > 0) {
                                cart.put(idAdd, new GioHangItem(t, 1));
                            }
                        }
                        break;

                    case "update":
                        int idUp = Integer.parseInt(req.getParameter("id"));
                        int num = Integer.parseInt(req.getParameter("num"));
                        if (cart.containsKey(idUp)) {
                            GioHangItem item = cart.get(idUp);
                            int newQty = item.getSoLuong() + num;

                            if (newQty < 1) {
                                cart.remove(idUp);
                            } else if (newQty <= item.getThuoc().getSoLuongTon()) {
                                item.setSoLuong(newQty);
                                item.setThanhTien(newQty * item.getThuoc().getThuocCha().getGiaBanMacDinh());
                            } else {
                                session.setAttribute("message", "Kho chỉ còn " + item.getThuoc().getSoLuongTon() + " sản phẩm!");
                                session.setAttribute("messageType", "warning");
                            }
                        }
                        break;

                    case "remove":
                        int idRem = Integer.parseInt(req.getParameter("id"));
                        cart.remove(idRem);
                        break;

                    case "clear":
                        cart.clear(); // Làm trống thay vì remove session để giữ lại object cart
                        break;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect("ban-hang");
            return;
        }

        // 3. Hiển thị dữ liệu
        String search = req.getParameter("txtSearch");
        req.setAttribute("listThuoc", repo.getThuocDangConHang(search == null ? "" : search));
        req.setAttribute("lastSearch", search);

        // Hiển thị thông báo (nếu có)
        if (session.getAttribute("message") != null) {
            req.setAttribute("message", session.getAttribute("message"));
            req.setAttribute("messageType", session.getAttribute("messageType"));
            session.removeAttribute("message");
        }

        req.getRequestDispatcher("/WEB-INF/views/ban-hang.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        Map<Integer, GioHangItem> cart = (Map<Integer, GioHangItem>) session.getAttribute("cart");

        if (cart != null && !cart.isEmpty()) {
            try {
                User user = (User) session.getAttribute("currentUser");
                int userId = (user != null) ? user.getId() : 1; // Default về admin nếu chưa login

                repo.thanhToan(cart, userId);

                session.setAttribute("message", "Thanh toán thành công!");
                session.setAttribute("messageType", "success");
                cart.clear(); // Xóa giỏ sau khi bán
            } catch (Exception e) {
                session.setAttribute("message", "Lỗi: " + e.getMessage());
                session.setAttribute("messageType", "danger");
            }
        }
        resp.sendRedirect("ban-hang");
    }
}