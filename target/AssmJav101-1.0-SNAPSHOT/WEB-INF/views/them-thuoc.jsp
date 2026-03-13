<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 1. GỌI HEADER: Mở cấu trúc HTML, BODY, Sidebar, Topbar, và div class="content" --%>
<%@ include file="fragment/header.jsp" %>

<%-- Bỏ TOÀN BỘ thẻ <style> ra khỏi đây và chuyển sang header.jsp --%>

<div style="display: flex; justify-content: center; align-items: center; min-height: 70vh; width: 100%;">

    <div class="form-container">
        <h1 class="form-title">Thêm Thuốc Mới</h1>

        <c:if test="${not empty error}">
            <p class="error-message">
                    ${error}
            </p>
        </c:if>

        <form action="<%= request.getContextPath() %>/add" method="post">
            <div class="input-group">
                <label>Tên Thuốc:</label>
                <input type="text" name="ten" required placeholder="Ví dụ: Paracetamol">
            </div>

            <div class="input-group">
                <label>Loại Thuốc:</label>
                <select name="loai">
                    <option value="Kháng sinh">Kháng sinh</option>
                    <option value="Giảm đau">Giảm đau</option>
                    <option value="Vitamin">Vitamin</option>
                    <option value="Khác">Khác</option>
                </select>
            </div>

            <div class="input-group">
                <label>Số lượng tồn:</label>
                <input type="number" name="soLuong" required min="0" placeholder="Số lượng nhập kho">
            </div>

            <div class="input-group">
                <label>Hạn sử dụng:</label>
                <input type="date" name="hanSuDung" required>
            </div>

            <input type="submit" value="Lưu Thuốc" class="save-btn">
        </form>

        <a href="<%= request.getContextPath() %>/thuoc" class="back-link" style="margin-top: 20px;">
            <i class="fas fa-arrow-left"></i> Quay lại Danh sách
        </a>
    </div>
</div>

<%-- 2. GỌI FOOTER: Đóng cấu trúc layout --%>
<%@ include file="fragment/footer.jsp" %>