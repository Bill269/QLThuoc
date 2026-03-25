<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="fragment/header.jsp" %>

<div class="main-container">
    <div class="table-container" style="max-width: 650px; margin: 30px auto; padding: 40px;">
        <h2 class="mb-4" style="color: #2c3e50; font-weight: 700; border-bottom: 2px solid #2ecc71; padding-bottom: 15px;">
            <i class="fas fa-plus-circle me-2"></i> Nhập thuốc mới vào kho
        </h2>

        <form action="thuoc?action=insert" method="post">
            <div class="row">
                <%-- 1. Tên thuốc --%>
                <div class="col-12 mb-3">
                    <label class="form-label fw-bold text-secondary">Tên dược phẩm</label>
                    <input type="text" name="ten" class="form-control form-control-lg" required placeholder="Ví dụ: Panadol Extra">
                </div>

                <%-- 2. Loại danh mục --%>
                <div class="col-md-6 mb-3">
                    <label class="form-label fw-bold text-secondary">Loại danh mục</label>
                    <select name="loai" class="form-select">
                        <c:forEach var="loai" items="${listLoai}">
                            <option value="${loai.tenLoai}">${loai.tenLoai}</option>
                        </c:forEach>
                    </select>
                </div>

                <%-- 3. BỔ SUNG: GIÁ BÁN (BẮT BUỘC) --%>
                <div class="col-md-6 mb-3">
                    <label class="form-label fw-bold text-secondary">Giá bán (VNĐ)</label>
                    <div class="input-group">
                        <input type="number" name="giaBan" class="form-control" required min="0" step="500" placeholder="0">
                        <span class="input-group-text">₫</span>
                    </div>
                </div>

                <%-- 4. Số lượng --%>
                <div class="col-md-6 mb-3">
                    <label class="form-label fw-bold text-secondary">Số lượng nhập</label>
                    <input type="number" name="soLuong" class="form-control" required min="1" placeholder="Số lượng">
                </div>

                <%-- 5. Hạn sử dụng --%>
                <div class="col-md-6 mb-4">
                    <label class="form-label fw-bold text-secondary">Hạn sử dụng</label>
                    <input type="date" name="hanSuDung" class="form-control" required>
                </div>
            </div>

            <div class="d-grid gap-2 mt-3">
                <button type="submit" class="btn btn-success py-2 fw-bold shadow-sm">
                    <i class="fas fa-save me-2"></i> LƯU VÀO KHO
                </button>
                <a href="thuoc" class="btn btn-outline-secondary py-2 text-decoration-none">
                    <i class="fas fa-times me-2"></i> Hủy bỏ & Quay lại
                </a>
            </div>
        </form>
    </div>
</div>
<%@ include file="fragment/footer.jsp" %>