<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="fragment/header.jsp" %>

<div style="display: flex; justify-content: center; align-items: center; min-height: 70vh; width: 100%;">

    <div class="form-container" style="max-width: 700px;">


        <c:if test="${not empty success}">
            <p style="color: var(--success); font-weight: bold; padding: 10px; background: #e6fff0; border-radius: 4px; text-align: center; margin-bottom: 15px;">
                <i class="fas fa-check-circle"></i> ${success}
            </p>
        </c:if>
        <c:if test="${not empty error}">
            <p class="error-message" style="text-align: center; margin-bottom: 15px;">
                <i class="fas fa-exclamation-triangle"></i> ${error}
            </p>
        </c:if>

        <form action="<%= request.getContextPath() %>/send-email" method="post">

            <div style="margin-bottom: 20px; padding: 15px; border: 1px dashed #ccc; border-radius: 6px; background-color: #f7f7f7; text-align: left;">
                <p style="font-weight: bold; color: #333; margin-bottom: 8px;">Ghi chú:</p>
                <p style="font-size: 0.9em; color: #666;">
                    Email sẽ được gửi đi từ tài khoản admin!
                </p>
            </div>

            <div class="input-group">
                <label>Người nhận (TO)</label>
                <input type="text" name="toRecipients" required placeholder="email1@example.com, email2@example.com"
                       value="${param.toRecipients}">
            </div>

            <div class="input-group">
                <label>Tên chủ đề</label>
                <input type="text" name="subject" required placeholder="Nhập chủ đề email"
                       value="${param.subject}">
            </div>

            <div class="input-group">
                <label>Nội dung Email</label>
                <textarea name="content" rows="8" required style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; transition: border-color 0.3s;">${param.content}</textarea>
            </div>

            <input type="submit" value="Gửi Email" class="save-btn">
        </form>

        <a href="<%= request.getContextPath() %>/thuoc" class="back-link" style="margin-top: 20px; display: block; text-align: center; color: #3498db; text-decoration: none;">
            <i class="fas fa-arrow-left"></i> Quay lại
        </a>
    </div>
</div>

<%@ include file="fragment/footer.jsp" %>