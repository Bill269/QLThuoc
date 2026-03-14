# 💊 Hệ Thống Quản Lý Kho Thuốc - Pharmacy Management System

![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=white)
![Servlet](https://img.shields.io/badge/Servlet-007396?style=for-the-badge&logo=java&logoColor=white)
![MSSQL](https://img.shields.io/badge/SQL_Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-blue?style=for-the-badge)

Hệ thống quản lý kho thuốc hiệu quả giúp theo dõi tồn kho, cảnh báo thuốc sắp hết hạn và quản lý người dùng với phân quyền chặt chẽ.

## 🚀 Tính năng nổi bật

- **Quản lý kho:** Thêm, sửa, xóa và xem chi tiết thông tin thuốc.
- **Cảnh báo thông minh:** Tự động tính toán và hiển thị nhãn (Badge) trạng thái:
  - 🔴 **Hết hạn:** Thuốc đã quá hạn sử dụng.
  - 🟠 **Sắp hết hạn:** Cảnh báo trước 30 ngày.
  - 🟢 **Còn hạn:** Thuốc đang trong trạng thái an toàn.
- **Thống kê:** Bảng điều khiển (Dashboard) hiển thị tổng số lượng tồn và tình trạng thuốc tức thời.
- **Phân quyền:** - `ADMIN`: Toàn quyền quản trị (Thêm, Sửa, Xóa, Quản lý User).
  - `USER`: Xem danh sách và chi tiết.

## 🛠 Công nghệ sử dụng

- **Backend:** Java Servlet, JDBC.
- **Frontend:** JSP, JSTL, CSS3, FontAwesome (Icons).
- **Database:** Microsoft SQL Server.
- **Server:** Apache Tomcat.
