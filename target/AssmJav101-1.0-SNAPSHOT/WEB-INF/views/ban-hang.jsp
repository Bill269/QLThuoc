<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:useBean id="now" class="java.util.Date" />

<%@ include file="fragment/header.jsp" %>

<div class="container-fluid p-4">
    <h2 class="mb-4"><i class="fas fa-cash-register"></i> Quầy Bán Thuốc</h2>

    <div class="card shadow-sm border-0">
        <div class="card-body">
            <%-- Thêm dòng này vào ngay đầu file JSP để hết lỗi font --%>

                <%-- Khai báo lấy ngày hiện tại ở đầu file --%>

                <table class="table table-hover align-middle">
                    <thead class="table-dark">
                    <tr>
                        <th>Tên Thuốc</th>
                        <th>Số Lượng</th>
                        <th>Hạn Sử Dụng</th>
                        <th>Trạng Thái</th>
                        <th class="text-center">Thao Tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="t" items="${listThuoc}">
                        <%-- Kiểm tra nếu hạn sử dụng < ngày hiện tại --%>
                        <c:set var="isExpired" value="${t.hanSuDung.time < now.time}" />

                        <tr class="${isExpired ? 'table-secondary text-muted' : ''}">
                            <td><strong>${t.tenThuoc}</strong></td>
                            <td><span class="badge bg-info">${t.soLuongTon}</span></td>
                            <td><fmt:formatDate value="${t.hanSuDung}" pattern="dd/MM/yyyy"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${isExpired}">
                                        <span class="badge bg-danger">HẾT HẠN</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-success">CÒN HẠN</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${!isExpired && t.soLuongTon > 0}">
                                        <a href="ban-hang?action=sell&id=${t.id}"
                                           class="btn btn-danger btn-sm"
                                           onclick="return confirm('Bạn có chắc chắn muốn bán thuốc: ${t.tenThuoc}?')">
                                            <i class="fas fa-shopping-cart" ></i> Bán Ngay
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <%-- Nút bị khóa nếu hết hạn hoặc hết hàng --%>
                                        <button class="btn btn-secondary btn-sm" disabled>
                                            <i class="fas fa-ban"></i> Bị Khóa
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
        </div>
    </div>
</div>

<%@ include file="fragment/footer.jsp" %>