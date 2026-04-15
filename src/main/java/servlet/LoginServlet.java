package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

import repository.UserRepository;
import model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserRepository repository = new UserRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String savedUsername = "";
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("username".equals(cookie.getName())) {
                    savedUsername = cookie.getValue();
                    break;
                }
            }
        }
        req.setAttribute("savedUsername", savedUsername);
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String tenDangNhap = req.getParameter("username");
        String matKhau = req.getParameter("password");
        // 1. Lấy user từ database
        User user = repository.login(tenDangNhap, matKhau);
        if (user != null) {
            // 2. KIỂM TRA TRẠNG THÁI: Nếu bị khóa (false/0) thì không cho vào
            if (!user.isTrangThai()) {
                req.setAttribute("error", "Tài khoản của bạn đã bị khóa bởi quản trị viên!");
                req.setAttribute("savedUsername", tenDangNhap);
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
                return; // Dừng lại ở đây, không thực hiện các lệnh bên dưới
            }
            // 3. Nếu còn hoạt động (true/1) thì mới tạo session và redirect
            Cookie userCookie = new Cookie("username", tenDangNhap);
            userCookie.setMaxAge(60 * 60 * 24 * 7);
            resp.addCookie(userCookie);
            HttpSession session = req.getSession();
            session.setAttribute("currentUser", user);
            resp.sendRedirect(req.getContextPath() + "/kho");
        } else {
            // Sai tài khoản hoặc mật khẩu
            req.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng.");
            req.setAttribute("savedUsername", tenDangNhap);
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        }
    }
}