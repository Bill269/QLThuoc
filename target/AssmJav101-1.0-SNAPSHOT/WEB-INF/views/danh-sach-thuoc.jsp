<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="fragment/header.jsp" %>

<style>
    .main-container {
        width: 100%;
        max-width: 1400px;
        margin: 0 auto;
        padding: 20px;
        box-sizing: border-box;
    }
    .card-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }
    .card {
        background: white;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        text-align: center;
    }
    .table-container {
        background: white;
        padding: 20px;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        width: 100%;
        overflow-x: auto;
    }
    .medicine-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 10px;
    }
    .medicine-table th, .medicine-table td {
        padding: 15px;
        text-align: left;
        border-bottom: 1px solid #eee;
    }
    .medicine-table th {
        background-color: #f8f9fa;
        color: #333;
        font-weight: 600;
    }
    .badge {
        display: inline-block;
        padding: 5px 10px;
        border-radius: 4px;
        font-size: 12px;
        font-weight: bold;
        color: white;
        text-align: center;
        min-width: 100px;
    }
</style>

<div class="main-container">
    <div class="card-grid">
        <div class="card" style="border-top: 5px solid #3498db;">
            <h3 style="font-size: 0.9em; color: #7f8c8d;">TỔNG LOẠI THUỐC</h3>
            <p style="font-size: 1.8em; font-weight: bold; margin: 10px 0;">${fn:length(dsThuoc)}</p>
        </div>
        <div class="card" style="border-top: 5px solid #2ecc71;">
            <h3 style="font-size: 0.9em; color: #7f8c8d;">TỔNG TỒN KHO</h3>
            <p style="font-size: 1.8em; font-weight: bold; margin: 10px 0;"><fmt:formatNumber value="${totalAmount}" type="number"/></p>
        </div>
        <div class="card" style="border-top: 5px solid #f39c12;">
            <h3 style="font-size: 0.9em; color: #7f8c8d;">SẮP HẾT HẠN</h3>
            <p style="font-size: 1.8em; font-weight: bold; margin: 10px 0;">${warningCount}</p>
        </div>
        <div class="card" style="border-top: 5px solid #e74c3c;">
            <h3 style="font-size: 0.9em; color: #7f8c8d;">ĐÃ HẾT HẠN</h3>
            <p style="font-size: 1.8em; font-weight: bold; margin: 10px 0;">${expiredCount}</p>
        </div>
    </div>

    <div class="table-container">
        <table class="medicine-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Tên Thuốc</th>
                <th>Loại</th>
                <th>Số Lượng</th>
                <th>Hạn Sử Dụng</th>
                <th>Trạng Thái</th>
                <th>Thao Tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="thuoc" items="${dsThuoc}">
                <tr>
                    <td>#${thuoc.id}</td>
                    <td><strong>${thuoc.tenThuoc}</strong></td>
                    <td><span style="background: #ecf0f1; padding: 4px 8px; border-radius: 4px; font-size: 0.9em;">${thuoc.loaiThuoc}</span></td>
                    <td><fmt:formatNumber value="${thuoc.soLuongTon}" type="number"/></td>
                    <td><fmt:formatDate value="${thuoc.hanSuDung}" pattern="dd/MM/yyyy"/></td>
                    <td>
                        <jsp:useBean id="today" class="java.util.Date" />
                        <c:set var="diff" value="${thuoc.hanSuDung.time - today.time}" />
                        <c:set var="daysLeft" value="${diff / (1000 * 60 * 60 * 24)}" />

                        <c:choose>
                            <c:when test="${daysLeft < 0}">
                                <span class="badge" style="background: #e74c3c;">HẾT HẠN</span>
                            </c:when>
                            <c:when test="${daysLeft <= 30}">
                                <span class="badge" style="background: #f39c12;">SẮP HẾT HẠN</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge" style="background: #2ecc71;">CÒN HẠN</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <div style="display: flex; gap: 5px;">
                            <a href="detail?id=${thuoc.id}" style="text-decoration: none; background: #3498db; color: white; padding: 6px 12px; border-radius: 4px; font-size: 0.8em;"><i class="fas fa-eye"></i> Xem</a>
                            <c:if test="${currentUser.nhomQuyen eq 'ADMIN'}">
                                <a href="edit?id=${thuoc.id}" style="text-decoration: none; background: #f39c12; color: white; padding: 6px 12px; border-radius: 4px; font-size: 0.8em;"><i class="fas fa-edit"></i> Sửa</a>
                                <a href="thuoc?action=delete&id=${thuoc.id}" onclick="return confirm('Xóa thuốc này?')" style="text-decoration: none; background: #e74c3c; color: white; padding: 6px 12px; border-radius: 4px; font-size: 0.8em;"><i class="fas fa-trash"></i> Xóa</a>
                            </c:if>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="fragment/footer.jsp" %>