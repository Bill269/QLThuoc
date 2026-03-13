<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: XPS 9380
  Date: 3/13/2026
  Time: 4:48 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%@ include file="fragment/header.jsp" %>
<div class="table-container">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
        <h2 style="color: var(--primary-dark);"><i class="fas fa-users-cog"></i> Quản Lý Tài Khoản</h2>
    </div>

    <div style="background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); margin-bottom: 25px;">
        <form action="users" method="post" style="display: grid; grid-template-columns: 1fr 1fr 1fr auto; gap: 15px; align-items: end;">
            <div>
                <label style="font-size: 0.8em; font-weight: bold; color: #666;">TÊN ĐĂNG NHẬP</label>
                <input type="text" name="username" required placeholder="Ví dụ: nhanvien01" style="margin:0;">
            </div>
            <div>
                <label style="font-size: 0.8em; font-weight: bold; color: #666;">MẬT KHẨU</label>
                <input type="password" name="password" required placeholder="••••••" style="margin:0;">
            </div>
            <div>
                <label style="font-size: 0.8em; font-weight: bold; color: #666;">QUYỀN HẠN</label>
                <select name="role" style="margin:0;">
                    <option value="USER">USER - Nhân viên</option>
                    <option value="ADMIN">ADMIN - Quản trị</option>
                </select>
            </div>
            <button type="submit" class="save-btn" style="margin:0; padding: 10px 25px; background: var(--secondary-blue);">
                <i class="fas fa-user-plus"></i> Thêm
            </button>
        </form>
    </div>

    <table class="medicine-table">
        <thead>
        <tr>
            <th>Tên đăng nhập</th>
            <th>Phân quyền</th>
            <th style="text-align: center;">Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="u" items="${userList}">
            <tr>
                <td style="font-weight: 600;">${u.tenDangNhap}</td>
                <td>
                        <span class="badge ${u.nhomQuyen eq 'ADMIN' ? 'bg-danger' : 'bg-info'}"
                              style="padding: 5px 10px; border-radius: 15px; font-size: 0.75em; color: white; background: ${u.nhomQuyen eq 'ADMIN' ? '#e74c3c' : '#3498db'};">
                                ${u.nhomQuyen}
                        </span>
                </td>
                <td style="text-align: center;">
                    <a href="users?action=delete&id=${u.tenDangNhap}"
                       onclick="return confirm('Xóa tài khoản ${u.tenDangNhap}?')"
                       class="action-link delete-link" style="color: #e74c3c; text-decoration: none;">
                        <i class="fas fa-trash-alt"></i> Xóa
                    </a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
<%@ include file="fragment/footer.jsp" %>
</body>
</html>
