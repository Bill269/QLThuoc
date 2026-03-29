<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="fragment/header.jsp" %>

<div class="main-container">
    <div class="table-container" style="max-width: 650px; margin: 30px auto; padding: 40px;">
        <h2 class="mb-4" style="color: #2c3e50; font-weight: 700; border-bottom: 2px solid #f39c12; padding-bottom: 15px;">
            <i class="fas fa-edit me-2"></i> Cập nhật thông tin thuốc
        </h2>

        <form action="thuoc?action=update" method="post">
            <input type="hidden" name="id" value="${thuocToEdit.id}">

            <div class="row">
                <div class="col-12 mb-3">
                    <label class="form-label fw-bold text-secondary">Tên dược phẩm</label>
                    <input type="text" name="ten" value="${thuocToEdit.tenThuoc}" class="form-control" required>
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label fw-bold text-secondary">Loại thuốc</label>
                    <select name="idLoai" class="form-select">
                        <c:forEach var="loai" items="${listLoai}">
                            <option value="${loai.id}" ${thuocToEdit.idLoai == loai.id ? 'selected' : ''}>
                                    ${loai.tenLoai}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <%-- BỔ SUNG: Đơn vị tính --%>
                <div class="col-md-6 mb-3">
                    <label class="form-label fw-bold text-secondary">Đơn vị tính</label>
                    <select name="idDonVi" class="form-select">
                        <c:forEach var="dv" items="${listDonVi}">
                            <option value="${dv.id}" ${thuocToEdit.idDonVi == dv.id ? 'selected' : ''}>
                                    ${dv.tenDonVi}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label fw-bold text-secondary">Giá bán (VNĐ)</label>
                    <div class="input-group">
                        <input type="number" name="giaBan" value="${thuocToEdit.giaBan}" class="form-control" required min="0">
                        <span class="input-group-text">₫</span>
                    </div>
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label fw-bold text-secondary">Tồn kho</label>
                    <input type="number" name="soLuong" value="${thuocToEdit.soLuongTon}" class="form-control" required min="0">
                </div>

                <%--Bổ sung ngày nhập thuốc--%>
                <div class="col-12 mb-4">
                    <label class="form-label fw-bold text-secondary">Ngày nhập thuốc</label>
                    <fmt:formatDate value="${thuocToEdit.ngayNhapThuoc}" pattern="yyyy-MM-dd" var="fmtD" />
                    <input type="date" name="ngayNhap" value="${fmtD}" class="form-control" required>
                </div>

                <div class="col-12 mb-4">
                    <label class="form-label fw-bold text-secondary">Hạn sử dụng</label>
                    <fmt:formatDate value="${thuocToEdit.hanSuDung}" pattern="yyyy-MM-dd" var="fmtD" />
                    <input type="date" name="hanSuDung" value="${fmtD}" class="form-control" required>
                </div>
            </div>

            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-warning py-2 fw-bold text-white shadow-sm">
                    <i class="fas fa-check-circle me-1"></i> XÁC NHẬN SỬA
                </button>
                <a href="thuoc" class="btn btn-outline-secondary text-decoration-none py-2">Quay lại danh sách</a>
            </div>
        </form>
    </div>
</div>
<%@ include file="fragment/footer.jsp" %>