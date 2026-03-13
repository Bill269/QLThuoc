<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 1. Gọi Header chung của hệ thống --%>
<%@ include file="fragment/header.jsp" %>

<div class="table-container" style="margin: 20px; padding: 20px; background: white; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">

    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid var(--secondary-blue); padding-bottom: 10px;">
        <h2 style="color: var(--primary-dark); margin: 0;">
            <i class="fas fa-users-cog"></i> Quản Lý Tài Khoản Hệ Thống
        </h2>
    </div>

    <table style="width: 100%; border-collapse: collapse; margin-top: 10px;">
        <thead>
        <tr style="background-color: var(--primary-dark); color: white; text-align: left;">
            <th style="padding: 15px; border-top-left-radius: 8px;">Tên đăng nhập</th>
            <th style="padding: 15px;">Mật khẩu</th>
            <th style="padding: 15px;">Nhóm quyền</th>
            <th style="padding: 15px; border-top-right-radius: 8px; text-align: center;">Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="user" items="${dsNguoiDung}">
            <tr style="border-bottom: 1px solid #eee; transition: background 0.3s;" onmouseover="this.style.backgroundColor='#f9f9f9'" onmouseout="this.style.backgroundColor='transparent'">
                <td style="padding: 15px; font-weight: bold; color: #333;">${user.tenDangNhap}</td>
                <td style="padding: 15px; color: #777;">•••••••• (Đã bảo mật)</td>
                <td style="padding: 15px;">
                    <c:choose>
                        <c:when test="${user.nhomQuyen eq 'ADMIN'}">
                            <span style="background: #ebf5ff; color: #2980b9; padding: 5px 12px; border-radius: 15px; font-size: 0.85em; font-weight: bold; border: 1px solid #bddcf5;">ADMIN</span>
                        </c:when>
                        <c:otherwise>
                            <span style="background: #f0f0f0; color: #666; padding: 5px 12px; border-radius: 15px; font-size: 0.85em; font-weight: bold;">USER</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td style="padding: 15px; text-align: center;">
                    <a href="edit-user?username=${user.tenDangNhap}" style="color: var(--secondary-blue); text-decoration: none; margin-right: 15px;">
                        <i class="fas fa-edit"></i> Sửa
                    </a>
                    <c:if test="${user.tenDangNhap ne currentUser.tenDangNhap}">
                        <a href="delete-user?username=${user.tenDangNhap}" style="color: var(--danger); text-decoration: none;" onclick="return confirm('Xóa tài khoản này?')">
                            <i class="fas fa-trash"></i> Xóa
                        </a>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<%-- 3. Gọi Footer --%>
<%@ include file="fragment/footer.jsp" %>