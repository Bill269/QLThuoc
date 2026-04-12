<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>Nhật Ký Giao Dịch | Quản Lý Thuốc</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body { background-color: #f4f7f6; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .wrapper { display: flex; width: 100%; align-items: stretch; }
        #content { width: 100%; padding: 30px; min-height: 100vh; }

        /* Custom Table Style */
        .card { border: none; border-radius: 15px; overflow: hidden; }
        .table thead { background-color: #2c3e50; color: white; }
        .table-hover tbody tr:hover { background-color: #f1f4f9; transition: 0.3s; }
        .badge-status { padding: 8px 12px; border-radius: 30px; font-weight: 500; }

        /* Mã hóa đơn nổi bật */
        .invoice-id { color: #3498db; font-weight: bold; font-family: 'Courier New', Courier, monospace; }

        /* Căn chỉnh các dòng trong ô khi có nhiều thuốc */
        .item-row { height: 25px; display: flex; align-items: center; }
        hr { margin: 0.5rem 0; }
    </style>
</head>
<body>
<div class="wrapper">
    <%@ include file="fragment/header.jsp" %>

    <div id="content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark"><i class="fas fa-history text-primary me-2"></i>Nhật Ký Giao Dịch Thuốc</h2>
                    <p class="text-muted">Theo dõi lịch sử bán hàng và chi tiết các hóa đơn đã xuất.</p>
                </div>
                <button onclick="window.print()" class="btn btn-outline-secondary">
                    <i class="fas fa-print me-1"></i> In báo cáo
                </button>
            </div>

            <div class="card shadow-sm">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="text-uppercase small fw-bolder">
                            <tr>
                                <th class="ps-4 py-3">Mã Hóa Đơn</th>
                                <th>Tên Thuốc</th>
                                <th>Loại Thuốc</th>
                                <th class="text-center">Số Lượng</th>
                                <th class="text-center">Trạng Thái</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="hd" items="${listHD}">
                                <tr>
                                    <td class="ps-4 py-3 align-middle">
                                        <span class="invoice-id">#${hd.id}</span>
                                        <div class="small text-muted">
                                            <fmt:formatDate value="${hd.ngayLap}" pattern="HH:mm dd/MM/yyyy"/>
                                        </div>
                                    </td>

                                    <td class="py-3">
                                        <c:forEach var="ct" items="${hd.chiTietList}" varStatus="status">
                                            <div class="item-row">
                                                <i class="fas fa-pills text-primary me-2 small"></i>
                                                <strong>${ct.tenThuoc}</strong>
                                            </div>
                                            <c:if test="${!status.last}"><hr class="opacity-25"></c:if>
                                        </c:forEach>
                                    </td>

                                    <td class="align-middle">
                                        <c:forEach var="ct" items="${hd.chiTietList}" varStatus="status">
                                            <div class="item-row">
                                                <span class="badge bg-light text-dark border font-monospace">${ct.loaiThuoc}</span>
                                            </div>
                                            <c:if test="${!status.last}"><hr style="visibility: hidden;"></c:if>
                                        </c:forEach>
                                    </td>

                                    <td class="text-center align-middle">
                                        <c:forEach var="ct" items="${hd.chiTietList}" varStatus="status">
                                            <div class="item-row justify-content-center fw-bold text-secondary">
                                                x${ct.soLuong}
                                            </div>
                                            <c:if test="${!status.last}"><hr style="visibility: hidden;"></c:if>
                                        </c:forEach>
                                    </td>

                                    <td class="text-center align-middle">
                                        <span class="badge bg-success-subtle text-success badge-status border border-success">
                                            <i class="fas fa-check-circle me-1"></i> Hoàn tất
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty listHD}">
                                <tr>
                                    <td colspan="5" class="text-center py-5 text-muted">
                                        Chưa có giao dịch nào được thực hiện.
                                    </td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="mt-3 text-end text-muted small">
                <p>Hiển thị danh sách giao dịch mới nhất được thực hiện bởi hệ thống.</p>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>