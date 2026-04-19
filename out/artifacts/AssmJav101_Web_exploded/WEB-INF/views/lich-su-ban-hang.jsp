<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="fragment/header.jsp" %>

<div class="container-fluid p-4">
    <%-- Tiêu đề và Thanh tìm kiếm --%>
    <div class="mb-4 d-flex justify-content-between align-items-center">
        <h3 class="fw-bold text-dark mb-0">
            <i class="fas fa-history me-2 text-primary"></i> Nhật Ký Giao Dịch
        </h3>

        <%-- Form tìm kiếm theo ID --%>
        <form action="hoa-don" method="get" class="d-flex" style="width: 320px;">
            <div class="input-group shadow-sm">
        <span class="input-group-text bg-white border-end-0">
            <i class="fas fa-search text-muted"></i>
        </span>
                <%-- Đổi từ type="number" sang type="text" --%>
                <input type="text" name="txtSearchId" class="form-control border-start-0 ps-0"
                       placeholder="Nhập mã hóa đơn..." value="${lastSearchId}">
                <button class="btn btn-primary px-3" type="submit">Tìm kiếm</button>

                <c:if test="${not empty lastSearchId}">
                    <a href="hoa-don" class="btn btn-outline-secondary">
                        <i class="fas fa-times"></i>
                    </a>
                </c:if>
            </div>
        </form>
    </div>

    <%-- Bảng danh sách hóa đơn --%>
    <div class="bg-white rounded shadow-sm overflow-hidden">
        <table class="table table-hover mb-0">
            <thead class="table-light">
            <tr>
                <th class="ps-4">Mã Hóa Đơn</th>
                <th>Thời Gian Lập</th>
                <th>Người Bán</th>
                <th class="text-end">Tổng Tiền</th>
                <th class="text-center">Hành Động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="hd" items="${listHD}">
                <tr>
                    <td class="ps-4 fw-bold text-primary">#${hd.id}</td>
                    <td><fmt:formatDate value="${hd.ngayLap}" pattern="HH:mm dd/MM/yyyy"/></td>
                    <td><span class="badge bg-info text-dark">${hd.tenNguoiDung}</span></td>
                    <td class="text-end fw-bold text-danger"><fmt:formatNumber value="${hd.tongTien}" pattern="#,###"/> đ</td>
                    <td class="text-center">
                            <%-- Nút xem chi tiết --%>
                        <button type="button" class="btn btn-sm btn-outline-primary rounded-circle"
                                data-bs-toggle="modal" data-bs-target="#modal${hd.id}">
                            <i class="fas fa-eye"></i>
                        </button>
                    </td>
                </tr>
            </c:forEach>

            <%-- Hiển thị khi không tìm thấy kết quả --%>
            <c:if test="${empty listHD}">
                <tr>
                    <td colspan="5" class="text-center py-5 text-muted">
                        <i class="fas fa-search fa-3x mb-3 d-block opacity-25"></i>
                        Không tìm thấy hóa đơn phù hợp.
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

<%-- Duyệt Modal chi tiết cho từng hóa đơn --%>
<c:forEach var="hd" items="${listHD}">
    <div class="modal fade" id="modal${hd.id}" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content shadow-lg border-0">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title text-uppercase fw-bold">
                        <i class="fas fa-file-invoice me-2"></i>Chi Tiết Hóa Đơn #${hd.id}
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-0">
                        <%-- Thông tin khách hàng --%>
                    <div class="p-3 border-bottom bg-light">
                        <h6 class="fw-bold text-primary mb-3"><i class="fas fa-user-circle me-2"></i>Thông tin khách hàng</h6>
                        <div class="row g-2 small">
                            <div class="col-md-6">Khách hàng: <strong>${not empty hd.tenKhachHang ? hd.tenKhachHang : 'Khách lẻ'}</strong></div>
                            <div class="col-md-6">Điện thoại: <strong>${not empty hd.soDienThoai ? hd.soDienThoai : 'N/A'}</strong></div>
                            <div class="col-md-12">Địa chỉ: <strong>${not empty hd.diaChi ? hd.diaChi : 'N/A'}</strong></div>
                        </div>
                    </div>

                        <%-- Danh sách thuốc trong hóa đơn --%>
                    <table class="table table-striped mb-0">
                        <thead class="table-light">
                        <tr class="small fw-bold">
                            <th class="ps-4">Tên Thuốc</th>
                            <th class="text-center">Số lượng</th>
                            <th class="text-end pe-4">Thành Tiền</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="ct" items="${hd.chiTietList}">
                            <tr>
                                <td class="ps-4 text-dark fw-medium">${ct.tenThuoc}</td>
                                <td class="text-center">x${ct.soLuong}</td>
                                <td class="text-end pe-4 fw-bold text-primary">
                                    <fmt:formatNumber value="${ct.thanhTien}" pattern="#,###"/> đ
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>

                        <%-- Tổng cộng tiền --%>
                    <div class="p-3 text-end bg-light border-top">
                        <span class="h6 text-muted me-3">TỔNG CỘNG THANH TOÁN:</span>
                        <span class="h3 fw-bold text-danger">
                            <fmt:formatNumber value="${hd.tongTien}" pattern="#,###"/> đ
                        </span>
                    </div>
                </div>
                <div class="modal-footer bg-white border-0">
                    <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-success px-4" onclick="window.print()">
                        <i class="fas fa-print me-2"></i>In hóa đơn
                    </button>
                </div>
            </div>
        </div>
    </div>
</c:forEach>

<%@ include file="fragment/footer.jsp" %>