-- 1. Tạo Database
CREATE DATABASE QUANLYTHUOC;
GO

USE QUANLYTHUOC;
GO

-- =============================================
-- TẠO CẤU TRÚC BẢNG (ĐÃ SỬA THEO Ý BẠN)
-- =============================================


CREATE TABLE NGUOIDUNG (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TEN_DANG_NHAP VARCHAR(50) NOT NULL UNIQUE,
    MAT_KHAU VARCHAR(100) NOT NULL,
    NHOM_QUYEN VARCHAR(20) NOT NULL
);

CREATE TABLE LOAI_THUOC (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TEN_LOAI NVARCHAR(100) NOT NULL,
    TRANG_THAI BIT NOT NULL DEFAULT 1
);

CREATE TABLE DON_VI_TINH (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TEN_DON_VI NVARCHAR(50) NOT NULL 
);

-- Bảng THUOC_CHA: Bây giờ giữ luôn Loại, Đơn vị và Giá cố định
CREATE TABLE THUOC_CHA (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TEN_THUOC_CHA NVARCHAR(255) NOT NULL,
    ID_LOAI INT NOT NULL REFERENCES LOAI_THUOC(ID), -- Chuyển lên đây
    ID_DON_VI INT NOT NULL REFERENCES DON_VI_TINH(ID), -- Chuyển lên đây
    GIA_BAN_MAC_DINH DECIMAL(18, 2) NOT NULL DEFAULT 0, -- Chuyển lên đây
    TINH_TRANG BIT DEFAULT 1,
	HAN_DUNG NVARCHAR(255),
	MO_TA NVARCHAR(500)
);

-- Bảng THUOC: Chỉ còn quản lý số lượng và hạn dùng của từng đợt nhập
CREATE TABLE THUOC (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    ID_TEN_THUOC INT NOT NULL REFERENCES THUOC_CHA(ID),
    SO_LUONG_TON INT NOT NULL DEFAULT 0,
    NGAY_NHAP_THUOC DATE NOT NULL DEFAULT GETDATE(),
    HAN_SU_DUNG DATE NOT NULL
);

CREATE TABLE HOA_DON (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    NGAY_LAP DATETIME DEFAULT GETDATE(),
    ID_USER INT FOREIGN KEY REFERENCES NGUOIDUNG(ID)
);

CREATE TABLE CHI_TIET_HOA_DON (
    ID_HOA_DON INT NOT NULL REFERENCES HOA_DON(ID),
    ID_THUOC INT NOT NULL REFERENCES THUOC(ID), -- Vẫn bán theo lô để trừ kho
    SO_LUONG INT DEFAULT 1,
    GIA_LUC_BAN DECIMAL(18, 2) NOT NULL, -- Quan trọng: Lưu giá lúc bán để tránh sai lệch khi bảng Cha đổi giá
    PRIMARY KEY (ID_HOA_DON, ID_THUOC)
);
GO

-- =============================================
-- CHÈN DỮ LIỆU MẪU MỚI
-- =============================================

INSERT INTO NGUOIDUNG VALUES ('admin', '123', 'ADMIN'), ('staff', '123', 'USER');

INSERT INTO LOAI_THUOC (TEN_LOAI) VALUES (N'Kháng sinh'), (N'Giảm đau'), (N'Vitamin'), (N'Thực phẩm chức năng'), (N'Thuốc ho'), (N'Tiêu hóa'), (N'Ngoài da'), (N'Dị ứng'), (N'Nhỏ mắt'), (N'Thảo dược');

INSERT INTO DON_VI_TINH VALUES (N'Viên'), (N'Vỉ'), (N'Hộp'), (N'Chai'), (N'Gói'), (N'Tuýp'), (N'Ống'), (N'Lọ'), (N'Viên sủi'), (N'Túi');

delete from THUOC_CHA where id = 8
-- Chèn Thuốc Cha kèm theo Loại, Đơn vị và Giá luôn
INSERT INTO THUOC_CHA (TEN_THUOC_CHA, ID_LOAI, ID_DON_VI, GIA_BAN_MAC_DINH, HAN_DUNG, MO_TA) VALUES 
(N'Paracetamol 500mg', 2, 2, 5000, N'36 tháng', N'Thuốc giảm đau, hạ sốt cơ bản'), 
(N'Amoxicillin 500mg', 1, 3, 120000, N'24 tháng', N'Kháng sinh điều trị nhiễm khuẩn'),
(N'Hapacol 150', 2, 5, 3000, N'24 tháng', N'Thuốc hạ sốt dành cho trẻ em'),
(N'Panadol Extra', 2, 2, 8000, N'36 tháng', N'Giảm đau đầu, đau răng, có chứa caffeine'),
(N'Decolgen', 5, 2, 12000, N'36 tháng', N'Điều trị cảm cúm, sổ mũi, nghẹt mũi'),
(N'Enervon', 3, 3, 45000, N'24 tháng', N'Vitamin tổng hợp tăng cường sức đề kháng'),
(N'Smecta', 6, 5, 5000, N'36 tháng', N'Điều trị tiêu chảy cấp và mãn tính'),
(N'Berberin', 6, 8, 25000, N'36 tháng', N'Thuốc điều trị tiêu hóa, kháng khuẩn đường ruột'),
(N'Salonpas', 7, 6, 15000, N'36 tháng', N'Cao dán giảm đau cơ và khớp'),
(N'Eugica', 5, 3, 65000, N'24 tháng', N'Thuốc ho thảo dược, bổ phế');

-- Chèn Thuốc Con (Lô hàng) - Bây giờ nhập cực nhanh vì không cần chọn lại Loại/Giá
INSERT INTO THUOC (ID_TEN_THUOC, SO_LUONG_TON, HAN_SU_DUNG) VALUES 
(1, 100, '2027-12-31'), -- Paracetamol lô 1
(1, 50, '2028-06-15'),  -- Paracetamol lô 2
(2, 20, '2027-05-20'), 
(3, 200, '2026-11-11'), 
(4, 150, '2027-01-01'), 
(5, 80, '2027-08-15'), 
(6, 40, '2028-02-01'), 
(7, 300, '2026-12-20'), 
(8, 60, '2027-03-10'), 
(10, 25, '2028-10-25');

INSERT INTO HOA_DON (ID_USER) VALUES (1),(1),(2),(2),(1),(1),(2),(1),(2),(1);
select * from NGUOIDUNG
-- Thêm cột TRANG_THAI với giá trị mặc định là 1 (Đang hoạt động)
ALTER TABLE NGUOIDUNG
ADD TRANG_THAI BIT NOT NULL DEFAULT 1;
GO
