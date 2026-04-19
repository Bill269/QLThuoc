<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="fragment/header.jsp" %>

<div class="main-content-inner" style="display: flex; justify-content: center; padding: 50px;">
    <div class="detail-card" style="background: white; width: 100%; max-width: 600px; border-radius: 20px; box-shadow: 0 15px 35px rgba(0,0,0,0.1); overflow: hidden;">

        <div style="background: #2c3e50; padding: 30px; color: white; text-align: center;">
            <h2 style="margin: 0;">${thuoc.thuocCha.ten_thuoc_cha}</h2>
            <p style="margin: 5px 0 0; opacity: 0.7;">Mã lô: #${thuoc.id}</p>
        </div>

        <div style="padding: 30px;">
            <div class="row mb-3">
                <div class="col-6">
                    <label class="text-muted small text-uppercase fw-bold">Loại thuốc</label>
                    <p class="fw-bold">${thuoc.thuocCha.loaiThuoc.tenLoai}</p>
                </div>
                <div class="col-6">
                    <label class="text-muted small text-uppercase fw-bold">Đơn vị tính</label>
                    <p class="fw-bold">${thuoc.thuocCha.donViTinh.tenDonVi}</p>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-6">
                    <label class="text-muted small text-uppercase fw-bold">Giá bán</label>
                    <p class="text-danger fw-bold fs-5"><fmt:formatNumber value="${thuoc.thuocCha.giaBanMacDinh}" type="currency" currencySymbol="₫"/></p>
                </div>
                <div class="col-6">
                    <label class="text-muted small text-uppercase fw-bold">Số lượng tồn</label>
                    <p class="fw-bold fs-5">${thuoc.soLuongTon}</p>
                </div>
            </div>

            <hr>

            <div class="row">
                <div class="col-6">
                    <label class="text-muted small text-uppercase fw-bold">Ngày nhập kho</label>
                    <p><fmt:formatDate value="${thuoc.ngayNhapThuoc}" pattern="dd/MM/yyyy HH:mm" /></p>
                </div>
                <div class="col-6">
                    <label class="text-muted small text-uppercase fw-bold">Hạn sử dụng</label>
                    <p class="text-primary fw-bold"><fmt:formatDate value="${thuoc.hanSuDung}" pattern="dd/MM/yyyy" /></p>
                </div>
            </div>

            <div class="mt-4 d-flex gap-2">
                <a href="kho" class="btn btn-secondary flex-grow-1">Trở về</a>
                <a href="kho?action=edit&id=${thuoc.id}" class="btn btn-warning text-white flex-grow-1">Sửa lô hàng</a>
            </div>
        </div>
    </div>
</div>

<%@ include file="fragment/footer.jsp" %>