<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="fragment/header.jsp" %>

<div class="main-container py-4">
    <div class="container-fluid">
        <div class="row align-items-center mb-4 g-3">
            <div class="col-md-7">
                <h2 class="fw-bold text-dark m-0">
                    <i class="fas fa-layer-group text-primary me-2"></i>Quản Lý Danh Mục
                </h2>
            </div>
            <div class="col-md-5">
                <div class="input-group shadow-sm">
                    <span class="input-group-text bg-white border-end-0">
                        <i class="fas fa-search text-muted"></i>
                    </span>
                    <input type="text" id="searchInput" class="form-control border-start-0 ps-0"
                           placeholder="Tìm kiếm loại thuốc nhanh...">
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-lg-4">
                <div class="card border-0 shadow-sm" style="border-radius: 15px;">
                    <div class="card-body p-4">
                        <h5 class="card-title fw-bold mb-4">Thêm loại mới</h5>
                        <form action="loai-thuoc?action=insert" method="post">
                            <div class="mb-3">
                                <label class="form-label small fw-bold text-uppercase text-muted">Tên loại thuốc</label>
                                <input type="text" name="tenLoai" class="form-control form-control-lg"
                                       placeholder="Ví dụ: Thuốc hạ sốt" required>
                                <br>
                                <label class="form-label small fw-bold text-uppercase text-muted">Trạng thái</label>
                                <div class="d-flex gap-3 mt-1 mb-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="trangThai" id="active" value="true" checked>
                                        <label class="form-check-label" for="active">
                                            Còn hoạt động
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="trangThai" id="inactive" value="false">
                                        <label class="form-check-label" for="inactive">
                                            Ngừng hoạt động
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary btn-lg w-100 shadow-sm mt-2"
                                    style="background-color: #2c3e50; border: none;">
                                <i class="fas fa-plus me-2"></i>Thêm vào danh sách
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-lg-8">
                <div class="card border-0 shadow-sm" style="border-radius: 15px; overflow: hidden;">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle m-0" id="categoryTable">
                            <thead class="table-light">
                            <tr>
                                <th class="ps-4 py-3" style="width: 100px;">Mã ID</th>
                                <th class="py-3">Tên Loại Thuốc</th>
                                <th class="py-3">Trạng thái</th>
                                <th class="py-3 text-center" style="width: 200px;">Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="item" items="${listLoai}">
                                <tr>
                                    <td class="ps-4 text-muted fw-bold">#${item.id}</td>
                                    <td class="fw-bold text-dark category-name">${item.tenLoai}</td>
                                    <td class="fw-bold text-dark category-name">${item.trangThai == true ? "Còn hoạt động" : "Ngừng hoạt động"}</td>
                                    <td class="text-center">
                                        <div class="btn-group shadow-sm" role="group">
                                            <button class="btn btn-white btn-sm text-warning border"
                                                    onclick="openEditModal('${item.id}', '${item.tenLoai}', '${item.trangThai}')" title="Sửa">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <a href="loai-thuoc?action=delete&id=${item.id}"
                                               class="btn btn-white btn-sm text-danger border"
                                               onclick="return confirm('Xóa loại này sẽ ảnh hưởng đến các thuốc liên quan. Bạn chắc chứ?')" title="Xóa">
                                                <i class="fas fa-trash-alt"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listLoai}">
                                <tr>
                                    <td colspan="3" class="text-center py-5 text-muted">
                                        <i class="fas fa-folder-open d-block mb-2 fs-2"></i>
                                        Chưa có dữ liệu loại thuốc.
                                    </td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 15px;">
            <div class="modal-header border-0">
                <h5 class="modal-title fw-bold"><i class="fas fa-pen me-2"></i>Chỉnh sửa loại thuốc</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="loai-thuoc?action=update" method="post">
                <div class="modal-body p-4">
                    <input type="hidden" name="id" id="editId">

                    <div class="mb-4">
                        <label class="form-label fw-bold text-muted small text-uppercase">Tên loại thuốc mới</label>
                        <input type="text" name="tenLoai" id="editTen" class="form-control form-control-lg border-2"
                               placeholder="Nhập tên mới..." required>
                    </div>

                    <div class="mb-2">
                        <label class="form-label fw-bold text-muted small text-uppercase">Trạng thái loại thuốc</label>
                        <div class="d-flex gap-4 mt-2">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="trangThai" id="editTrangThaiTrue" value="true">
                                <label class="form-check-label cursor-pointer" for="editTrangThaiTrue">
                                    Còn hoạt động
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="trangThai" id="editTrangThaiFalse" value="false">
                                <label class="form-check-label cursor-pointer" for="editTrangThaiFalse">
                                    Ngừng hoạt động
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer border-0 pb-4 px-4">
                    <button type="button" class="btn btn-light px-4 fw-bold" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-primary px-4 fw-bold shadow-sm" style="background-color: #2c3e50; border: none;">
                        <i class="fas fa-save me-2"></i>Cập nhật thay đổi
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Tìm kiếm nhanh
    document.getElementById('searchInput').addEventListener('keyup', function() {
        let filter = this.value.toLowerCase();
        let rows = document.querySelectorAll('#categoryTable tbody tr');
        rows.forEach(row => {
            let nameCell = row.querySelector('.category-name');
            if(nameCell) {
                let name = nameCell.textContent.toLowerCase();
                row.style.display = name.includes(filter) ? '' : 'none';
            }
        });
    });

    function openEditModal(id, ten, trangthai) {
        document.getElementById('editId').value = id;
        document.getElementById('editTen').value = ten;
        if(trangthai == true || trangthai == "true"){
            document.getElementById('editTrangThaiTrue').checked = true;
        }else{
            document.getElementById('editTrangThaiFalse').checked = true;
        }
        new bootstrap.Modal(document.getElementById('editModal')).show();
    }
</script>

<%@ include file="fragment/footer.jsp" %>