<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Hóa Đơn</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .wrapper { display: flex; width: 100%; align-items: stretch; }
        #content { width: 100%; padding: 20px; min-height: 100vh; background: #f8f9fa; }
    </style>
</head>
<body>
<div class="wrapper">
    <%@ include file="fragment/header.jsp" %>

    <div id="content">
        <div class="container-fluid">
            <h2 class="mb-4">Nhật Ký Giao Dịch Thuốc</h2>

            <div class="card shadow-sm">
                <div class="card-body">
                    <table class="table table-bordered table-hover">
                        <thead class="table-dark">
                        <tr>
                            <th>Mã Hóa Đơn</th>
                            <th>Tên Thuốc</th>
                            <th>Loại Thuốc</th>
                            <th>Số Lượng Bán</th>
                            <th>Trạng Thái</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="hd" items="${listHD}">
                            <tr>
                                <td>${hd.idHoaDon}</td>
                                <td>${hd.tenThuoc}</td>
                                <td>${hd.loaiThuoc}</td>
                                <td>1</td>
                                <td><span class="badge bg-success">Thành công</span></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty listHD}">
                            <tr>
                                <td colspan="5" class="text-center">Chưa có giao dịch nào.</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>