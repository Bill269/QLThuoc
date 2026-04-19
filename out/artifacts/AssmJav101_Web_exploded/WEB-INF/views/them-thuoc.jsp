<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="fragment/header.jsp" %>

<div class="main-container">
    <div class="table-container" style="max-width: 600px; margin: 50px auto; padding: 40px; background: white; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
        <h2 class="mb-4" style="color: #2c3e50; font-weight: 700; border-bottom: 3px solid #2ecc71; padding-bottom: 10px;">
            <i class="fas fa-plus-circle me-2"></i> Nhập lô thuốc mới
        </h2>

        <form action="kho?action=insert" method="post">
            <div class="mb-4">
                <label class="form-label fw-bold">Chọn dược phẩm từ danh mục</label>
                <select name="idTenThuoc" class="form-select form-select-lg" required>
                    <option value="">-- Chọn tên thuốc --</option>
                    <c:forEach var="tc" items="${listThuocCha}">
                        <option value="${tc.id}">${tc.ten_thuoc_cha}</option>
                    </c:forEach>
                </select>
                <small class="text-muted">Thông tin Loại, Đơn vị, Giá sẽ tự động lấy từ danh mục.</small>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label fw-bold">Số lượng nhập</label>
                    <input type="number" name="soLuong" id="soLuong" value="${thuocToEdit.soLuongTon}" class="form-control" required min="1" placeholder="Ví dụ: 100">
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label fw-bold">Hạn sử dụng</label>
                    <input type="date" name="hanSuDung" class="form-control" required>
                </div>
            </div>

            <div class="d-grid gap-2 mt-4">
                <button type="submit" class="btn btn-success py-2 fw-bold">XÁC NHẬN NHẬP KHO</button>
                <a href="kho" class="btn btn-outline-secondary py-2">Hủy bỏ</a>
            </div>
        </form>
    </div>
</div>

<%@ include file="fragment/footer.jsp" %>