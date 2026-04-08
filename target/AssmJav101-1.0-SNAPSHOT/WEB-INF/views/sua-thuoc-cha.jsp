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
            <form action="thuoc?action=update" method="post">
                <input type="hidden" name="id" value="${detail_thuoc_cha.id}">
                <div class="mb-3">
                    <label class="form-label fw-bold">Tên dược phẩm</label>
                    <input type="text" name="tenThuoc" value="${detail_thuoc_cha.ten_thuoc_cha}" class="form-control" required>
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
                    <input type="number" name="giaBan" value="${detail_thuoc_cha.gia_mac_dinh}" class="form-control" min="0" required>
                </div>
                <div class="mb-3">
                    <label class="form-label d-block fw-bold">Tình trạng</label>
                    <input type="radio" name="tinhTrang" value="true" ${detail_thuoc_cha.tinh_trang ? 'checked' : ''}> Còn bán
                    <input type="radio" name="tinhTrang" value="false" class="ms-3" ${!detail_thuoc_cha.tinh_trang ? 'checked' : ''}> Ngưng bán
                </div>
                <button type="submit" class="btn btn-warning w-100 text-white fw-bold">Cập nhật</button>
            </form>
        </div>
    </div>
</div>
<%@ include file="fragment/footer.jsp" %>
