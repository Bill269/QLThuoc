# 💊 Hệ Thống Quản Lý Kho Thuốc - Pharmacy Management System ✅

![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=white)
![Servlet](https://img.shields.io/badge/Servlet-007396?style=for-the-badge&logo=java&logoColor=white)
![MSSQL](https://img.shields.io/badge/SQL_Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-blue?style=for-the-badge)

Hệ thống quản lý kho thuốc hỗ trợ người bán thuốc theo dõi tồn kho, cảnh báo hạn sử dụng, quản lý danh mục và tài khoản, đồng thời phục vụ bán hàng và hóa đơn.

## 🚀 Tính năng nổi bật

- **Quản lý kho thuốc:** Thêm, sửa, xóa, xem chi tiết và tìm kiếm thuốc.
- **Cảnh báo thông minh:** Tự động hiển thị trạng thái:
  - 🔴 **Hết hạn:** Thuốc đã quá hạn sử dụng.
  - 🟠 **Sắp hết hạn:** Cảnh báo trước 30 ngày.
  - 🟢 **Còn hạn:** Thuốc đang trong trạng thái an toàn.
- **Thống kê:** Dashboard hiển thị số lượng tồn và tình trạng thuốc tức thời.
- **Quản lý loại thuốc:** Thêm, sửa, xóa, lọc và xem danh sách loại thuốc.
- **Bán hàng & hóa đơn:** Bán thuốc cho khách hàng, tạo hóa đơn, quản lý và xem chi tiết hóa đơn.
- **Quản lý tài khoản:** Thêm, sửa, xóa, tìm kiếm và hiển thị danh sách tài khoản nhân viên.
- **Thông báo:** Gửi email thủ công đến khách hàng khi cần.
- **Điều hướng:** Nút quay lại để trở về màn hình quản lý.

## 🔐 Phân quyền

- `ADMIN`: Toàn quyền quản trị (Thêm, Sửa, Xóa, Quản lý người dùng, thuốc, loại, hóa đơn).
- `SELLER`: Người bán thuốc, có quyền bán hàng, tạo hóa đơn, xem chi tiết thuốc và hóa đơn.

## 🛠 Công nghệ sử dụng

- **Backend:** Java Servlet, JDBC.
- **Frontend:** JSP, JSTL, CSS3, HTML5, Bootstrap, FontAwesome.
- **Database:** SQL Server.
- **Server:** Apache Tomcat.
