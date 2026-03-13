<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Đăng Nhập Hệ Thống</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #e3e8ec, #ffffff);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }

        .login-container {
            background-color: #fff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 380px;
            text-align: center;
        }

        h1 {
            color: #333;
            margin-bottom: 30px;
            font-size: 1.8em;
            border-bottom: 2px solid #9b59b6;
            padding-bottom: 10px;
        }

        .input-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .input-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }

        .input-group input[type="text"],
        .input-group input[type="password"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            box-sizing: border-box;
            transition: border-color 0.3s;
        }

        .input-group input:focus {
            border-color: #9b59b6;
            outline: none;
        }

        .error-message {
            color: #e74c3c;
            margin-bottom: 20px;
            font-weight: 600;
        }

        .login-btn {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 8px;
            background-color: #9b59b6;
            color: white;
            font-size: 1.1em;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .login-btn:hover {
            background-color: #8e44ad;
        }
    </style>
</head>
<body>
<div class="login-container">
    <h1>Đăng Nhập</h1>

    <div class="error-message">
        ${requestScope.error}
    </div>

    <form action="login" method="post">
        <div class="input-group">
            <label for="username">Tên đăng nhập</label>
            <input type="text"
                   id="username"
                   name="username"
                   required
                   placeholder="Nhập tên đăng nhập"
                   value="${savedUsername}">
        </div>

        <div class="input-group">
            <label for="password">Mật khẩu</label>
            <input type="password" id="password" name="password" required placeholder="Nhập mật khẩu">
        </div>

        <input type="submit" value="Đăng Nhập" class="login-btn">
    </form>
</div>
</body>
</html>