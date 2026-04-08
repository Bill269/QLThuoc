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
            <form action="thuoc?action=add" method="post">
                <div class="mb-3">
                    <label class="form-label fw-bold">Tên dược phẩm</label>
                    <input type="text" name="tenThuoc" class="form-control" required>
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
                    <input type="number" name="giaBan" class="form-control" min="0" required>
                </div>
                <div class="mb-3">
                    <label class="form-label d-block fw-bold">Tình trạng</label>
                    <input type="radio" name="tinhTrang" value="true" checked> Còn bán
                    <input type="radio" name="tinhTrang" value="false" class="ms-3"> Ngưng bán
                </div>
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-success w-100">Lưu lại</button>
                    <a href="thuoc" class="btn btn-secondary w-100">Hủy</a>
                </div>
            </form>
        </div>
    </div>
</div>
<%@ include file="fragment/footer.jsp" %>