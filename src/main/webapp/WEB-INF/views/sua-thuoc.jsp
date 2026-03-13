<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>Cập Nhật Thông Tin Thuốc</title>
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
            text-align: center;
            margin-bottom: 25px;
            font-size: 1.8em;
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
        }
        .input-group { margin-bottom: 15px; }
        .input-group label { display: block; margin-bottom: 8px; font-weight: bold; color: #555; }
        .input-group input, .input-group select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 1em;
        }
        .input-group input:focus {
            border-color: #9b59b6;
            outline: none;
            box-shadow: 0 0 5px rgba(155, 89, 182, 0.2);
        }
        .btn-submit {
            width: 100%;
            padding: 14px;
            background: #27ae60;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            font-size: 1.1em;
            transition: background 0.3s;
            margin-top: 10px;
        }
        .btn-submit:hover {
            background: #219150;
        }
        .btn-back {
            display: block;
            text-align: center;
            margin-top: 15px;
            color: #7f8c8d;
            text-decoration: none;
            font-size: 0.9em;
        }
        .btn-back:hover {
            color: #34495e;
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="form-container">
    <h1><i class="fas fa-edit"></i> Sửa Thông Tin</h1>

    <form action="edit" method="post">
        <input type="hidden" name="id" value="${thuocToEdit.id}">

        <div class="input-group">
            <label>Tên Thuốc:</label>
            <input type="text" name="ten" value="${thuocToEdit.tenThuoc}" required placeholder="Nhập tên thuốc">
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
            <input type="number" name="soLuong" value="${thuocToEdit.soLuongTon}" required min="0">
        </div>

        <div class="input-group">
            <label>Hạn sử dụng:</label>
            <fmt:formatDate value="${thuocToEdit.hanSuDung}" pattern="yyyy-MM-dd" var="formattedDate" />
            <input type="date" name="hanSuDung" value="${formattedDate}" required>
        </div>

        <button type="submit" class="btn-submit">CẬP NHẬT NGAY</button>
        <a href="thuoc" class="btn-back">← Quay lại danh sách</a>
    </form>
</div>

<script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
</body>
</html>