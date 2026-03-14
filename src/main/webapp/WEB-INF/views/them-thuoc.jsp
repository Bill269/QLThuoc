<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="fragment/header.jsp" %>

<div class="main-container">
    <div class="table-container" style="max-width: 650px; margin: 30px auto; padding: 40px;">
        <h2 class="mb-4" style="color: #2c3e50; font-weight: 700; border-bottom: 2px solid #2ecc71; padding-bottom: 15px;">
            <i class="fas fa-plus-circle me-2"></i> Nhập thuốc mới vào kho
        </h2>

        <form action="thuoc?action=insert" method="post">
            <div class="row">
                <div class="col-12 mb-3">
                    <label class="form-label fw-bold text-secondary">Tên thuốc</label>
                    <input type="text" name="ten" class="form-control" required placeholder="Ví dụ: Paracetamol">
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label fw-bold text-secondary">Loại danh mục</label>
                    <select name="loai" class="form-select">
                        <c:forEach var="loai" items="${listLoai}">
                            <option value="${loai.tenLoai}">${loai.tenLoai}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label fw-bold text-secondary">Số lượng</label>
                    <input type="number" name="soLuong" class="form-control" required min="1">
                </div>

                <div class="col-12 mb-4">
                    <label class="form-label fw-bold text-secondary">Hạn sử dụng</label>
                    <input type="date" name="hanSuDung" class="form-control" required>
                </div>
            </div>

            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-success py-2 fw-bold shadow-sm">LƯU VÀO KHO</button>
                <a href="thuoc" class="btn btn-link text-secondary text-decoration-none">Hủy bỏ</a>
            </div>
        </form>
    </div>
</div>
<%@ include file="fragment/footer.jsp" %>