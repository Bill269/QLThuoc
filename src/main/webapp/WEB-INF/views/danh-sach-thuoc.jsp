<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- 1. GỌI HEADER (Mở HTML, CSS, Sidebar, Topbar) --%>
<%@ include file="fragment/header.jsp" %>

<div class="card-grid">
    <div class="card card-total">
        <h3>TỔNG SỐ LOẠI THUỐC</h3>
        <p>${fn:length(dsThuoc)}</p>
    </div>
    <div class="card card-stock">
        <h3>TỔNG SỐ LƯỢNG TỒN</h3>
        <p><fmt:formatNumber value="${totalAmount}" type="number"/></p>
    </div>
    <div class="card card-warning">
        <h3>SẮP HẾT HẠN (30 Ngày)</h3>
        <p>${warningCount}</p>
    </div>
    <div class="card card-danger">
        <h3>ĐÃ HẾT HẠN</h3>
        <p>${expiredCount}</p>
    </div>
</div>

<div class="table-container">

    <c:if test="${not empty error}">
        <div class="warning-box"
             style="background-color: #fcebeb; border-color: var(--danger); color: var(--danger); padding: 15px; border-radius: 8px; margin-bottom: 15px;">
                ${error}
        </div>
    </c:if>

    <form action="<%= request.getContextPath() %>/thuoc" method="get" class="filter-form">
        <input type="hidden" name="action" value="filter">
        <label>Lọc theo Loại:</label>
        <select name="loai">
            <option value="">-- Tất cả --</option>
            <option value="Kháng sinh">Kháng sinh</option>
            <option value="Giảm đau">Giảm đau</option>
            <option value="Vitamin">Vitamin</option>
            <option value="Khác">Khác</option>
        </select>
        <label>Lọc theo Hạn:</label>
        <select name="filter">
            <option value="">Tất cả</option>
            <option value="expired">Sắp hết hạn 30 ngày tới!</option>
        </select>
        <input type="submit" value="Lọc">
    </form>

    <h2 style="margin-bottom: 10px; font-size: 1.2rem;">Danh sách Thuốc</h2>

    <table class="data-table">
        <thead>
        <tr>
            <th>STT</th>
            <th>Tên Thuốc</th>
            <th>Loại</th>
            <th>Số lượng tồn</th>
            <th>Hạn sử dụng</th>
            <th>Trạng thái HSD</th>
            <th>Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="thuoc" items="${dsThuoc}" varStatus="status">

            <c:set var="isExpired" value="${thuoc.hanSuDung.time < ngayHienTai.time}"/>
            <c:set var="isWarning"
                   value="${thuoc.hanSuDung.time < ngayCanhBao.time && thuoc.hanSuDung.time >= ngayHienTai.time}"/>

            <tr class="
                            <c:if test="${isExpired}">expired-row</c:if>
                            <c:if test="${isWarning}">warning-row</c:if>
                        ">
                <td>${status.index + 1}</td>
                <td>${thuoc.tenThuoc}</td>
                <td>${thuoc.loaiThuoc}</td>
                <td>${thuoc.soLuongTon}</td>

                <td class="
                                <c:if test="${isExpired}">text-danger-bold</c:if>
                                <c:if test="${isWarning}">text-warning-bold</c:if>
                            ">
                    <fmt:formatDate value="${thuoc.hanSuDung}" pattern="dd/MM/yyyy"/>
                </td>

                <td>
                    <c:choose>
                        <c:when test="${isExpired}">
                            <span class="text-danger-bold" style="color: var(--danger); font-weight: bold;">ĐÃ HẾT HẠN</span>
                        </c:when>
                        <c:when test="${isWarning}">
                            <span class="text-warning-bold" style="color: var(--warning); font-weight: bold;">SẮP HẾT HẠN</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #27ae60; font-weight: bold;">Còn hạn sử dụng</span>
                        </c:otherwise>
                    </c:choose>
                </td>

                <td>
                    <div style="display: flex; gap: 8px; justify-content: center;">
                        <a href="<%= request.getContextPath() %>/detail?id=${thuoc.id}"
                           class="action-link" style="background: #3498db; color: white; padding: 5px 10px; border-radius: 4px; text-decoration: none; font-size: 0.85em;">
                            <i class="fas fa-eye"></i> Xem
                        </a>

                        <c:if test="${currentUser.nhomQuyen eq 'ADMIN'}">
                            <a href="<%= request.getContextPath() %>/edit?id=${thuoc.id}"
                               class="action-link edit-link" style="background: #f39c12; color: white; padding: 5px 10px; border-radius: 4px; text-decoration: none; font-size: 0.85em;">
                                <i class="fas fa-edit"></i> Sửa
                            </a>

                            <a href="<%= request.getContextPath() %>/thuoc?action=delete&id=${thuoc.id}"
                               class="action-link delete-link"
                               style="background: #e74c3c; color: white; padding: 5px 10px; border-radius: 4px; text-decoration: none; font-size: 0.85em;"
                               onclick="return confirm('Xác nhận xóa thuốc ${thuoc.tenThuoc}?')">
                                <i class="fas fa-trash"></i> Xóa
                            </a>
                        </c:if>
                    </div>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty dsThuoc}">
            <tr>
                <td colspan="7" class="text-center">Không tìm thấy thuốc nào trong danh sách.</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>

<%-- 3. GỌI FOOTER (Đóng các thẻ div, body, html) --%>
<%@ include file="fragment/footer.jsp" %>