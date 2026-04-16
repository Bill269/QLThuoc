package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import repository.UserRepository;
import java.io.IOException;
import java.util.List;

@WebServlet("/users")
public class UserServlet extends HttpServlet {
    UserRepository repo = new UserRepository();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String idStr = req.getParameter("id");
        String txtSearch = req.getParameter("txtSearch");
        try {
            if (idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);
                if ("delete".equals(action)) {
                    repo.delete(id);
                    resp.sendRedirect("users");
                    return;
                }
                if ("edit".equals(action)) {
                    User user = repo.getById(id);
                    if (user != null) {
                        req.setAttribute("userToEdit", user);
                        req.getRequestDispatcher("/WEB-INF/views/sua-user.jsp").forward(req, resp);
                        return;
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        List<User> userList = repo.searchUsers(txtSearch);
        req.setAttribute("userList", userList);
        req.setAttribute("lastSearch", txtSearch);
        req.getRequestDispatcher("/WEB-INF/views/quan-ly-user.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String idStr = req.getParameter("userId");
        String isUpdateParam = req.getParameter("isUpdate");
        String username = req.getParameter("username");
        String pass = req.getParameter("password");

        // Kiểm tra xem là hành động gì
        boolean isAdd = "false".equals(isUpdateParam);
        boolean isEdit = (idStr != null && !idStr.isEmpty());

        String error = null;
        String regex = "^[a-zA-Z0-9À-ỹ\\s]+$";

        // --- CHỈ VALIDATE KHI THÊM HOẶC SỬA ---
        if (isAdd || isEdit) {
            if (username == null || username.trim().isEmpty()) {
                error = "Tên đăng nhập không được để trống!";
            } else if (username.length() < 5 || username.length() > 10) {
                error = "Tên đăng nhập phải từ 5 đến 10 ký tự!";
            } else if (!username.matches(regex)) {
                error = "Tên không được chứa ký tự đặc biệt!";
            } else if (pass == null || pass.length() < 3) {
                error = "Mật khẩu phải có ít nhất 3 ký tự!";
            } else if (isAdd && repo.isUsernameExists(username)) {
                // Check trùng tên CHỈ khi thêm mới
                error = "Tên đăng nhập này đã tồn tại!";
            }

            // Nếu có lỗi validate, trả về ngay lập tức
            if (error != null) {
                req.setAttribute("error", error);
                req.setAttribute("oldUsername", username);
                req.setAttribute("oldPassword", pass);
                doGet(req, resp);
                return;
            }
        }

        // --- TRƯỜNG HỢP 1: CẬP NHẬT (UPDATE) --- (Giữ nguyên logic của bạn)
        if (isEdit) {
            try {
                int id = Integer.parseInt(idStr);
                String role = req.getParameter("role");
                String statusStr = req.getParameter("trangThai");
                boolean status = "1".equals(statusStr);
                User userUpdate = new User(id, username, pass, role, status);
                repo.save(userUpdate, true);
                resp.sendRedirect("users");
                return;
            } catch (Exception e) { e.printStackTrace(); }
        }

        // --- TRƯỜNG HỢP 2: THÊM MỚI (INSERT) --- (Giữ nguyên logic của bạn)
        if (isAdd) {
            try {
                String role = "USER";
                User newUser = new User(0, username, pass, role, true);
                repo.save(newUser, false);
                resp.sendRedirect("users");
                return;
            } catch (Exception e) { e.printStackTrace(); }
        }

        // --- TRƯỜNG HỢP 3: ĐĂNG NHẬP (LOGIN) ---
        String user = req.getParameter("username");
        String password = req.getParameter("password");
        User u = repo.login(user, password);
        if (u != null) {
            if (u.isTrangThai()) {
                HttpSession session = req.getSession();
                session.setAttribute("currentUser", u);
                resp.sendRedirect("users");
            } else {
                req.setAttribute("error", "Tài khoản của bạn đã bị khóa!");
                req.setAttribute("savedUsername", user);
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            }
        } else {
            req.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không chính xác!");
            req.setAttribute("savedUsername", user);
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }
}