<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="fragment/header.jsp" %>

<div class="main-container">
    <div class="table-container" style="max-width: 600px; margin: 50px auto; padding: 40px; background: white; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
        <h2 class="mb-4" style="color: #2c3e50; font-weight: 700; border-bottom: 3px solid #2ecc71; padding-bottom: 10px;">
            <i class="fas fa-plus-circle me-2"></i> Nhập lô thuốc mới
        </h2>

        <c:if test="${param.error == 'date_too_old'}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                <strong>Lỗi:</strong> Hạn sử dụng phải lớn hơn ngày hôm nay!
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

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
                    <input type="date" name="hanSuDung" id="hanSDAdd"
                           class="form-control ${param.error == 'date_too_old' ? 'is-invalid' : ''}" required>

                    <%-- Thông báo lỗi ngay dưới ô nhập --%>
                    <c:if test="${param.error == 'date_too_old'}">
                        <div class="invalid-feedback" style="display: block;">
                            Hạn dùng phải lớn hơn ngày hôm nay!
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="d-grid gap-2 mt-4">
                <button type="submit" class="btn btn-success py-2 fw-bold">XÁC NHẬN NHẬP KHO</button>
                <a href="kho" class="btn btn-outline-secondary py-2">Hủy bỏ</a>
            </div>
        </form>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const dateInput = document.getElementById('hanSDAdd');

        // 1. Vẫn chặn lịch để người dùng dễ chọn đúng
        const today = new Date();
        const tomorrow = new Date(today);
        tomorrow.setDate(tomorrow.getDate() + 1);
        const tomorrowStr = tomorrow.toISOString().split('T')[0];
        dateInput.setAttribute('min', tomorrowStr);

        // 2. ÉP THÔNG BÁO TIẾNG VIỆT KHI NHẬP SAI (Xử lý cái bong bóng trong ảnh)
        dateInput.addEventListener('invalid', function() {
            this.setCustomValidity('Lỗi: Hạn dùng không hợp lệ!');
        });

        dateInput.addEventListener('input', function() {
            this.setCustomValidity(''); // Xóa thông báo khi người dùng bắt đầu sửa lại
        });
    });
</script>

<%@ include file="fragment/footer.jsp" %>