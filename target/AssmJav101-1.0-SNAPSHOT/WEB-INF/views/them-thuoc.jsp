<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="fragment/header.jsp" %>

<div style="display: flex; justify-content: center; align-items: center; min-height: 75vh; width: 100%;">

    <div class="form-container" style="background: white; padding: 40px; border-radius: 15px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); width: 100%; max-width: 500px;">
        <h1 class="form-title" style="text-align: center; color: var(--primary-dark); margin-bottom: 30px; border-bottom: 2px solid var(--secondary-blue); padding-bottom: 10px;">
            <i class="fas fa-plus-circle"></i> Thêm Thuốc Mới
        </h1>

        <c:if test="${not empty error}">
            <div style="background: #fff5f5; color: #e74c3c; padding: 15px; border-radius: 8px; border: 1px solid #ffcccc; margin-bottom: 20px; text-align: center; font-weight: 600;">
                <i class="fas fa-exclamation-triangle"></i> ${error}
            </div>
        </c:if>

        <form action="<%= request.getContextPath() %>/add" method="post">

            <div class="input-group" style="margin-bottom: 20px;">
                <label style="display: block; font-weight: bold; margin-bottom: 8px; color: #555;">Tên Thuốc:</label>
                <input type="text" name="ten" required placeholder="Ví dụ: Paracetamol 500mg"
                       style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 1em;">
            </div>

            <div class="input-group" style="margin-bottom: 20px;">
                <label style="display: block; font-weight: bold; margin-bottom: 8px; color: #555;">Loại Thuốc:</label>
                <select name="loai" style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 1em; background-color: white;">
                    <option value="Kháng sinh">Kháng sinh</option>
                    <option value="Giảm đau">Giảm đau</option>
                    <option value="Vitamin">Vitamin</option>
                    <option value="Thực phẩm chức năng">Thực phẩm chức năng</option>
                    <option value="Khác">Khác</option>
                </select>
            </div>

            <div class="input-group" style="margin-bottom: 20px;">
                <label style="display: block; font-weight: bold; margin-bottom: 8px; color: #555;">Số lượng nhập kho:</label>
                <input type="number" name="soLuong" required min="1" placeholder="Nhập số lượng"
                       style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 1em;">
            </div>

            <div class="input-group" style="margin-bottom: 30px;">
                <label style="display: block; font-weight: bold; margin-bottom: 8px; color: #555;">Hạn sử dụng:</label>
                <input type="date" name="hanSuDung" required
                       style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 1em;">
            </div>

            <button type="submit" class="save-btn" style="width: 100%; padding: 14px; background: linear-gradient(to right, #27ae60, #2ecc71); color: white; border: none; border-radius: 8px; font-size: 1.1em; font-weight: bold; cursor: pointer; transition: 0.3s;">
                <i class="fas fa-save"></i> LƯU VÀO KHO
            </button>
        </form>

        <a href="<%= request.getContextPath() %>/thuoc" class="back-link" style="display: block; text-align: center; margin-top: 20px; color: #7f8c8d; text-decoration: none; font-size: 0.9em;">
            <i class="fas fa-arrow-left"></i> Quay lại danh sách
        </a>
    </div>
</div>

<%@ include file="fragment/footer.jsp" %>