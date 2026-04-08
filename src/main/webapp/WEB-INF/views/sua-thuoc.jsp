<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="fragment/header.jsp" %>

<div class="main-container">
    <div class="table-container" style="max-width: 600px; margin: 50px auto; padding: 40px; background: white; border-radius: 15px;">
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
                        <%-- Logic: Nếu ID của thuốc trong danh sách khớp với ID của thuốc đang sửa thì thêm thuộc tính selected --%>
                        <option value="${tc.id}" ${tc.id == thuocToEdit.thuocCha.id ? 'selected' : ''}>
                                ${tc.ten_thuoc_cha}
                        </option>
                    </c:forEach>
                </select>
                <div class="form-text text-muted">Bạn có thể thay đổi tên thuốc nếu lỡ nhập nhầm lô hàng.</div>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Ngày nhập thuốc (Có thể sửa)</label>
                <%-- Format sang yyyy-MM-dd để hiện lên ô input date --%>
                <fmt:formatDate value="${thuocToEdit.ngayNhapThuoc}" pattern="yyyy-MM-dd" var="fmtNgayNhap" />
                <input type="date" name="ngayNhap" value="${fmtNgayNhap}" class="form-control" required>
                <small class="text-muted">Mặc định là ngày đã nhập, bạn có thể sửa lại nếu cần.</small>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label fw-bold">Số lượng tồn kho</label>
                    <input type="number" name="soLuong" value="${thuocToEdit.soLuongTon}" class="form-control" required min="0">
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label fw-bold">Hạn sử dụng</label>
                    <fmt:formatDate value="${thuocToEdit.hanSuDung}" pattern="yyyy-MM-dd" var="fmtHSD" />
                    <input type="date" name="hanSuDung" value="${fmtHSD}" class="form-control" required>
                </div>
            </div>

            <div class="d-grid gap-2 mt-4">
                <button type="submit" class="btn btn-warning py-2 fw-bold text-white">LƯU THAY ĐỔI</button>
                <a href="kho" class="btn btn-outline-secondary py-2">Quay lại</a>
            </div>
        </form>
    </div>
</div>

<%@ include file="fragment/footer.jsp" %>