<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. Gọi Header chung --%>
<%@ include file="fragment/header.jsp" %>

<div class="main-content-inner" style="display: flex; justify-content: center; align-items: center; min-height: 80vh; padding: 20px;">

    <div class="detail-card" style="background: white; width: 100%; max-width: 650px; border-radius: 20px; overflow: hidden; box-shadow: 0 15px 35px rgba(0,0,0,0.1);">

        <div style="background: linear-gradient(135deg, var(--primary-dark), var(--secondary-blue)); padding: 40px 30px; text-align: center; color: white;">
            <div style="background: rgba(255,255,255,0.2); width: 80px; height: 80px; line-height: 80px; border-radius: 50%; margin: 0 auto 15px; font-size: 35px;">
                <i class="fas fa-capsules"></i>
            </div>
            <h2 style="margin: 0; font-size: 1.8em; letter-spacing: 1px;">${thuoc.tenThuoc}</h2>
            <p style="margin: 10px 0 0; opacity: 0.8; font-weight: 300;">Mã thuốc: #TH-${thuoc.id}</p>
        </div>

        <div style="padding: 30px;">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 25px;">

                <div>
                    <div style="margin-bottom: 20px;">
                        <label style="display: block; font-size: 0.8em; color: #999; text-transform: uppercase; font-weight: bold; margin-bottom: 5px;">Loại Thuốc</label>
                        <span style="font-size: 1.1em; color: #333; font-weight: 600;">
                            <i class="fas fa-tag" style="color: var(--secondary-blue); margin-right: 8px;"></i>${thuoc.loaiThuoc}
                        </span>
                    </div>

                    <div style="margin-bottom: 20px;">
                        <label style="display: block; font-size: 0.8em; color: #999; text-transform: uppercase; font-weight: bold; margin-bottom: 5px;">Trạng thái hạn dùng</label>

                        <%-- CÁCH TÍNH NGÀY AN TOÀN KHÔNG GÂY LỖI --%>
                        <c:set var="now" value="<%= new java.util.Date() %>" />
                        <c:set var="msPerDay" value="${1000 * 60 * 60 * 24}" />
                        <c:set var="diff" value="${thuoc.hanSuDung.time - now.time}" />
                        <c:set var="daysLeft" value="${diff / msPerDay}" />

                        <c:choose>
                            <c:when test="${daysLeft < 0}">
                                <span style="background: #fee2e2; color: #dc2626; padding: 6px 12px; border-radius: 15px; font-size: 0.85em; font-weight: bold; border: 1px solid #fecaca; display: inline-block;">
                                    <i class="fas fa-times-circle"></i> Hết hạn
                                </span>
                            </c:when>
                            <c:when test="${daysLeft <= 30}">
                                <span style="background: #fef9c3; color: #854d0e; padding: 6px 12px; border-radius: 15px; font-size: 0.85em; font-weight: bold; border: 1px solid #fef08a; display: inline-block;">
                                    <i class="fas fa-exclamation-triangle"></i> Sắp hết hạn
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span style="background: #dcfce7; color: #166534; padding: 6px 12px; border-radius: 15px; font-size: 0.85em; font-weight: bold; border: 1px solid #bbf7d0; display: inline-block;">
                                    <i class="fas fa-check-circle"></i> Còn hạn dùng
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div>
                    <div style="margin-bottom: 20px;">
                        <label style="display: block; font-size: 0.8em; color: #999; text-transform: uppercase; font-weight: bold; margin-bottom: 5px;">Số lượng trong kho</label>
                        <span style="font-size: 1.4em; color: var(--primary-dark); font-weight: 800;">
                            ${thuoc.soLuongTon} <small style="font-size: 0.6em; color: #666;">Đơn vị</small>
                        </span>
                    </div>

                    <div style="margin-bottom: 20px;">
                        <label style="display: block; font-size: 0.8em; color: #999; text-transform: uppercase; font-weight: bold; margin-bottom: 5px;">Ngày hết hạn</label>
                        <span style="font-size: 1.1em; color: #333; font-weight: 600;">
                            <i class="far fa-calendar-alt" style="color: #e67e22; margin-right: 8px;"></i>
                            <fmt:formatDate value="${thuoc.hanSuDung}" pattern="dd/MM/yyyy" />
                        </span>
                    </div>
                </div>
            </div>

            <hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0;">

            <div style="display: flex; justify-content: center; gap: 15px;">
                <a href="<%= request.getContextPath() %>/thuoc" style="flex: 1; text-align: center; padding: 12px; background: #f1f2f6; color: #57606f; border-radius: 10px; text-decoration: none; font-weight: bold;">
                    <i class="fas fa-chevron-left"></i> Trở về
                </a>

                <c:if test="${currentUser.nhomQuyen eq 'ADMIN'}">
                    <a href="<%= request.getContextPath() %>/edit?id=${thuoc.id}" style="flex: 1; text-align: center; padding: 12px; background: linear-gradient(to right, #f39c12, #e67e22); color: white; border-radius: 10px; text-decoration: none; font-weight: bold;">
                        <i class="fas fa-edit"></i> Chỉnh sửa
                    </a>
                </c:if>
            </div>
        </div>
    </div>
</div>

<%@ include file="fragment/footer.jsp" %>