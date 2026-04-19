<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="fragment/header.jsp" %>

<div class="main-container" style="padding: 20px;">
    <%-- Phần các Card thống kê --%>
    <div class="card-grid" style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px;">
        <div class="card" style="border-top: 5px solid #2ecc71; background: white; padding: 20px; border-radius: 10px; text-align: center; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
            <h3 style="font-size: 0.9em; color: #7f8c8d;">TỔNG TỒN KHO</h3>
            <p style="font-size: 1.8em; font-weight: bold; margin: 10px 0;">
                <fmt:formatNumber value="${totalAmount != null ? totalAmount : 0}" type="number"/>
            </p>
        </div>

        <div class="card" style="border-top: 5px solid #3498db; background: white; padding: 20px; border-radius: 10px; text-align: center; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
            <h3 style="font-size: 0.9em; color: #7f8c8d;">TỔNG SỐ LOẠI THUỐC</h3>
            <p style="font-size: 1.8em; font-weight: bold; margin: 10px 0; color: #3498db;">${totalTypes != null ? totalTypes : 0}</p>
        </div>

        <div class="card" style="border-top: 5px solid #f1c40f; background: white; padding: 20px; border-radius: 10px; text-align: center; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
            <h3 style="font-size: 0.9em; color: #7f8c8d;">SẮP HẾT HẠN (30 NGÀY)</h3>
            <p style="font-size: 1.8em; font-weight: bold; margin: 10px 0; color: #f39c12;">${warningCount}</p>
        </div>
        <div class="card" style="border-top: 5px solid #e74c3c; background: white; padding: 20px; border-radius: 10px; text-align: center; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
            <h3 style="font-size: 0.9em; color: #7f8c8d;">ĐÃ HẾT HẠN</h3>
            <p style="font-size: 1.8em; font-weight: bold; margin: 10px 0; color: #e74c3c;">${expiredCount}</p>
        </div>
    </div>

    <%-- Thanh tìm kiếm --%>
    <div class="search-bar mb-4 p-4 bg-white shadow-sm rounded border">
        <form action="kho" method="get" class="row g-3">
            <input type="hidden" name="action" value="list">
            <div class="col-md-5">
                <input type="text" name="txtSearch" class="form-control" placeholder="Tìm theo tên thuốc..." value="${param.txtSearch}">
            </div>
            <div class="col-md-4">
                <select name="selLoai" class="form-select">
                    <option value="">-- Tất cả loại --</option>
                    <c:forEach var="l" items="${listLoai}">
                        <option value="${l.id}" ${param.selLoai == l.id ? 'selected' : ''}>${l.tenLoai}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-3">
                <button type="submit" class="btn btn-primary">Lọc</button>
                <a href="kho?action=add" class="btn btn-success">Nhập lô mới</a>
            </div>
        </form>
    </div>

    <%-- Bảng dữ liệu --%>
    <div class="table-container" style="background: white; padding: 20px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">
        <table class="table table-hover">
            <thead class="table-dark">
            <tr>
                <th>ID Lô</th>
                <th>Tên Thuốc</th>
                <th>Loại</th>
                <th>Giá Bán</th>
                <th>Số Lượng</th>
                <th>Đơn Vị</th>
                <th>Hạn Dùng</th>
                <th>Tình trạng</th>
                <th>Thao Tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="t" items="${listThuoc}">
                <tr>
                    <td>#${t.id}</td>
                    <td><strong style="color: #2c3e50;">${t.thuocCha.ten_thuoc_cha}</strong></td>
                    <td>${t.thuocCha.loaiThuoc.tenLoai}</td>
                    <td class="text-danger fw-bold"><fmt:formatNumber value="${t.thuocCha.giaBanMacDinh}" type="currency" currencySymbol="đ"/></td>
                    <td class="fw-bold">${t.soLuongTon}</td>
                    <td>${t.thuocCha.donViTinh.tenDonVi}</td>
                    <td><fmt:formatDate value="${t.hanSuDung}" pattern="dd/MM/yyyy" /></td>
                    <td>
                        <c:choose>
                            <c:when test="${t.trangThaiThuoc == 'Lô mới'}">
                                <span class="badge bg-success">Lô mới</span>
                            </c:when>
                            <c:when test="${t.trangThaiThuoc == 'Hàng chờ nhập'}">
                                <span class="badge bg-primary">Hàng chờ nhập</span>
                            </c:when>
                            <c:when test="${t.trangThaiThuoc == 'Hàng tồn kho'}">
                                <span class="badge bg-danger">Hàng tồn kho</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-warning text-dark">Lô cũ</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <a href="kho?action=detail&id=${t.id}" class="btn btn-sm btn-info text-white"><i class="fas fa-eye"></i></a>
                        <a href="kho?action=edit&id=${t.id}" class="btn btn-sm btn-warning text-white"><i class="fas fa-edit"></i></a>
                        <a href="kho?action=delete&id=${t.id}" onclick="return confirm('Xóa lô này?')" class="btn btn-sm btn-danger"><i class="fas fa-trash"></i></a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div> <%-- Đóng table-container --%>
</div> <%-- Đóng main-container --%>

<%@ include file="fragment/footer.jsp" %>