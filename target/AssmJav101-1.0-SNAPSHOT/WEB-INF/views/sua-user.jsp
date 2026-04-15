<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="fragment/header.jsp" %>

<div style="padding: 50px; display: flex; justify-content: center; background-color: #f4f7f6; min-height: 80vh;">
    <div style="background: white; padding: 35px; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); width: 100%; max-width: 480px;">

        <div style="text-align: center; margin-bottom: 25px;">
            <h3 style="color: #2c3e50; margin: 0; font-size: 1.5em;">
                <i class="fas fa-user-edit"></i> Cập nhật tài khoản
            </h3>
            <p style="color: #7f8c8d; font-size: 0.9em;">Chỉnh sửa thông tin người dùng</p>
        </div>

        <form action="users" method="post">
            <input type="hidden" name="userId" value="${userToEdit.id}">

            <div style="margin-bottom: 18px;">
                <label style="display: block; font-weight: 600; color: #444; margin-bottom: 8px;">Tên đăng nhập</label>
                <input type="text" value="${userToEdit.tenDangNhap}" readonly
                       style="width:100%; padding:12px; border:1px solid #eee; border-radius:8px; background-color: #f9f9f9; color: #777; cursor: not-allowed;">
                <input type="hidden" name="username" value="${userToEdit.tenDangNhap}">
            </div>

            <div style="margin-bottom: 18px;">
                <label style="display: block; font-weight: 600; color: #444; margin-bottom: 8px;">Mật khẩu</label>
                <input type="password" name="password" id="passwordEdit" value="${userToEdit.matKhau}" required
                       minlength="5"
                       maxlength="10"
                       oninvalid="this.setCustomValidity('Mật khẩu phải từ 3 ký tự trở lên')"
                       oninput="this.setCustomValidity('')"
                       style="width:100%; padding:12px; border:1px solid #dcdde1; border-radius:8px; outline: none;">
            </div>

            <div style="margin-bottom: 18px;">
                <label style="display: block; font-weight: 600; color: #444; margin-bottom: 8px;">Trạng thái tài khoản</label>
                <select name="trangThai"
                        style="width:100%; padding:12px; border:1px solid #dcdde1; border-radius:8px; background: white; cursor: pointer;"
                ${userToEdit.nhomQuyen eq 'ADMIN' ? 'disabled' : ''}>
                    <option value="1" ${userToEdit.trangThai ? 'selected' : ''}>Đang hoạt động</option>
                    <option value="0" ${!userToEdit.trangThai ? 'selected' : ''}>Khóa tài khoản</option>
                </select>
                <c:if test="${userToEdit.nhomQuyen eq 'ADMIN'}">
                    <input type="hidden" name="trangThai" value="1">
                </c:if>
            </div>

            <div style="margin-bottom: 30px;">
                <label style="display: block; font-weight: 600; color: #444; margin-bottom: 8px;">Quyền hạn hệ thống</label>
                <div style="width:100%; padding:12px; border:1px solid #eee; border-radius:8px; background-color: #f9f9f9; color: #2c3e50; font-weight: bold;">
                    <c:choose>
                        <c:when test="${userToEdit.nhomQuyen eq 'ADMIN'}">
                            <i class="fas fa-user-shield" style="color: #e74c3c;"></i> QUẢN TRỊ VIÊN (ADMIN)
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-user" style="color: #3498db;"></i> NHÂN VIÊN (USER)
                        </c:otherwise>
                    </c:choose>
                </div>
                <input type="hidden" name="role" value="${userToEdit.nhomQuyen}">
            </div>

            <button type="submit"
                    style="width:100%; padding:14px; background: #2c3e50; color: white; border: none; border-radius: 8px; cursor: pointer; font-weight: bold; font-size: 1em; transition: 0.3s;"
                    onmouseover="this.style.background='#34495e'"
                    onmouseout="this.style.background='#2c3e50'">
                Xác Nhận Cập Nhật
            </button>

            <div style="text-align: center; margin-top: 15px;">
                <a href="users" style="color: #7f8c8d; text-decoration: none; font-size: 0.9em;">
                    <i class="fas fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>
        </form>
    </div>
</div>

<input type="hidden" name="isUpdate" value="true">

<script>
    window.onload = function() {
        var errorMsg = "${error}";
        if (errorMsg !== "") {
            // Hiển thị bong bóng lỗi từ server nếu có
            var input = document.getElementById("passwordEdit");
            if (input) {
                input.setCustomValidity(errorMsg);
                input.reportValidity();
                input.oninput = function() {
                    this.setCustomValidity("");
                };
            }
        }
    };

    // Chặn submit nếu form không hợp lệ (Trình duyệt tự xử lý dựa trên required/minlength)
    document.getElementById("editUserForm").onsubmit = function(e) {
        // Form sẽ tự chặn load trang và hiện bong bóng nếu mật khẩu < 6 ký tự
    };
</script>

<%@ include file="fragment/footer.jsp" %>