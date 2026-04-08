<%--
  Created by IntelliJ IDEA.
  User: LAPTOP LE SON
  Date: 4/8/2026
  Time: 10:15 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="fragment/header.jsp" %>

<div class="main-container" style="padding: 20px;">
    <div class="search-bar mb-4 p-4 bg-white shadow-sm rounded border">
        <form action="thuoc" method="get" class="row g-3">
            <input type="hidden" name="action" value="search">
            <div class="col-md-9">
                <input type="text" name="timKiem" class="form-control" placeholder="Tìm theo tên thuốc..." value="${param.timKiem}">
            </div>
            <div class="col-md-3 d-flex gap-2">
                <button type="submit" class="btn btn-primary flex-grow-1"><i class="fas fa-search"></i> Tìm</button>
                <a href="thuoc?action=add_form" class="btn btn-success"><i class="fas fa-plus"></i> Thêm mới</a>
            </div>
        </form>
    </div>

    <div class="table-container bg-white p-3 rounded shadow-sm">
        <%-- Thông báo Thất bại cho Thuốc cha --%>
        <c:if test="${param.error == 'has_lots'}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>Thao tác bị từ chối!</strong> Thuốc này đã có dữ liệu lô hàng trong kho. Vui lòng kiểm tra lại trước khi xóa.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <%-- Thông báo Thành công cho Thuốc cha --%>
        <c:if test="${param.msg == 'deleted'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                Xóa thuốc thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <table class="table table-hover">
            <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Tên Thuốc</th>
                <th>Loại</th>
                <th>Giá Bán</th>
                <th>Đơn vị</th>
                <th>Tình Trạng</th>
                <th>Thao Tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="t" items="${listThuocCha}">
                <tr>
                    <td>#${t.id}</td>
                    <td class="fw-bold">${t.ten_thuoc_cha}</td>
                    <td>${t.loaiThuoc.tenLoai}</td>
                    <td><fmt:formatNumber value="${t.gia_mac_dinh}" type="currency" currencySymbol="đ"/></td>
                    <td>${t.donViTinh.tenDonVi}</td>
                    <td>
                            <span class="badge ${t.tinh_trang ? 'bg-success' : 'bg-danger'}">
                                    ${t.tinh_trang ? 'Còn bán' : 'Ngưng bán'}
                            </span>
                    </td>
                    <td>
                        <a href="thuoc?action=detail&id=${t.id}" class="btn btn-sm btn-info text-white"><i class="fas fa-eye"></i></a>
                        <a href="thuoc?action=edit_form&id=${t.id}" class="btn btn-sm btn-warning text-white"><i class="fas fa-edit"></i></a>
                        <a href="thuoc?action=delete&id=${t.id}" onclick="return confirm('Xóa thuốc này?')" class="btn btn-sm btn-danger"><i class="fas fa-trash"></i></a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<%@ include file="fragment/footer.jsp" %>
