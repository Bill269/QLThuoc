<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="currentUser" value="${sessionScope.currentUser}"/>

<!DOCTYPE html>
<html>
<head>
    <title>Quản Lý Thuốc - Hệ Thống Nhà Thuốc</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        :root {
            --primary-dark: #1e1e2f;
            --secondary-blue: #3498db;
            --bg-light: #f4f6f8;
            --sidebar-bg: #343a40;
        }

        body {
            background-color: var(--bg-light);
            overflow-x: hidden;
        }

        /* Wrapper chính */
        .main-layout-wrapper {
            display: flex;
            width: 100%;
            min-height: 100vh;
            transition: all 0.3s;
        }

        /* Nội dung bên phải */
        .main {
            flex: 1;
            display: flex;
            flex-direction: column;
            min-width: 0; /* Quan trọng để flexbox co giãn đúng */
            transition: all 0.3s;
        }

        .topbar {
            background-color: #fff;
            padding: 15px 25px;
            border-bottom: 1px solid #ddd;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .content {
            padding: 30px;
            flex: 1;
        }

        /* CSS bổ sung cho các bảng và form hiện tại của bạn */
        .table-container, .form-container {
            background-color: #fff;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }
    </style>
</head>
<body>
<div class="main-layout-wrapper">
    <%@ include file="sidebar.jsp" %>
    <div class="main">
        <div class="topbar">
            <button id="sidebarToggle" class="btn btn-outline-secondary me-3">
                <i class="fas fa-bars"></i>
            </button>
            <h1 class="h4 mb-0 flex-grow-1">${pageTitle}</h1>
            <div class="user-info">
                <span>Xin chào, <b>${currentUser.tenDangNhap}</b></span>
            </div>
        </div>
        <div class="content">