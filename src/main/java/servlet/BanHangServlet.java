package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.GioHangItem;
import model.Thuoc;
import model.User;
import repository.HoaDonRepository;
import repository.ThuocRepository;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet("/ban-hang")
public class BanHangServlet extends HttpServlet {
    private final ThuocRepository repo = new ThuocRepository();
    private final HoaDonRepository hdRepo = new HoaDonRepository();

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
                int id = (req.getParameter("id") != null) ? Integer.parseInt(req.getParameter("id")) : -1;

                switch (action) {
                    case "add":
                        if (cart.containsKey(id)) {
                            GioHangItem item = cart.get(id);
                            if (item.getSoLuong() < item.getThuoc().getSoLuongTon()) {
                                updateItem(item, item.getSoLuong() + 1);
                            }
                        } else {
                            Thuoc t = repo.getById(id);
                            if (t != null && t.getSoLuongTon() > 0) {
                                cart.put(id, new GioHangItem(t, 1));
                            }
                        }
                        break;

                    case "update":
                        int num = Integer.parseInt(req.getParameter("num"));
                        if (cart.containsKey(id)) {
                            GioHangItem item = cart.get(id);
                            int newQty = item.getSoLuong() + num;
                            processQuantity(cart, id, item, newQty, session);
                        }
                        break;

                    case "setQty": // Xử lý từ ô input trực tiếp
                        int inputQty = Integer.parseInt(req.getParameter("num"));
                        if (cart.containsKey(id)) {
                            GioHangItem item = cart.get(id);
                            processQuantity(cart, id, item, inputQty, session);
                        }
                        break;

                    case "remove":
                        cart.remove(id);
                        break;

                    case "clear":
                        cart.clear();
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

        if (session.getAttribute("message") != null) {
            req.setAttribute("message", session.getAttribute("message"));
            req.setAttribute("messageType", session.getAttribute("messageType"));
            session.removeAttribute("message");
        }

        req.getRequestDispatcher("/WEB-INF/views/ban-hang.jsp").forward(req, resp);
    }

    // Hàm hỗ trợ cập nhật số lượng và thành tiền
    private void updateItem(GioHangItem item, int qty) {
        item.setSoLuong(qty);
        item.setThanhTien(qty * item.getThuoc().getThuocCha().getGiaBanMacDinh());
    }

    // Hàm kiểm tra logic tồn kho
    private void processQuantity(Map<Integer, GioHangItem> cart, int id, GioHangItem item, int qty, HttpSession session) {
        if (qty < 1) {
            cart.remove(id);
        } else if (qty <= item.getThuoc().getSoLuongTon()) {
            updateItem(item, qty);
        } else {
            session.setAttribute("message", "Kho chỉ còn " + item.getThuoc().getSoLuongTon() + " sản phẩm!");
            session.setAttribute("messageType", "warning");
            updateItem(item, item.getThuoc().getSoLuongTon());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        Map<Integer, GioHangItem> cart = (Map<Integer, GioHangItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            session.setAttribute("message", "Giỏ hàng trống!");
            session.setAttribute("messageType", "danger");
            resp.sendRedirect("ban-hang");
            return;
        }
        // 1. Lấy dữ liệu
        String tenKH = req.getParameter("tenKhachHang") != null ? req.getParameter("tenKhachHang").trim() : "";
        String sdt = req.getParameter("soDienThoai") != null ? req.getParameter("soDienThoai").trim() : "";
        String email = req.getParameter("email") != null ? req.getParameter("email").trim() : "";
        String diaChi = req.getParameter("diaChi") != null ? req.getParameter("diaChi").trim() : "";
        // 2. Định nghĩa Regex
        String nameRegex = "^[a-zA-ZÀ-ỹ\\sĐđ]+$";
        String phoneRegex = "^[0-9]{10,11}$";
        String emailRegex = "^[a-z0-9._%+-]+@gmail\\.com$";
        // Regex địa chỉ: Chỉ cho phép chữ, số, dấu phẩy, chấm, gạch ngang, xẹt. KHÔNG CÓ @
        String addressRegex = "^[a-zA-Z0-9À-ỹ\\sĐđ,./\\-]+$";

        // 3. Kiểm tra logic (Backend Validation)
        if (!tenKH.matches(nameRegex)) {
            session.setAttribute("message", "Tên không hợp lệ (không chứa số/@/!)");
            session.setAttribute("messageType", "warning");
            resp.sendRedirect("ban-hang");
            return;
        }
        if (!sdt.matches(phoneRegex)) {
            session.setAttribute("message", "SĐT phải là 10-11 chữ số!");
            session.setAttribute("messageType", "warning");
            resp.sendRedirect("ban-hang");
            return;
        }
        if (!email.isEmpty() && !email.matches(emailRegex)) {
            session.setAttribute("message", "Chỉ chấp nhận Email @gmail.com!");
            session.setAttribute("messageType", "warning");
            resp.sendRedirect("ban-hang");
            return;
        }
        if (diaChi.isEmpty() || !diaChi.matches(addressRegex)) {
            session.setAttribute("message", "Địa chỉ chứa ký tự không cho phép (@, !, #...)");
            session.setAttribute("messageType", "danger");
            resp.sendRedirect("ban-hang");
            return;
        }
        // 4. Lưu Database
        try {
            User user = (User) session.getAttribute("currentUser");
            int userId = (user != null) ? user.getId() : 1;
            int idHD = hdRepo.createHoaDon(userId, tenKH, sdt, email, diaChi);
            if (idHD > 0) {
                for (GioHangItem item : cart.values()) {
                    hdRepo.addChiTiet(idHD, item.getThuoc().getId(), item.getSoLuong(), item.getThuoc().getThuocCha().getGiaBanMacDinh());
                }
                session.setAttribute("message", "Thanh toán thành công!");
                session.setAttribute("messageType", "success");
                cart.clear();
            }
        } catch (Exception e) {
            session.setAttribute("message", "Lỗi: " + e.getMessage());
            session.setAttribute("messageType", "danger");
        }
        resp.sendRedirect("ban-hang");
    }
}