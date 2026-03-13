<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>Sửa Thông Tin Thuốc</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #71b7e6, #9b59b6);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }
        .form-container {
            background-color: #fff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 500px;
        }
        h1 {
            color: #333;
            margin-bottom: 25px;
            font-size: 1.8em;
            border-bottom: 2px solid #71b7e6;
            padding-bottom: 10px;
        }
        .input-group {
            margin-bottom: 18px;
        }
        .input-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        .input-group input[type="text"],
        .input-group input[type="number"],
        .input-group input[type="date"],
        .input-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
            transition: border-color 0.3s;
        }
        .input-group input:focus, .input-group select:focus {
            border-color: #9b59b6;
            outline: none;
        }
        .save-btn {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 6px;
            background-color: #71b7e6;
            color: white;
            font-size: 1.1em;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-top: 15px;
        }
        .save-btn:hover {
            background-color: #5a9fd6;
        }
        .back-link {
            display: block;
            margin-top: 20px;
            text-align: center;
            color: #9b59b6;
            text-decoration: none;
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="form-container">
    <h1>✏️ Sửa Thông Tin Thuốc (ID: ${thuocToEdit.id})</h1>

    <p style="color: red; font-weight: bold;">${error}</p>

    <form action="<%= request.getContextPath() %>/edit" method="post">

        <input type="hidden" name="id" value="${thuocToEdit.id}">

        <div class="input-group">
            <label>Tên Thuốc:</label>
            <input type="text" name="ten" required value="${thuocToEdit.tenThuoc}">
        </div>

        <div class="input-group">
            <label>Loại Thuốc:</label>
            <select name="loai">
                <option value="Kháng sinh" ${thuocToEdit.loaiThuoc eq 'Kháng sinh' ? 'selected' : ''}>Kháng sinh</option>
                <option value="Giảm đau" ${thuocToEdit.loaiThuoc eq 'Giảm đau' ? 'selected' : ''}>Giảm đau</option>
                <option value="Vitamin" ${thuocToEdit.loaiThuoc eq 'Vitamin' ? 'selected' : ''}>Vitamin</option>
                <option value="Khác" ${thuocToEdit.loaiThuoc eq 'Khác' ? 'selected' : ''}>Khác</option>
            </select>
        </div>

        <div class="input-group">
            <label>Số lượng tồn:</label>
            <input type="number" name="soLuong" required min="0" value="${thuocToEdit.soLuongTon}">
        </div>

        <div class="input-group">
            <label>Hạn sử dụng:</label>
            <fmt:formatDate value="${thuocToEdit.hanSuDung}" pattern="yyyy-MM-dd" var="hanSuDungFormatted" />
            <input type="date" name="hanSuDung" required value="${hanSuDungFormatted}">
        </div>

        <input type="submit" value="Lưu Thay Đổi" class="save-btn">
    </form>

    <a href="<%= request.getContextPath() %>/thuoc" class="back-link">← Hủy và Quay lại</a>
</div>
</body>
</html>