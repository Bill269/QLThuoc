<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:useBean id="now" class="java.util.Date" />

<%@ include file="fragment/header.jsp" %>

<style>
    .qty-btn { width: 28px; height: 28px; display: flex; align-items: center; justify-content: center; padding: 0; transition: 0.2s; }
    .qty-btn:hover { background-color: #0d6efd; color: white !important; }
    .qty-input { width: 45px; text-align: center; border: 1px solid #dee2e6; border-radius: 4px; font-weight: bold; margin: 0 5px; background: white; }
    .table-responsive { height: 550px; overflow-y: auto; border-radius: 0 0 8px 8px; }
    .border-bottom-dashed { border-bottom: 1px dashed #dee2e6; }
    button:disabled { cursor: not-allowed; opacity: 0.6; }
</style>

<div class="container-fluid p-4">
    <%-- Hiển thị thông báo từ Servlet (Thành công/Lỗi Validation) --%>
    <c:if test="${not empty message}">
        <div class="alert alert-${messageType} alert-dismissible fade show shadow-sm border-0" role="alert">
            <i class="fas ${messageType == 'success' ? 'fa-check-circle' : 'fa-exclamation-triangle'} me-2"></i>
                ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="row g-4">
        <%-- PHẦN DANH MỤC THUỐC --%>
        <div class="col-lg-7">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center border-bottom">
                    <h5 class="mb-0 text-primary fw-bold"><i class="fas fa-capsules me-2"></i>DANH MỤC THUỐC</h5>
                    <form action="ban-hang" method="get" class="d-flex w-50">
                        <div class="input-group">
                            <input type="text" name="txtSearch" class="form-control form-control-sm" placeholder="Tìm tên thuốc..." value="${lastSearch}">
                            <button class="btn btn-primary btn-sm px-3" type="submit"><i class="fas fa-search"></i></button>
                        </div>
                    </form>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light sticky-top shadow-sm">
                            <tr>
                                <th class="ps-3">Tên Thuốc</th>
                                <th>Giá Bán</th>
                                <th class="text-center">Tồn Kho</th>
                                <th class="text-center">Thêm</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="t" items="${listThuoc}">
                                <c:set var="isExpired" value="${t.hanSuDung.time < now.time}" />
                                <tr class="${isExpired || t.soLuongTon <= 0 ? 'table-light text-muted' : ''}">
                                    <td class="ps-3">
                                        <div class="fw-bold text-dark">${t.thuocCha.ten_thuoc_cha}</div>
                                        <small class="text-muted"><i class="far fa-calendar-alt me-1"></i>HSD: <fmt:formatDate value="${t.hanSuDung}" pattern="dd/MM/yyyy"/></small>
                                    </td>
                                    <td class="text-danger fw-bold"><fmt:formatNumber value="${t.thuocCha.giaBanMacDinh}" pattern="#,###"/> đ</td>
                                    <td class="text-center"><span class="badge rounded-pill ${t.soLuongTon < 10 ? 'bg-warning text-dark' : 'bg-info'}">${t.soLuongTon}</span></td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${!isExpired && t.soLuongTon > 0}">
                                                <a href="ban-hang?action=add&id=${t.id}" class="btn btn-sm btn-outline-success rounded-circle"><i class="fas fa-plus"></i></a>
                                            </c:when>
                                            <c:otherwise><span class="badge bg-secondary opacity-50 small">Hết/Hạn</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <%-- PHẦN GIỎ HÀNG VÀ THANH TOÁN --%>
        <div class="col-lg-5">
            <div class="card shadow border-0 overflow-hidden h-100">
                <div class="card-header bg-primary text-white py-3 text-center fw-bold">
                    <h5 class="mb-0 text-uppercase"><i class="fas fa-file-invoice-dollar me-2"></i>Chi Tiết Hóa Đơn</h5>
                </div>
                <div class="card-body p-0 d-flex flex-column" style="min-height: 500px;">
                    <div class="p-3 flex-grow-1" style="max-height: 400px; overflow-y: auto;">
                        <table class="table table-sm align-middle table-borderless">
                            <thead class="border-bottom small text-muted text-uppercase">
                            <tr>
                                <th style="width: 45%">Sản phẩm</th>
                                <th class="text-center" style="width: 30%">Số lượng</th>
                                <th class="text-end">Thành tiền</th>
                                <th></th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:set var="totalMoney" value="0" />
                            <c:forEach var="item" items="${sessionScope.cart}">
                                <c:set var="totalMoney" value="${totalMoney + item.value.thanhTien}" />
                                <tr class="border-bottom-dashed">
                                    <td class="py-3"><div class="fw-bold text-dark text-truncate" style="max-width: 140px;">${item.value.thuoc.thuocCha.ten_thuoc_cha}</div></td>
                                    <td class="py-3">
                                        <div class="d-flex align-items-center justify-content-center border rounded-pill p-1 bg-white shadow-sm">
                                            <a href="ban-hang?action=update&id=${item.value.thuoc.id}&num=-1" class="btn btn-light qty-btn rounded-circle"><i class="fas fa-minus small text-secondary"></i></a>
                                            <input type="number" class="qty-input" value="${item.value.soLuong}" min="1" onchange="window.location.href='ban-hang?action=setQty&id=${item.value.thuoc.id}&num=' + this.value">
                                            <a href="ban-hang?action=update&id=${item.value.thuoc.id}&num=1" class="btn btn-light qty-btn rounded-circle"><i class="fas fa-plus small text-secondary"></i></a>
                                        </div>
                                    </td>
                                    <td class="text-end fw-bold text-primary"><fmt:formatNumber value="${item.value.thanhTien}" pattern="#,###"/></td>
                                    <td class="text-end"><a href="ban-hang?action=remove&id=${item.value.thuoc.id}" class="text-danger opacity-75" onclick="return confirm('Xóa khỏi giỏ hàng?')"><i class="fas fa-trash-alt"></i></a></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty sessionScope.cart}">
                                <tr>
                                    <td colspan="4" class="text-center py-5 text-muted">
                                        <i class="fas fa-shopping-basket fa-3x mb-3 d-block opacity-25"></i>
                                        Giỏ hàng đang trống
                                    </td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>

                    <div class="bg-light p-4 border-top mt-auto">
                        <form action="ban-hang" method="post">
                            <div class="p-3 bg-white border rounded shadow-sm mb-3">
                                <h6 class="fw-bold text-primary mb-3"><i class="fas fa-user-edit me-2"></i>Thông tin khách hàng</h6>
                                <div class="row g-2">
                                    <div class="col-12">
                                        <%-- Tên: Chỉ chữ cái Việt Nam, chặn @, !, số --%>
                                            <input type="text" name="tenKhachHang" class="form-control form-control-sm"
                                                   placeholder="Họ tên khách hàng *"
                                                   pattern="^[a-zA-ZÀ-ỹ\sĐđ]+$"
                                                   title="Tên chỉ được chứa chữ cái tiếng Việt, không chứa số hoặc ký tự đặc biệt"
                                                   required>
                                    </div>
                                    <%-- SĐT: Chỉ 10-11 số --%>
                                    <div class="col-6">
                                        <input type="text" name="soDienThoai" class="form-control form-control-sm"
                                               placeholder="Số điện thoại *"
                                               pattern="[0-9]{10,11}"
                                               title="Số điện thoại phải từ 10-11 chữ số"
                                               required>
                                    </div>
                                    <%-- Email: Bắt đuôi @gmail.com --%>
                                    <div class="col-6">
                                        <input type="email" name="email" class="form-control form-control-sm"
                                               placeholder="Email (@gmail.com)"
                                               pattern="[a-z0-9._%+-]+@gmail\.com$"
                                               title="Hệ thống chỉ chấp nhận định dạng @gmail.com">
                                    </div>
                                    <div class="col-12">
                                        <%-- Địa chỉ: Đã sửa lỗi cú pháp và dùng regex an toàn --%>
                                        <input type="text" name="diaChi" class="form-control form-control-sm"
                                               placeholder="Địa chỉ (Không ký tự đặc biệt) *"
                                               pattern="^[a-zA-Z0-9À-ỹ\sĐđ,.\-/]+$"
                                               title="Địa chỉ không được chứa ký tự đặc biệt như @, #, $, %..."
                                               required>
                                    </div>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <span class="h5 mb-0 text-muted">TỔNG CỘNG:</span>
                                <span class="h2 mb-0 text-danger fw-bold"><fmt:formatNumber value="${totalMoney}" pattern="#,###"/> VNĐ</span>
                            </div>

                            <div class="row g-2">
                                <div class="col-5">
                                    <a href="ban-hang?action=clear" class="btn btn-outline-danger w-100 py-2 fw-bold" onclick="return confirm('Xóa giỏ hàng?')">
                                        <i class="fas fa-trash me-1"></i> Hủy
                                    </a>
                                </div>
                                <div class="col-7">
                                    <button type="submit" class="btn btn-success w-100 py-2 fw-bold shadow-sm"
                                    ${empty sessionScope.cart ? 'disabled' : ''}
                                            onclick="return confirm('Xác nhận thanh toán?')">
                                        <i class="fas fa-check-double me-2"></i> THANH TOÁN
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%@ include file="fragment/footer.jsp" %>