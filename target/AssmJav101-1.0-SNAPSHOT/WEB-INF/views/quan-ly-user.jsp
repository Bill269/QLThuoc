<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ include file="fragment/header.jsp" %>

<div style="padding: 30px; max-width: 1200px; margin: 0 auto; width: 100%;">

    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; border-bottom: 2px solid var(--secondary-blue); padding-bottom: 15px;">
        <h2 style="color: var(--primary-dark); margin: 0;">
            <i class="fas fa-users-cog"></i> Quản Lý Tài Khoản Hệ Thống
        </h2>
    </div>

    <div style="background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); margin-bottom: 30px;">
        <h4 style="margin-top: 0; margin-bottom: 20px; color: #555; font-size: 1.1em;">
            <i class="fas fa-user-plus"></i> Tạo tài khoản mới
        </h4>
        <form action="users" method="post" style="display: grid; grid-template-columns: 1fr 1fr 1fr auto; gap: 15px; align-items: end;">
            <input type="hidden" name="isUpdate" value="false">

            <div>
                <label style="display:block; font-size: 0.85em; font-weight: 600; color: #666; margin-bottom: 8px;">Tên đăng nhập</label>
                <input type="text" name="username" id="usernameAdd" value="${oldUsername}"
                       placeholder="Nhập tên đăng nhập..." required
                       minlength="5"
                       maxlength="10"
                       pattern="^[a-zA-Z0-9]+$"
                       oninput="this.setCustomValidity('')"
                       style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; outline: none;">
            </div>

            <div>
                <label style="display:block; font-size: 0.85em; font-weight: 600; color: #666; margin-bottom: 8px;">Mật khẩu</label>
                <input type="password" name="password" id="passwordAdd" value="${oldPassword}"
                       placeholder="Nhập mật khẩu..." required
                       minlength="3"
                       maxlength="6"
                       oninput="this.setCustomValidity('')"
                       style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; outline: none;">
            </div>

            <div>
                <label style="display:block; font-size: 0.85em; font-weight: 600; color: #666; margin-bottom: 8px;">Nhóm quyền</label>
                <select disabled style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; background: #f5f5f5; color: #888; cursor: not-allowed;">
                    <option value="USER" selected>USER (Người dùng)</option>
                    <option value="ADMIN">ADMIN (Quản trị)</option>
                </select>
                <input type="hidden" name="role" value="USER">
            </div>

            <button type="submit" style="background: var(--primary-dark); color: white; border: none; padding: 10px 25px; border-radius: 6px; font-weight: bold; cursor: pointer; transition: 0.3s;">
                <i class="fas fa-plus"></i> Thêm mới
            </button>
        </form>
    </div>

    <div style="background: white; padding: 15px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); margin-bottom: 25px;">
        <form action="users" method="get" style="display: flex; gap: 10px; align-items: center;">
            <input type="hidden" name="action" value="list">
            <div style="flex-grow: 1; position: relative;">
                <i class="fas fa-search" style="position: absolute; left: 15px; top: 12px; color: #aaa;"></i>
                <input type="text" name="txtSearch" value="${lastSearch}"
                       placeholder="Tìm kiếm theo tên tài khoản..."
                       style="width: 100%; padding: 10px 10px 10px 40px; border: 1px solid #ddd; border-radius: 8px; outline: none;">
            </div>
            <button type="submit" style="background: #3498db; color: white; border: none; padding: 10px 25px; border-radius: 8px; cursor: pointer; font-weight: 600;">
                Tìm kiếm
            </button>
            <a href="users" style="text-decoration: none; color: #666; background: #eee; padding: 10px 15px; border-radius: 8px; font-size: 0.9em;">Xóa lọc</a>
        </form>
    </div>

    <div style="background: white; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); overflow: hidden;">
        <table style="width: 100%; border-collapse: collapse; min-width: 600px;">
            <thead>
            <tr style="background: var(--primary-dark); color: white; text-align: left;">
                <th style="padding: 15px 20px;">Tên đăng nhập</th>
                <th style="padding: 15px 20px;">Quyền hạn</th>
                <th style="padding: 15px 20px;">Trạng thái</th>
                <th style="padding: 15px 20px; text-align: center;">Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="u" items="${userList}">
                <tr style="border-bottom: 1px solid #eee; transition: 0.2s;" onmouseover="this.style.backgroundColor='#f8f9fa'" onmouseout="this.style.backgroundColor='transparent'">
                    <td style="padding: 15px 20px; font-weight: 500; color: #333;">
                        <i class="far fa-user-circle" style="margin-right: 8px; color: #999;"></i>${u.tenDangNhap}
                    </td>
                    <td style="padding: 15px 20px;">
                        <c:choose>
                            <c:when test="${u.nhomQuyen eq 'ADMIN'}">
                                <span style="background: #fff0f0; color: #e74c3c; padding: 5px 12px; border-radius: 20px; font-size: 0.8em; font-weight: bold; border: 1px solid #ffdada;">
                                    ADMIN
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span style="background: #e3f2fd; color: #1976d2; padding: 5px 12px; border-radius: 20px; font-size: 0.8em; font-weight: bold; border: 1px solid #bbdefb;">
                                    USER
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td style="padding: 15px 20px;">
                        <c:choose>
                            <c:when test="${u.trangThai}">
                                <span style="color: #27ae60; font-weight: 600;">
                                    <i class="fas fa-check-circle"></i> Hoạt động
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: #e74c3c; font-weight: 600;">
                                    <i class="fas fa-lock"></i> Đã khóa
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td style="padding: 15px 20px; text-align: center;">
                        <div style="display: flex; justify-content: center; gap: 10px;">
                            <a href="users?action=edit&id=${u.id}"
                               style="background: #fff8e1; color: #f57f17; padding: 7px 14px; border: 1px solid #ffecb3; border-radius: 6px; text-decoration: none; font-size: 0.85em; font-weight: 600; transition: 0.2s;">
                                <i class="fas fa-edit"></i> Sửa
                            </a>

                            <c:choose>
                                <c:when test="${u.tenDangNhap eq currentUser.tenDangNhap}">
                                    <span style="color: #bbb; font-size: 0.85em; font-style: italic; padding: 7px;">
                                        (Đang dùng)
                                    </span>
                                </c:when>
                                <c:when test="${u.nhomQuyen eq 'ADMIN'}">
                                    <span style="color: #bbb; font-size: 0.85em; font-style: italic; padding: 7px;">
                                        (Hệ thống)
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <a href="users?action=delete&id=${u.id}"
                                       onclick="return confirm('Bạn có chắc chắn muốn xóa tài khoản ${u.tenDangNhap}?')"
                                       style="background: #fff5f5; color: #e74c3c; padding: 7px 14px; border: 1px solid #ffcccc; border-radius: 6px; text-decoration: none; font-size: 0.85em; font-weight: 600; transition: 0.2s;">
                                        <i class="fas fa-trash-alt"></i> Xóa
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty userList}">
                <tr>
                    <td colspan="4" style="text-align: center; padding: 40px; color: #999;">
                        Không tìm thấy tài khoản nào phù hợp.
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>


<script>
    window.onload = function() {
        var userInp = document.getElementById("usernameAdd");
        var passInp = document.getElementById("passwordAdd");

        // 1. Tự định nghĩa câu thông báo tiếng Việt khi gõ sai định dạng (Client-side)
        userInp.oninvalid = function() {
            if (this.validity.valueMissing) {
                this.setCustomValidity("Vui lòng nhập tên đăng nhập!");
            } else if (this.validity.patternMismatch) {
                this.setCustomValidity("Tên từ 5-10 ký tự, không chứa ký tự đặc biệt!");
            }
        };

        passInp.oninvalid = function() {
            if (this.validity.valueMissing) {
                this.setCustomValidity("Vui lòng nhập mật khẩu!");
            } else if (this.validity.tooShort) {
                this.setCustomValidity("Mật khẩu phải có ít nhất 3 ký tự!");
            }
        };

        // 2. Hiển thị lỗi từ SERVER (Ví dụ: "Tên đăng nhập này đã tồn tại!")
        var serverError = "${error}";
        if (serverError !== "") {
            // Xác định hiện bong bóng ở ô nào dựa trên nội dung lỗi
            var targetInput = serverError.includes("Mật khẩu") ? passInp : userInp;

            if (targetInput) {
                // Gán lỗi từ server vào bong bóng và ép nó hiện lên
                targetInput.setCustomValidity(serverError);
                targetInput.reportValidity();
            }
        }
    };
</script>

<%@ include file="fragment/footer.jsp" %>