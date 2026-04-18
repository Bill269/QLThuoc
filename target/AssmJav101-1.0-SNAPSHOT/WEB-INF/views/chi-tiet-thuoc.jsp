<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="fragment/header.jsp" %>

<div class="main-content-inner" style="padding: 50px 0;">
    <div class="container" style="max-width: 900px;">
        <div class="detail-card mb-5" style="background: white; border-radius: 20px; box-shadow: 0 15px 35px rgba(0,0,0,0.1); overflow: hidden;">
            <div style="background: #2c3e50; padding: 30px; color: white; text-align: center;">
                <h2 style="margin: 0;">${thuoc.thuocCha.ten_thuoc_cha}</h2>
                <p style="margin: 5px 0 0; opacity: 0.7;">Đang xem chi tiết Lô hàng: #${thuoc.id}</p>
            </div>

            <div style="padding: 30px;">
                <div class="row mb-4">
                    <div class="col-6">
                        <label class="text-muted small text-uppercase fw-bold">Loại & Đơn vị</label>
                        <p class="fw-bold">${thuoc.thuocCha.loaiThuoc.tenLoai} | ${thuoc.thuocCha.donViTinh.tenDonVi}</p>
                    </div>
                    <div class="col-6 text-end">
                        <label class="text-muted small text-uppercase fw-bold">Giá niêm yết</label>
                        <p class="text-danger fw-bold fs-4">
                            <fmt:formatNumber value="${thuoc.thuocCha.giaBanMacDinh}" type="currency" currencySymbol="₫"/>
                        </p>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="text-muted small text-uppercase fw-bold">Mô tả dược phẩm</label>
                    <div class="p-3 bg-light border-start border-4 border-warning" style="white-space: pre-wrap; border-radius: 4px; font-style: italic;">
                        ${not empty thuoc.thuocCha.moTa ? thuoc.thuocCha.moTa : "Chưa có thông tin mô tả chi tiết."}
                    </div>
                </div>

                <hr>

                <div class="row text-center mt-4">
                    <div class="col-4 border-end">
                        <label class="text-muted small fw-bold">TỒN KHO LÔ NÀY</label>
                        <p class="fs-5 fw-bold text-primary">${thuoc.soLuongTon}</p>
                    </div>
                    <div class="col-4 border-end">
                        <label class="text-muted small fw-bold">THỜI GIAN NHẬP</label>
                        <p class="small">
                            <fmt:formatDate value="${thuoc.ngayNhapThuoc}" pattern="dd/MM/yyyy" />
                        </p>
                    </div>
                    <div class="col-4">
                        <label class="text-muted small fw-bold">HẠN SỬ DỤNG</label>
                        <p class="small text-danger fw-bold">
                            <fmt:formatDate value="${thuoc.hanSuDung}" pattern="dd/MM/yyyy" />
                        </p>
                    </div>
                </div>

                <div class="mt-5 d-flex gap-2">
                    <a href="kho" class="btn btn-secondary flex-grow-1 py-2">Quay lại danh sách</a>
                    <a href="kho?action=edit&id=${thuoc.id}" class="btn btn-warning text-white flex-grow-1 py-2 fw-bold">Chỉnh sửa lô hàng này</a>
                </div>
            </div>
        </div>

        <div class="history-section" style="background: white; border-radius: 20px; padding: 30px; box-shadow: 0 10px 25px rgba(0,0,0,0.05);">
            <h4 class="mb-4" style="color: #2c3e50;"><i class="fa fa-history me-2"></i>Lịch sử nhập lô (Tiến trình nhập hàng)</h4>

            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>Mã lô</th>
                        <th>Ngày nhập</th>
                        <th>Số lượng</th>
                        <th>Hạn dùng</th>
                        <th class="text-center">Trạng thái</th>
                        <th class="text-end">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${lichSuNhap}" var="item">
                        <tr style="${item.id == thuoc.id ? 'background-color: #f0f7ff; border-left: 4px solid #0d6efd;' : ''}">
                            <td class="fw-bold text-muted">#${item.id}</td>
                            <td>
                                <fmt:formatDate value="${item.ngayNhapThuoc}" pattern="dd/MM/yyyy" />
                            </td>
                            <td>
                                    <span class="badge ${item.soLuongTon > 10 ? 'bg-success' : 'bg-danger'}">
                                            ${item.soLuongTon}
                                    </span>
                            </td>
                            <td>
                                <fmt:formatDate value="${item.hanSuDung}" pattern="dd/MM/yyyy" />
                            </td>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${item.id == thuoc.id}">
                                        <span class="text-primary fw-bold small">Đang xem</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted small">Khác</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end">
                                <c:if test="${item.id != thuoc.id}">
                                    <a href="kho?action=detail&id=${item.id}" class="btn btn-sm btn-outline-primary">
                                        Xem chi tiết
                                    </a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="mt-2">
                <small class="text-muted font-italic">* Các lô hàng được sắp xếp theo thời gian nhập mới nhất lên đầu.</small>
            </div>
        </div>
    </div>
</div>

<%@ include file="fragment/footer.jsp" %>