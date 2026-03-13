<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="currentUser" value="${sessionScope.currentUser}"/>

<div class="sidebar">
    <h2>Quản Lý Thuốc</h2>

    <a href="<%= request.getContextPath() %>/thuoc"
       class="sidebar-link ${fn:endsWith(request.getRequestURI(), '/thuoc') || fn:endsWith(request.getRequestURI(), '/') ? 'active' : ''}">
        <i class="fas fa-pills"></i> <span>Quản Lý Thuốc</span>
    </a>

    <c:if test="${currentUser.nhomQuyen eq 'ADMIN'}">
        <a href="<%= request.getContextPath() %>/add"
           class="sidebar-link ${fn:endsWith(request.getRequestURI(), '/add') ? 'active' : ''}">
            <i class="fas fa-plus"></i> <span>Thêm Thuốc</span>
        </a>
        <a href="<%= request.getContextPath() %>/users"
           class="sidebar-link ${fn:contains(request.getRequestURI(), '/users') ? 'active' : ''}">
            <i class="fas fa-users-cog"></i> <span>Quản Lý Tài Khoản</span>
        </a>
        <a href="<%= request.getContextPath() %>/send-email"
           class="sidebar-link ${fn:endsWith(request.getRequestURI(), '/send-email') ? 'active' : ''}">
            <i class="fas fa-envelope"></i> <span>Gửi Email</span>
        </a>
    </c:if>
    <a href="<%= request.getContextPath() %>/logout" class="logout-link-sidebar">
        <i class="fas fa-sign-out-alt"></i> Đăng xuất
    </a>
</div>