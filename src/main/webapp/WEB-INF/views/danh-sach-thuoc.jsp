<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- 1. GỌI HEADER --%>
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
        background-color: #2c3e50;
        color: white;
        font-weight: 600;
    }
    .badge-status {
        display: inline-block;
        padding: 5px 10px;
        border-radius: 4px;
        font-size: 12px;
        font-weight: bold;
        color: white;
        text-align: center;
        min-width: 110px;
    }

    .badge {
        display: inline-block;
        min-width: 100px;
        text-align: center;
        padding: 6px 12px;
        border-radius: 6px;
        font-weight: bold;
        border: 2px solid;
    }

    .badge-green {
        color: #28a745;
        border-color: #28a745;
        background-color: transparent;
    }

    .badge-yellow {
        color: #ffc107;
        border-color: #ffc107;
        background-color: transparent;
    }

    .badge-red {
        color: #dc3545;
        border-color: #dc3545;
        background-color: transparent;
    }
</style>

<div class="main-container">
    <div class="card-grid">
        <div class="card" style="border-top: 5px solid #3498db;">
            <h3 style="font-size: 0.9em; color: #7f8c8d;">TỔNG LOẠI THUỐC</h3>
            <p style="font-size: 1.8em; font-weight: bold; margin: 10px 0;">${fn:length(listThuoc)}</p>
        </div>
        <div class="card" style="border-top: 5px solid #2ecc71;">
            <h3 style="font-size: 0.9em; color: #7f8c8d;">TỔNG TỒN KHO</h3>
            <p style="font-size: 1.8em; font-weight: bold; margin: 10px 0;">
                <fmt:formatNumber value="${totalAmount != null ? totalAmount : 0}" type="number"/>
            </p>
        </div>
        <div class="card" style="border-top: 5px solid #f39c12;">
            <h3 style="font-size: 0.9em; color: #7f8c8d;">SẮP HẾT HẠN</h3>
            <p style="font-size: 1.8em; font-weight: bold; margin: 10px 0;">${warningCount != null ? warningCount : 0}</p>
        </div>
        <div class="card" style="border-top: 5px solid #e74c3c;">
            <h3 style="font-size: 0.9em; color: #7f8c8d;">ĐÃ HẾT HẠN</h3>
            <p style="font-size: 1.8em; font-weight: bold; margin: 10px 0;">${expiredCount != null ? expiredCount : 0}</p>
        </div>
    </div>

    <%-- Thanh tìm kiếm & Lọc --%>
    <div class="search-bar mb-4 p-4 bg-white shadow-sm rounded border">
        <form action="thuoc" method="get" class="row g-3">
            <input type="hidden" name="action" value="list">
            <div class="col-md-5">
                <label class="form-label fw-bold">Tìm kiếm tên thuốc</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                    <input type="text" name="txtSearch" class="form-control" placeholder="Nhập tên thuốc..." value="${lastSearch}">
                </div>
            </div>
            <div class="col-md-4">
                <label class="form-label fw-bold">Lọc theo loại</label>
                <select name="selLoai" class="form-select">
                    <option value="">-- Tất cả loại thuốc --</option>
                    <c:forEach var="l" items="${listLoai}">
                        <option value="${l.id}" ${lastLoai eq l.id ? 'selected' : ''}>${l.tenLoai}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-3 d-flex align-items-end gap-2">
                <button type="submit" class="btn btn-primary flex-grow-1"><i class="fas fa-filter"></i> Lọc</button>
                <a href="thuoc?action=add" class="btn btn-success"><i class="fas fa-plus"></i> Thêm mới</a>
            </div>
        </form>
    </div>

    <%-- Bảng hiển thị --%>
    <div class="table-container">
        <table class="medicine-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Tên Thuốc</th>
                <th>Loại</th>
                <th>Giá Bán</th>
                <th>Số Lượng</th>
                <th>Đơn Vị Tính</th>
                <th>Trạng Thái</th>
                <th>Tình trạng</th>
                <th>Thao Tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="thuoc" items="${listThuoc}">
                <tr>
                    <td>#${thuoc.id}</td>
                    <td><strong style="color: #2c3e50;">${thuoc.tenThuoc}</strong></td>
                    <td>
                        <span style="background: #f1f2f6; padding: 4px 10px; border-radius: 20px; font-size: 0.85em;">
                                ${thuoc.loaiThuoc}
                        </span>
                    </td>

                    <td class="fw-bold text-primary">
                        <fmt:formatNumber value="${thuoc.giaBan}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                    </td>

                    <td class="fw-bold"><fmt:formatNumber value="${thuoc.soLuongTon}" type="number"/></td>

                    <td class="text-muted" style="font-weight: 500;">
                        <i class="fas fa-box-open me-1" style="font-size: 0.8em;"></i>${thuoc.tenDonVi}
                    </td>

                    <td>
                        <c:set var="nowTime" value="<%= new java.util.Date().getTime() %>" />
                        <c:set var="expiryTime" value="${thuoc.hanSuDung.time}" />
                        <c:set var="daysLeft" value="${(expiryTime - nowTime) / (1000 * 60 * 60 * 24)}" />

                        <c:choose>
                            <c:when test="${daysLeft < 0}">
                                <span class="badge-status" style="background: #e74c3c;">HẾT HẠN</span>
                            </c:when>
                            <c:when test="${daysLeft <= 30}">
                                <span class="badge-status" style="background: #f39c12;">SẮP HẾT HẠN</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge-status" style="background: #2ecc71;">CÒN HẠN</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>
                        <span class="
                            badge
                            ${thuoc.trangThaiThuoc == 'Lô mới' ? 'badge-green' :
                              thuoc.trangThaiThuoc == 'Lô cũ' ? 'badge-yellow' :
                              'badge-red'}">
                                ${thuoc.trangThaiThuoc}
                        </span>
                    </td>
                    <td>
                        <div style="display: flex; gap: 8px;">
                            <a href="thuoc?action=detail&id=${thuoc.id}" class="btn btn-sm btn-info text-white shadow-sm" title="Xem chi tiết">
                                <i class="fas fa-eye"></i>
                            </a>
                            <c:if test="${not empty currentUser and currentUser.nhomQuyen eq 'ADMIN'}">
                                <a href="thuoc?action=edit&id=${thuoc.id}" class="btn btn-sm btn-warning text-white shadow-sm" title="Chỉnh sửa">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="thuoc?action=delete&id=${thuoc.id}"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa thuốc này?')"
                                   class="btn btn-sm btn-danger shadow-sm" title="Xóa">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </c:if>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<%-- 2. GỌI FOOTER --%>
<%@ include file="fragment/footer.jsp" %>