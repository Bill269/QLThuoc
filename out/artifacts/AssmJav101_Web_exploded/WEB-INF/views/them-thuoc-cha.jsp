<%--
  Created by IntelliJ IDEA.
  User: LAPTOP LE SON
  Date: 4/8/2026
  Time: 10:16 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="fragment/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container mt-5">
    <div class="card shadow" style="max-width: 600px; margin: auto;">
        <div class="card-header bg-success text-white"><h3><i class="fas fa-plus-circle"></i> Thêm Thuốc Mới</h3></div>
        <div class="card-body">
            <%-- Thêm id="addThuocForm" --%>
            <form id="addThuocForm" action="thuoc?action=add" method="post">
                <div class="mb-3">
                    <label class="form-label fw-bold">Tên dược phẩm</label>
                    <input type="text" name="tenThuoc" id="tenThuoc" value="${detail_thuoc_cha.ten_thuoc_cha}" class="form-control">
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Loại thuốc</label>
                        <select name="loai" class="form-select">
                            <c:forEach var="l" items="${loai}">
                                <option value="${l.id}">${l.tenLoai}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Đơn vị tính</label>
                        <select name="donVi" class="form-select">
                            <c:forEach var="dv" items="${donVi}">
                                <option value="${dv.id}">${dv.tenDonVi}</option>
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
                        <label class="form-label d-block fw-bold">Tình trạng</label>
                        <div class="d-flex align-items-center mt-2">
                            <div class="form-check me-3">
                                <input class="form-check-input" type="radio" name="tinhTrang" id="statusTrue" value="true" checked>
                                <label class="form-check-label" for="statusTrue">Còn bán</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="tinhTrang" id="statusFalse" value="false">
                                <label class="form-check-label" for="statusFalse">Ngưng bán</label>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Hạn dùng</label>
                        <select name="hanDung" class="form-select" required>
                            <option value="">-- Chọn hạn dùng --</option>
                            <c:forEach var="hd" items="${listHanDung}">
                                <option value="${hd}">${hd}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Mô tả</label>
                    <input type="text" name="moTa" id="moTa" value="${detail_thuoc_cha.moTa}" class="form-control">
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-success w-100">Lưu lại</button>
                    <a href="thuoc" class="btn btn-secondary w-100">Hủy</a>
                </div>
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