<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="fragment/header.jsp" %>

<div class="container-fluid p-4">
    <h2 class="mb-4"><i class="fas fa-cash-register"></i> Quầy Bán Thuốc</h2>

    <div class="card shadow-sm border-0">
        <div class="card-body">
            <table class="table table-hover">
                <thead class="table-light">
                <tr>
                    <th>Tên Thuốc</th>
                    <th>Số Lượng</th>
                    <th>Hạn Sử Dụng</th>
                    <th>Trạng Thái</th>
                    <th class="text-center">Bán Lẻ</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="t" items="${listThuoc}">
                    <c:set var="now" value="<%= new java.util.Date() %>" />
                    <c:set var="isExpired" value="${t.hanSuDung.time < now.time}" />

                    <tr style="${isExpired ? 'opacity: 0.5; background: #f8d7da;' : ''}">
                        <td><strong>${t.tenThuoc}</strong></td>
                        <td><span class="badge bg-secondary">${t.soLuongTon}</span></td>
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
                            <c:if test="${!isExpired}">
                                <a href="ban-hang?action=sell&id=${t.id}" class="btn btn-danger btn-sm rounded-circle">
                                    <i class="fas fa-minus"></i>
                                </a>
                            </c:if>
                            <c:if test="${isExpired}">
                                <button class="btn btn-secondary btn-sm rounded-circle" disabled><i class="fas fa-lock"></i></button>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="fragment/footer.jsp" %>