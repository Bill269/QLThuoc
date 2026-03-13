<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="currentUser" value="${sessionScope.currentUser}"/>

<!DOCTYPE html>
<html>
<head>
    <title>Quản Lý Thuốc - Hệ Thống Nhà Thuốc</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        :root {
            --primary-dark: #1e1e2f;
            --secondary-blue: #3498db;
            --success: #2ecc71;
            --warning: #f39c12;
            --danger: #e74c3c;
            --bg-light: #f4f6f8;
            --blue-save: #5bc0de;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            display: flex;
            min-height: 100vh;
            background-color: var(--bg-light);
        }

        .sidebar {
            width: 220px;
            background: linear-gradient(135deg, #526677, #838383);
            color: #fff;
            display: flex;
            flex-direction: column;
            padding: 20px;
        }

        .sidebar h2 {
            margin-bottom: 30px;
            font-size: 1.4rem;
            text-align: center;
            color: #71b7e6;
        }

        .sidebar a {
            color: #bbb;
            text-decoration: none;
            padding: 12px 10px;
            border-radius: 4px;
            display: block;
            margin-bottom: 5px;
            transition: background 0.3s, color 0.3s;
            font-size: 0.95rem;
        }

        .sidebar a.active {
            background-color: #33334d;
            color: #fff;
            border-left: 4px solid var(--secondary-blue);
            padding-left: 6px;
        }

        .sidebar a:not(.active):hover {
            background-color: #33334d;
            color: #fff;
        }

        .sidebar i {
            margin-right: 10px;
        }

        .main {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .topbar {
            background-color: #fff;
            padding: 15px 25px;
            border-bottom: 1px solid #ddd;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .topbar h1 {
            font-size: 1.5rem;
            color: #333;
        }

        .topbar .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .content {
            padding: 30px;
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 10px;
        }

        .card {
            background-color: #fff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            transition: transform 0.2s;
        }

        .card:hover {
            transform: translateY(-3px);
        }

        .card h3 {
            margin-bottom: 15px;
            font-size: 1rem;
            color: #7f8c8d;
        }

        .card p {
            font-size: 2.2rem;
            font-weight: bold;
            text-align: right;
        }

        .card-total p {
            color: var(--secondary-blue);
        }

        .card-stock p {
            color: var(--success);
        }

        .card-warning {
            border-bottom: 5px solid var(--warning);
            background-color: #fff8e6;
        }

        .card-warning p {
            color: var(--warning);
        }

        .card-danger {
            border-bottom: 5px solid var(--danger);
            background-color: #fcebeb;
        }

        .card-danger p {
            color: var(--danger);
        }

        .table-container {
            background-color: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .action-bar {
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .add-btn {
            background-color: var(--success);
            color: white;
            padding: 10px 15px;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
            transition: background-color 0.3s;
        }

        .add-btn:hover {
            background-color: #27ae60;
        }

        .filter-form {
            display: flex;
            gap: 15px;
            align-items: center;
            padding: 15px;
            background-color: #ecf0f1;
            border-radius: 8px;
            margin-bottom: 25px;
        }

        .filter-form select {
            padding: 8px;
            border-radius: 4px;
            border: 1px solid #ccc;
        }

        .filter-form input[type="submit"] {
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            background-color: var(--secondary-blue);
            color: white;
            cursor: pointer;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .data-table th, .data-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        .data-table th {
            background-color: #71b7e6;
            color: white;
            font-weight: 600;
        }

        .data-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .data-table tr:hover {
            background-color: #f1f1f1;
        }

        .action-link {
            text-decoration: none;
            padding: 6px 10px;
            border-radius: 4px;
            font-size: 0.9em;
            display: inline-block;
            margin-right: 5px;
        }

        .edit-link {
            background-color: var(--warning);
            color: white;
        }

        .delete-link {
            background-color: var(--danger);
            color: white;
        }

        .text-xem, .view-link {
            background-color: #00d3ff;
            color: white;
        }

        .text-warning-bold {
            color: var(--warning);
            font-weight: bold;
        }

        .text-danger-bold {
            color: var(--danger);
            font-weight: bold;
        }

        .expired-row {
            background-color: #fcebeb !important;
        }

        .warning-row {
            background-color: #fff9e6 !important;
        }

        .sidebar .logout-link-sidebar {
            margin-top: auto;
            background-color: var(--danger);
            color: white;
            text-align: center;
            padding: 12px 10px;
            font-weight: bold;
            border-radius: 4px;
            transition: background-color 0.3s;
        }

        .sidebar .logout-link-sidebar:hover {
            background-color: #c0392b;
        }

        .add-edit-form-container {
            padding: 30px;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            max-width: 600px;
            margin: 0 auto;
        }

        .form-title {
            margin-bottom: 25px;
            color: var(--secondary-blue);
            border-bottom: 2px solid var(--secondary-blue);
            padding-bottom: 10px;
            font-size: 1.8rem;
        }

        .form-field {
            margin-bottom: 20px;
        }

        .form-field label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
            color: #333;
        }

        .form-field input[type="text"],
        .form-field input[type="number"],
        .form-field input[type="date"],
        .form-field select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
            transition: border-color 0.3s;
        }

        .form-field input:focus,
        .form-field select:focus {
            border-color: var(--secondary-blue);
            outline: none;
        }

        .btn-save-primary {
            background-color: var(--blue-save);
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .btn-save-primary:hover {
            background-color: #46b8da;
        }

        .btn-cancel-danger {
            background-color: var(--danger);
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            margin-left: 10px;
            transition: background-color 0.3s;
        }

        .btn-cancel-danger:hover {
            background-color: #c0392b;
        }
        /* Đảm bảo trong phần <style> của header.jsp hoặc file CSS có đoạn này */
        .main-layout-wrapper {
            display: flex; /* Giữ lại thuộc tính này trong CSS */
            min-height: 100vh;
            width: 100%;
        }

        .main {
            flex: 1; /* Rất quan trọng để chiếm hết phần còn lại */
            display: flex;
            flex-direction: column;
        }
        .form-container {
            background-color: #fff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 600px;
            margin: 0 auto;
        }

        h1.form-title {
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
    </style>
</head>
<body>
<div class="main-layout-wrapper">
    <%@ include file="sidebar.jsp" %>
    <div class="main">
        <div class="topbar">
            <h1>${pageTitle}</h1>
            <div class="user-info">
                <span>Xin chào, <b>${currentUser.tenDangNhap}</b></span>
            </div>
        </div>
        <div class="content">