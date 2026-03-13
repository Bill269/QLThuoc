<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="fragment/header.jsp" %>

<div style="padding: 50px; display: flex; justify-content: center;">
    <div style="background: white; padding: 30px; border-radius: 12px; box-shadow: 0 5px 25px rgba(0,0,0,0.1); width: 450px;">
        <h3>Cập nhật tài khoản</h3>
        <form action="users" method="post">
            <input type="hidden" name="userId" value="${userToEdit.id}">

            <div style="margin-bottom: 15px;">
                <label>Tên đăng nhập (Có thể sửa)</label>
                <input type="text" name="username" value="${userToEdit.tenDangNhap}" required style="width:100%; padding:10px; border:1px solid #ddd; border-radius:6px;">
            </div>
            <div style="margin-bottom: 15px;">
                <label>Mật khẩu</label>
                <input type="password" name="password" value="${userToEdit.matKhau}" required style="width:100%; padding:10px; border:1px solid #ddd; border-radius:6px;">
            </div>
            <div style="margin-bottom: 25px;">
                <label>Quyền</label>
                <select name="role" style="width:100%; padding:10px; border:1px solid #ddd; border-radius:6px;">
                    <option value="USER" ${userToEdit.nhomQuyen eq 'USER' ? 'selected' : ''}>USER</option>
                    <option value="ADMIN" ${userToEdit.nhomQuyen eq 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                </select>
            </div>
            <button type="submit" style="width:100%; padding:12px; background:var(--secondary-blue); color:white; border:none; border-radius:6px; cursor:pointer; font-weight:bold;">Lưu thay đổi</button>
        </form>
    </div>
</div>
<%@ include file="fragment/footer.jsp" %>