<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- 1. GỌI HEADER --%>
<%@ include file="fragment/header.jsp" %>

<div style="padding: 30px; max-width: 1200px; margin: 0 auto; width: 100%;">

    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; border-bottom: 2px solid var(--secondary-blue); padding-bottom: 15px;">
        <h2 style="color: var(--primary-dark); margin: 0;">
            <i class="fas fa-users-cog"></i> Quản Lý Tài Khoản Hệ Thống
        </h2>
    </div>

    <%-- FORM TẠO MỚI (Gọn gàng trên 1 hàng) --%>
    <div style="background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); margin-bottom: 35px;">
        <h4 style="margin-top: 0; margin-bottom: 20px; color: #555; font-size: 1.1em;">
            <i class="fas fa-user-plus"></i> Tạo tài khoản mới
        </h4>
        <form action="users" method="post" style="display: grid; grid-template-columns: 1fr 1fr 1fr auto; gap: 15px; align-items: end;">
            <%-- Quan trọng: isUpdate = false vì đây là form thêm mới --%>
            <input type="hidden" name="isUpdate" value="false">

            <div>
                <label style="display:block; font-size: 0.85em; font-weight: 600; color: #666; margin-bottom: 8px;">Tên đăng nhập</label>
                <input type="text" name="username" placeholder="Nhập tên đăng nhập..." required
                       style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; outline: none;">
            </div>

            <div>
                <label style="display:block; font-size: 0.85em; font-weight: 600; color: #666; margin-bottom: 8px;">Mật khẩu</label>
                <input type="password" name="password" placeholder="Nhập mật khẩu..." required
                       style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; outline: none;">
            </div>

            <div>
                <label style="display:block; font-size: 0.85em; font-weight: 600; color: #666; margin-bottom: 8px;">Nhóm quyền</label>
                <select name="role" style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; background: white; cursor: pointer;">
                    <option value="USER">USER (Người dùng)</option>
                    <option value="ADMIN">ADMIN (Quản trị)</option>
                </select>
            </div>

            <button type="submit" style="background: var(--primary-dark); color: white; border: none; padding: 10px 25px; border-radius: 6px; font-weight: bold; cursor: pointer; transition: 0.3s;">
                <i class="fas fa-plus"></i> Thêm mới
            </button>
        </form>
    </div>

    <%-- BẢNG DANH SÁCH --%>
    <div style="background: white; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); overflow: hidden;">
        <table style="width: 100%; border-collapse: collapse; min-width: 600px;">
            <thead>
            <tr style="background: var(--primary-dark); color: white; text-align: left;">
                <th style="padding: 15px 20px;">Tên đăng nhập</th>
                <th style="padding: 15px 20px;">Quyền hạn</th>
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
                    <td style="padding: 15px 20px; text-align: center;">
                        <div style="display: flex; justify-content: center; gap: 10px;">

                                <%-- NÚT SỬA: Chuyển sang trang riêng --%>
                            <a href="users?action=edit&id=${u.id}"
                               style="background: #fff8e1; color: #f57f17; padding: 7px 14px; border: 1px solid #ffecb3; border-radius: 6px; text-decoration: none; font-size: 0.85em; font-weight: 600; transition: 0.2s;">
                                <i class="fas fa-edit"></i> Sửa
                            </a>

                                <%-- NÚT XÓA: Chỉ hiện nếu không phải tài khoản đang đăng nhập --%>
                            <c:if test="${u.tenDangNhap ne currentUser.tenDangNhap}">
                                <a href="users?action=delete&id=${u.tenDangNhap}"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa tài khoản ${u.tenDangNhap}?')"
                                   style="background: #fff5f5; color: #e74c3c; padding: 7px 14px; border: 1px solid #ffcccc; border-radius: 6px; text-decoration: none; font-size: 0.85em; font-weight: 600; transition: 0.2s;">
                                    <i class="fas fa-trash-alt"></i> Xóa
                                </a>
                            </c:if>

                            <c:if test="${u.tenDangNhap eq currentUser.tenDangNhap}">
                                <span style="color: #bbb; font-size: 0.85em; font-style: italic; padding: 7px;">
                                    (Đang dùng)
                                </span>
                            </c:if>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<%-- 3. GỌI FOOTER --%>
<%@ include file="fragment/footer.jsp" %>