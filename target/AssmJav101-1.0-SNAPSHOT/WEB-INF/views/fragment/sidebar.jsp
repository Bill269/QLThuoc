<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
    #sidebar {
        width: 250px;
        background: var(--sidebar-bg);
        color: #fff;
        transition: all 0.3s;
        display: flex;
        flex-direction: column;
        z-index: 1000;
    }


    #sidebar.collapsed {
        width: 80px;
    }

    #sidebar .sidebar-header {
        padding: 20px;
        background: #2c3136;
        text-align: center;
        white-space: nowrap;
        overflow: hidden;
    }

    #sidebar.collapsed .sidebar-header h2 {
        display: none;
    }

    .sidebar-link {
        color: #adb5bd;
        text-decoration: none;
        padding: 15px 25px;
        display: flex;
        align-items: center;
        transition: 0.3s;
        white-space: nowrap;
    }

    .sidebar-link:hover, .sidebar-link.active {
        color: #fff;
        background: #495057;
        border-left: 4px solid var(--secondary-blue);
    }

    .sidebar-link i {
        font-size: 1.1rem;
        width: 30px;
    }


    #sidebar.collapsed .sidebar-link span {
        display: none;
    }

    #sidebar.collapsed .sidebar-link {
        justify-content: center;
        padding: 15px 0;
        border-left: none;
    }

    .logout-link-sidebar {
        margin-top: auto;
        background-color: #e74c3c;
        color: white;
        text-align: center;
        padding: 15px;
        text-decoration: none;
        font-weight: bold;
    }

    #sidebar.collapsed .logout-link-sidebar span {
        display: none;
    }
</style>

<div id="sidebar">
    <div class="sidebar-header">
        <h2 class="h5 mb-0">Quản Lý Thuốc</h2>
        <i class="fas fa-pills d-none shadow-sm" id="mini-logo"></i>
    </div>

    <div class="flex-column nav">
        <a href="${pageContext.request.contextPath}/ban-hang"
           class="sidebar-link ${fn:contains(request.getRequestURI(), '/ban-hang') ? 'active' : ''}">
            <i class="fas fa-cash-register"></i> <span>Bán Hàng</span>
        </a>

        <a href="${pageContext.request.contextPath}/thuoc"
           class="sidebar-link ${fn:contains(request.getRequestURI(), '/thuoc') && !fn:contains(request.getRequestURI(), 'action=add') ? 'active' : ''}">
            <i class="fas fa-list"></i> <span>Danh Sách Thuốc</span>
        </a>

        <c:if test="${currentUser.nhomQuyen eq 'ADMIN'}">
            <a href="<%= request.getContextPath() %>/thuoc?action=add"
               class="sidebar-link ${fn:contains(request.getQueryString(), 'action=add') ? 'active' : ''}">
                <i class="fas fa-plus"></i> <span>Thêm Thuốc</span>
            </a>
            <a href="${pageContext.request.contextPath}/loai-thuoc"
               class="sidebar-link ${fn:contains(request.getRequestURI(), '/loai-thuoc') ? 'active' : ''}">
                <i class="fas fa-tags"></i> <span>Loại Thuốc</span>
            </a>
            <a href="${pageContext.request.contextPath}/users"
               class="sidebar-link ${fn:contains(request.getRequestURI(), '/users') ? 'active' : ''}">
                <i class="fas fa-users-cog"></i> <span>Tài Khoản</span>
            </a>
            <a href="${pageContext.request.contextPath}/send-email"
               class="sidebar-link ${fn:contains(request.getRequestURI(), '/send-email') ? 'active' : ''}">
                <i class="fas fa-envelope"></i> <span>Gửi Email</span>
            </a>
        </c:if>
    </div>

    <a href="${pageContext.request.contextPath}/logout" class="logout-link-sidebar">
        <i class="fas fa-sign-out-alt"></i> <span>Đăng xuất</span>
    </a>
</div>