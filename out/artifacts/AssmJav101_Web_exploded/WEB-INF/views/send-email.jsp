<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="fragment/header.jsp" %>

<div class="container-fluid py-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card shadow border-0" style="border-radius: 15px;">
                <div class="card-body p-4 p-md-5">
                    <h2 class="text-center mb-4" style="color: var(--secondary-blue); font-weight: 700;">
                        <i class="fas fa-paper-plane me-2"></i> Gửi Thông Báo Email
                    </h2>

                    <div class="alert alert-info border-0 shadow-sm mb-4" style="background-color: #f0faff;">
                        <p class="mb-0 small text-muted">
                            <strong><i class="fas fa-info-circle me-1"></i> Ghi chú:</strong>
                            Email sẽ được gửi đi từ tài khoản quản trị hệ thống.
                        </p>
                    </div>

                    <form action="<%= request.getContextPath() %>/send-email" method="post">
                        <div class="mb-3 row">
                            <label class="col-sm-3 col-form-label fw-bold">Người nhận:</label>
                            <div class="col-sm-9">
                                <input type="text" name="toRecipients" class="form-control" required
                                       placeholder="email1@example.com, email2@example.com" value="${param.toRecipients}">
                            </div>
                        </div>

                        <div class="mb-3 row">
                            <label class="col-sm-3 col-form-label fw-bold">Chủ đề:</label>
                            <div class="col-sm-9">
                                <input type="text" name="subject" class="form-control" required
                                       placeholder="Nhập tiêu đề email" value="${param.subject}">
                            </div>
                        </div>

                        <div class="mb-4 row">
                            <label class="col-sm-3 col-form-label fw-bold">Nội dung:</label>
                            <div class="col-sm-9">
                                <textarea name="content" rows="6" class="form-control" required
                                          placeholder="Nhập nội dung email tại đây...">${param.content}</textarea>
                            </div>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary btn-lg shadow-sm py-2">
                                <i class="fas fa-paper-plane me-2"></i> Gửi Email
                            </button>
                            <a href="<%= request.getContextPath() %>/thuoc" class="btn btn-link text-center mt-3 text-decoration-none">
                                <i class="fas fa-arrow-left me-1"></i> Quay lại
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="fragment/footer.jsp" %>