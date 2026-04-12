<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:useBean id="now" class="java.util.Date" />

<%@ include file="fragment/header.jsp" %>

<style>
    /* Custom CSS để giao diện mượt hơn */
    .qty-btn {
        width: 25px;
        height: 25px;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 0;
        font-size: 0.8rem;
    }
    .qty-input {
        width: 35px;
        text-align: center;
        border: none;
        background: transparent;
        font-weight: bold;
    }
    .table-responsive::-webkit-scrollbar {
        width: 5px;
    }
    .table-responsive::-webkit-scrollbar-thumb {
        background: #ccc;
        border-radius: 10px;
    }
</style>

<div class="container-fluid p-4">
    <c:if test="${not empty message}">
        <div class="alert alert-${messageType} alert-dismissible fade show shadow-sm" role="alert">
            <i class="fas ${messageType == 'success' ? 'fa-check-circle' : 'fa-exclamation-triangle'} me-2"></i>
                ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="row g-4">
        <div class="col-lg-7">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center border-bottom">
                    <h5 class="mb-0 text-primary fw-bold"><i class="fas fa-capsules me-2"></i>Danh Mục Thuốc</h5>
                    <form action="ban-hang" method="get" class="d-flex w-50">
                        <input type="text" name="txtSearch" class="form-control form-control-sm me-2"
                               placeholder="Tìm tên thuốc..." value="${lastSearch}">
                        <button class="btn btn-primary btn-sm px-3" type="submit"><i class="fas fa-search"></i></button>
                    </form>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive" style="height: 600px; overflow-y: auto;">
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
                                        <small class="text-muted">HSD: <fmt:formatDate value="${t.hanSuDung}" pattern="dd/MM/yyyy"/></small>
                                    </td>
                                    <td class="text-danger fw-bold">
                                        <fmt:formatNumber value="${t.thuocCha.giaBanMacDinh}" pattern="#,###"/> đ
                                    </td>
                                    <td class="text-center">
                                        <span class="badge rounded-pill ${t.soLuongTon < 10 ? 'bg-warning text-dark' : 'bg-info'}">
                                                ${t.soLuongTon}
                                        </span>
                                    </td>
                                    <td class="text-center text-nowrap">
                                        <c:choose>
                                            <c:when test="${!isExpired && t.soLuongTon > 0}">
                                                <a href="ban-hang?action=add&id=${t.id}" class="btn btn-sm btn-outline-success rounded-circle">
                                                    <i class="fas fa-plus"></i>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary opacity-50">Hết/Hạn</span>
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
        </div>

        <div class="col-lg-5">
            <div class="card shadow border-0 h-100 overflow-hidden">
                <div class="card-header bg-primary text-white py-3">
                    <h5 class="mb-0 text-center fw-bold"><i class="fas fa-file-invoice-dollar me-2"></i>HÓA ĐƠN CHI TIẾT</h5>
                </div>
                <div class="card-body d-flex flex-column p-0">
                    <div class="flex-grow-1 px-3 pt-3" style="height: 450px; overflow-y: auto;">
                        <table class="table table-sm table-borderless border-bottom">
                            <thead class="border-bottom">
                            <tr class="text-muted small uppercase">
                                <th style="width: 45%">Sản phẩm</th>
                                <th class="text-center" style="width: 25%">SL</th>
                                <th class="text-end">Thành tiền</th>
                                <th class="text-end"></th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:set var="totalMoney" value="0" />
                            <c:forEach var="item" items="${sessionScope.cart}">
                                <c:set var="totalMoney" value="${totalMoney + item.value.thanhTien}" />
                                <tr class="border-bottom-dashed">
                                    <td class="py-3">
                                        <span class="text-dark fw-bold">${item.value.thuoc.thuocCha.ten_thuoc_cha}</span>
                                    </td>
                                    <td class="py-3">
                                        <div class="d-flex align-items-center justify-content-center border rounded-pill p-1 shadow-sm">
                                            <a href="ban-hang?action=update&id=${item.value.thuoc.id}&num=-1"
                                               class="btn btn-light rounded-circle qty-btn">
                                                <i class="fas fa-minus text-secondary"></i>
                                            </a>
                                            <input type="text" readonly class="qty-input" value="${item.value.soLuong}">
                                            <a href="ban-hang?action=update&id=${item.value.thuoc.id}&num=1"
                                               class="btn btn-light rounded-circle qty-btn">
                                                <i class="fas fa-plus text-secondary"></i>
                                            </a>
                                        </div>
                                    </td>
                                    <td class="py-3 text-end text-primary fw-bold">
                                        <fmt:formatNumber value="${item.value.thanhTien}" pattern="#,###"/>
                                    </td>
                                    <td class="py-3 text-end">
                                        <a href="ban-hang?action=remove&id=${item.value.thuoc.id}"
                                           class="text-danger opacity-75 hover-opacity-100" title="Xóa">
                                            <i class="fas fa-trash-alt"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty sessionScope.cart}">
                                <tr>
                                    <td colspan="4" class="text-center py-5 text-muted">
                                        <i class="fas fa-shopping-basket fa-3x mb-3 opacity-25"></i><br>
                                        Chưa có sản phẩm nào trong hóa đơn
                                    </td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>

                    <div class="bg-light p-4 mt-auto border-top">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <span class="h5 mb-0 text-muted">Tổng tiền:</span>
                            <span class="h2 mb-0 text-danger fw-bold">
                                <fmt:formatNumber value="${totalMoney}" pattern="#,###"/> VNĐ
                            </span>
                        </div>

                        <div class="row g-3">
                            <div class="col-5">
                                <a href="ban-hang?action=clear" class="btn btn-outline-danger w-100 py-2 fw-bold"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa toàn bộ giỏ hàng?')">
                                    <i class="fas fa-trash"></i> Hủy giỏ
                                </a>
                            </div>
                            <div class="col-7">
                                <form action="ban-hang" method="post">
                                    <input type="hidden" name="action" value="sell">
                                    <button type="submit" class="btn btn-success w-100 py-2 fw-bold shadow"
                                    ${empty sessionScope.cart ? 'disabled' : ''}
                                            onclick="return confirm('Xác nhận xuất hóa đơn và thanh toán?')">
                                        <i class="fas fa-check-double me-2"></i> THANH TOÁN
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="fragment/footer.jsp" %>