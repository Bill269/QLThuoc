<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="fragment/header.jsp" %>

<div class="main-container">
    <div class="table-container" style="max-width: 600px; margin: 50px auto; padding: 40px; background: white; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
        <h2 class="mb-4" style="color: #2c3e50; font-weight: 700; border-bottom: 3px solid #f39c12; padding-bottom: 10px;">
            <i class="fas fa-edit me-2"></i> Cập nhật lô thuốc #${thuocToEdit.id}
        </h2>

        <form action="kho?action=update" method="post">
            <input type="hidden" name="id" value="${thuocToEdit.id}">

            <div class="mb-4">
                <label class="form-label fw-bold">Tên dược phẩm</label>
                <select name="idTenThuoc" class="form-select form-select-lg" required>
                    <option value="">-- Chọn lại tên thuốc nếu cần --</option>
                    <c:forEach var="tc" items="${listThuocCha}">
                        <option value="${tc.id}" ${tc.id == thuocToEdit.thuocCha.id ? 'selected' : ''}>
                                ${tc.ten_thuoc_cha}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <%-- QUAN TRỌNG: Phải có ô Ngày Nhập để Servlet không bị lỗi Null --%>
            <div class="mb-3">
                <label class="form-label fw-bold">Ngày nhập thuốc</label>
                <fmt:formatDate value="${thuocToEdit.ngayNhapThuoc}" pattern="yyyy-MM-dd" var="fmtNgayNhap" />
                <input type="date" name="ngayNhap" value="${fmtNgayNhap}" class="form-control" required>
                <small class="text-muted">Giữ nguyên hoặc sửa lại ngày nhập kho.</small>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label fw-bold">Số lượng tồn kho</label>
                    <input type="number" name="soLuong" value="${thuocToEdit.soLuongTon}" class="form-control" required min="0">
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label fw-bold">Hạn sử dụng</label>
                    <fmt:formatDate value="${thuocToEdit.hanSuDung}" pattern="yyyy-MM-dd" var="fmtHSD" />
                    <input type="date" name="hanSuDung" id="hanSuDungEdit" value="${fmtHSD}"
                           class="form-control bg-light" readonly style="cursor: not-allowed;">
                </div>
            </div>

            <div class="d-grid gap-2 mt-4">
                <button type="submit" class="btn btn-warning py-2 fw-bold text-white">LƯU THAY ĐỔI</button>
                <a href="kho" class="btn btn-outline-secondary py-2">Quay lại</a>
            </div>
        </form>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const dateInput = document.getElementById('hanSuDungEdit');
        const originalDate = dateInput.value;

        const today = new Date();
        const tomorrow = new Date(today);
        tomorrow.setDate(tomorrow.getDate() + 1);
        const tomorrowStr = tomorrow.toISOString().split('T')[0];

        // Hàm kiểm tra và đặt thông báo lỗi tiếng Việt
        function validateDate() {
            if (dateInput.value !== originalDate && dateInput.value < tomorrowStr && dateInput.value !== "") {
                dateInput.setCustomValidity('Lỗi: Hạn dùng không hợp lệ!');
            } else {
                dateInput.setCustomValidity('');
            }
        }

        // Kiểm tra ngay khi người dùng thay đổi giá trị
        dateInput.addEventListener('input', validateDate);

        // Hiển thị bong bóng khi nhấn Submit mà dữ liệu sai
        dateInput.addEventListener('invalid', validateDate);

        // Hỗ trợ chọn trên lịch
        dateInput.addEventListener('focus', function() {
            this.setAttribute('min', tomorrowStr);
        });

        dateInput.addEventListener('blur', function() {
            if (this.value === originalDate) {
                this.removeAttribute('min');
                this.setCustomValidity('');
            }
        });
    });
</script>

<%@ include file="fragment/footer.jsp" %>