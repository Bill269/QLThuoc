<%--
  Created by IntelliJ IDEA.
  User: LAPTOP LE SON
  Date: 4/8/2026
  Time: 10:17 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="fragment/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container mt-5">
    <div class="card shadow" style="max-width: 600px; margin: auto;">
        <div class="card-header bg-warning text-white"><h3><i class="fas fa-edit"></i> Sửa Thông Tin Thuốc</h3></div>
        <div class="card-body">
            <%-- Thêm id="editThuocForm" để xử lý Javascript --%>
            <form id="editThuocForm" action="thuoc?action=update" method="post">
                <input type="hidden" name="id" value="${detail_thuoc_cha.id}">

                <div class="mb-3">
                    <label class="form-label fw-bold">Tên dược phẩm</label>
                    <input type="text" name="tenThuoc" id="tenThuoc" value="${detail_thuoc_cha.ten_thuoc_cha}" class="form-control">
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Loại thuốc</label>
                        <select name="loai" class="form-select">
                            <c:forEach var="l" items="${loai}">
                                <option value="${l.id}" ${detail_thuoc_cha.id_loai == l.id ? 'selected' : ''}>${l.tenLoai}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Đơn vị tính</label>
                        <select name="donVi" class="form-select">
                            <c:forEach var="dv" items="${donVi}">
                                <option value="${dv.id}" ${detail_thuoc_cha.id_don_vi == dv.id ? 'selected' : ''}>${dv.tenDonVi}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Giá bán mặc định</label>
                    <input type="number" name="giaBan" id="giaBan" value="${detail_thuoc_cha.gia_mac_dinh}" class="form-control">
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Tình trạng</label>
                        <div class="d-flex align-items-center mt-2">
                            <div class="form-check me-3">
                                <input class="form-check-input" type="radio" name="tinhTrang" id="statusTrue" value="true" ${detail_thuoc_cha.tinh_trang ? 'checked' : ''}>
                                <label class="form-check-label" for="statusTrue">Còn bán</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="tinhTrang" id="statusFalse" value="false" ${!detail_thuoc_cha.tinh_trang ? 'checked' : ''}>
                                <label class="form-check-label" for="statusFalse">Ngưng bán</label>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Hạn dùng</label>
                        <select name="hanDung" id="hanDung" class="form-select" required>
                            <option value="">-- Chọn hạn dùng --</option>

                            <%-- Danh sách các hạn dùng phổ biến --%>
                            <option value="12 tháng" ${detail_thuoc_cha.hanDung == '12 tháng' ? 'selected' : ''}>12 tháng</option>
                            <option value="24 tháng" ${detail_thuoc_cha.hanDung == '24 tháng' ? 'selected' : ''}>24 tháng</option>
                            <option value="36 tháng" ${detail_thuoc_cha.hanDung == '36 tháng' ? 'selected' : ''}>36 tháng</option>
                            <option value="48 tháng" ${detail_thuoc_cha.hanDung == '48 tháng' ? 'selected' : ''}>48 tháng</option>
                            <option value="60 tháng" ${detail_thuoc_cha.hanDung == '60 tháng' ? 'selected' : ''}>60 tháng</option>

                            <%-- LOGIC DỰ PHÒNG: Nếu dữ liệu trong DB là một con số khác (ví dụ: 30 tháng) --%>
                            <c:set var="isCommon" value="${detail_thuoc_cha.hanDung == '12 tháng' ||
                                      detail_thuoc_cha.hanDung == '24 tháng' ||
                                      detail_thuoc_cha.hanDung == '36 tháng' ||
                                      detail_thuoc_cha.hanDung == '48 tháng' ||
                                      detail_thuoc_cha.hanDung == '60 tháng'}" />

                            <c:if test="${not empty detail_thuoc_cha.hanDung && !isCommon}">
                                <option value="${detail_thuoc_cha.hanDung}" selected>
                                        ${detail_thuoc_cha.hanDung} (Giá trị cũ)
                                </option>
                            </c:if>
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Mô tả thuốc</label>
                    <%-- Dùng input type="text" để dễ hiện bong bóng lỗi như mẫu --%>
                    <input type="text" name="moTa" id="moTa" value="${detail_thuoc_cha.moTa}" class="form-control">
                </div>

                <button type="submit" class="btn btn-warning w-100 text-white fw-bold">Cập nhật</button>
            </form>
        </div>
    </div>
</div>

<script>
    window.onload = function() {
        var errorMsg = "${error}";
        if (errorMsg !== "") {
            var inputId = "tenThuoc";
            if (errorMsg.includes("Mô tả")) inputId = "moTa";
            if (errorMsg.includes("Giá")) inputId = "giaBan";

            var input = document.getElementById(inputId);
            if (input) {
                input.setCustomValidity(errorMsg);
                input.reportValidity();
                input.oninput = function() { this.setCustomValidity(""); };
            }
        }
    };
</script>

<%@ include file="fragment/footer.jsp" %>
