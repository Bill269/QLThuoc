<%--
  Created by IntelliJ IDEA.
  User: LAPTOP LE SON
  Date: 4/8/2026
  Time: 10:17 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="fragment/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container mt-5">
    <div class="card shadow-lg border-0" style="max-width: 600px; margin: auto; border-radius: 15px; overflow: hidden;">
        <div class="card-header text-center py-4" style="background: linear-gradient(135deg, #1e3c72, #2a5298); color: white;">
            <i class="fas fa-pills fa-3x mb-2"></i>
            <h2 class="mb-0">${detail_thuoc_cha.ten_thuoc_cha}</h2>
            <small>Mã hệ thống: #TC-${detail_thuoc_cha.id}</small>
        </div>
        <div class="card-body p-4">
            <ul class="list-group list-group-flush">
                <%-- 1. Thay ID Loại bằng Tên Loại --%>
                <li class="list-group-item d-flex justify-content-between">
                    <strong>Loại thuốc:</strong>
                    <span>${detail_thuoc_cha.loaiThuoc.tenLoai}</span>
                </li>

                <%-- 2. Thay ID Đơn vị bằng Tên Đơn vị --%>
                <li class="list-group-item d-flex justify-content-between">
                    <strong>Đơn vị tính:</strong>
                    <span>${detail_thuoc_cha.donViTinh.tenDonVi}</span>
                </li>
                <li class="list-group-item d-flex justify-content-between align-items-center">
                    <strong>Giá niêm yết:</strong>
                    <span class="text-danger h4 mb-0 fw-bold"><fmt:formatNumber value="${detail_thuoc_cha.gia_mac_dinh}" type="currency" currencySymbol="₫"/></span>
                </li>
                <li class="list-group-item d-flex justify-content-between">
                    <strong>Trạng thái:</strong>
                    <span class="badge ${detail_thuoc_cha.tinh_trang ? 'bg-success' : 'bg-danger'}">
                        ${detail_thuoc_cha.tinh_trang ? 'Đang kinh doanh' : 'Ngừng kinh doanh'}
                    </span>
                </li>
                <li class="list-group-item d-flex justify-content-between">
                        <strong>Hạn dùng</strong>
                        <span class="badge ${detail_thuoc_cha.hanDung}">
                        </span>
                </li>
                    <li class="list-group-item">
                        <div class="fw-bold mb-2">Mô tả chi tiết:</div>
                        <div class="text-secondary ps-2" style="white-space: pre-wrap; line-height: 1.6; border-left: 3px solid #dee2e6;">
                            <c:choose>
                                <c:when test="${not empty detail_thuoc_cha.moTa}">
                                    ${detail_thuoc_cha.moTa}
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted italic">Không có mô tả cho dược phẩm này.</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </li>
            </ul>
            <div class="mt-4 d-flex gap-2">
                <a href="thuoc" class="btn btn-outline-primary flex-grow-1">Quay về</a>
                <a href="thuoc?action=edit_form&id=${detail_thuoc_cha.id}" class="btn btn-warning text-white flex-grow-1">Đi tới Sửa</a>
            </div>
        </div>
    </div>
</div>
<%@ include file="fragment/footer.jsp" %>