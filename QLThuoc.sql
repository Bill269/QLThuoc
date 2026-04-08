-- 1. Tạo Database
CREATE DATABASE QUANLYTHUOC;
GO
USE QUANLYTHUOC;
GO

-- Bảng Người dùng
CREATE TABLE NGUOIDUNG (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TEN_DANG_NHAP VARCHAR(50) NOT NULL UNIQUE,
    MAT_KHAU VARCHAR(100) NOT NULL,
    NHOM_QUYEN VARCHAR(20) NOT NULL
);

-- Bảng Loại Thuốc (Kháng sinh, Giảm đau, Vitamin...)
CREATE TABLE LOAI_THUOC (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TEN_LOAI NVARCHAR(100) NOT NULL,
    TRANG_THAI BIT NOT NULL DEFAULT 1
);

-- Bảng Đơn Vị Tính (Viên, Vỉ, Hộp, Chai...)
CREATE TABLE DON_VI_TINH (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TEN_DON_VI NVARCHAR(50) NOT NULL 
);

-- Bảng THUOC_CHA (Danh mục tên thuốc gốc)
CREATE TABLE THUOC_CHA (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TEN_THUOC_CHA NVARCHAR(255) NOT NULL,
    TINH_TRANG BIT DEFAULT 1 -- 1: Đang kinh doanh, 0: Ngừng bán
);

-- =============================================
-- 2. BẢNG THUOC (QUẢN LÝ LÔ HÀNG VÀ KHO)
-- =============================================
CREATE TABLE THUOC (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    ID_TEN_THUOC INT NOT NULL,           -- Khóa ngoại tới THUOC_CHA
    ID_LOAI INT NOT NULL,                -- Khóa ngoại tới LOAI_THUOC
    ID_DON_VI INT NOT NULL,              -- Khóa ngoại tới DON_VI_TINH
    GIA_BAN DECIMAL(18, 2) NOT NULL DEFAULT 0,
    SO_LUONG_TON INT NOT NULL DEFAULT 0,
    NGAY_NHAP_THUOC DATE NOT NULL DEFAULT GETDATE(),
    HAN_SU_DUNG DATE NOT NULL,
    
    -- Thiết lập các mối quan hệ
    CONSTRAINT FK_Thuoc_DanhMuc_Cha FOREIGN KEY (ID_TEN_THUOC) REFERENCES THUOC_CHA(ID),
    CONSTRAINT FK_Thuoc_LoaiThuoc FOREIGN KEY (ID_LOAI) REFERENCES LOAI_THUOC(ID),
    CONSTRAINT FK_Thuoc_DonViTinh FOREIGN KEY (ID_DON_VI) REFERENCES DON_VI_TINH(ID)
);

-- =============================================
-- 3. QUẢN LÝ BÁN HÀNG
-- =============================================
CREATE TABLE HOA_DON (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    NGAY_LAP DATETIME DEFAULT GETDATE(),
    ID_USER INT FOREIGN KEY REFERENCES NGUOIDUNG(ID)
);

CREATE TABLE CHI_TIET_HOA_DON (
    ID_HOA_DON INT NOT NULL,
    ID_THUOC INT NOT NULL,               -- Bán theo từng lô thuốc cụ thể
    SO_LUONG INT DEFAULT 1,
    GIA_LUC_BAN DECIMAL(18, 2) NOT NULL, -- Lưu giá tại thời điểm bán
    PRIMARY KEY (ID_HOA_DON, ID_THUOC),
    CONSTRAINT FK_CTHD_HoaDon FOREIGN KEY (ID_HOA_DON) REFERENCES HOA_DON(ID),
    CONSTRAINT FK_CTHD_Thuoc FOREIGN KEY (ID_THUOC) REFERENCES THUOC(ID)
);

-- 1. DỮ LIỆU BẢNG LOẠI THUỐC (10 mẫu)
INSERT INTO LOAI_THUOC (TEN_LOAI, TRANG_THAI) VALUES 
(N'Kháng sinh', 1),
(N'Giảm đau', 1),
(N'Vitamin & Khoáng chất', 1),
(N'Thực phẩm chức năng', 1),
(N'Thuốc ho & Cảm cúm', 1),
(N'Thuốc tiêu hóa', 1),
(N'Thuốc ngoài da', 1),
(N'Thuốc dị ứng', 1),
(N'Thuốc nhỏ mắt', 1),
(N'Thảo dược', 1);

-- 2. DỮ LIỆU BẢNG ĐƠN VỊ TÍNH (10 mẫu)
INSERT INTO DON_VI_TINH (TEN_DON_VI) VALUES 
(N'Viên'), (N'Vỉ'), (N'Hộp'), (N'Chai'), (N'Gói'), 
(N'Tuýp'), (N'Ống'), (N'Lọ'), (N'Viên sủi'), (N'Túi');

-- 3. DỮ LIỆU BẢNG THUOC_CHA (Danh mục - 10 mẫu)
INSERT INTO THUOC_CHA (TEN_THUOC_CHA, TINH_TRANG) VALUES 
(N'Paracetamol 500mg', 1),
(N'Amoxicillin 500mg', 1),
(N'Hapacol 150', 1),
(N'Panadol Extra', 1),
(N'Decolgen Forte', 1),
(N'Enervon', 1),
(N'Smecta', 1),
(N'Berberin', 1),
(N'Salonpas Gel', 1),
(N'Eugica', 1);

-- 4. DỮ LIỆU BẢNG THUOC (10 lô hàng mẫu)
-- Lưu ý: Một số thuốc có 2 lô hàng khác nhau để test logic của bạn
INSERT INTO THUOC (ID_TEN_THUOC, ID_LOAI, ID_DON_VI, GIA_BAN, SO_LUONG_TON, NGAY_NHAP_THUOC, HAN_SU_DUNG) VALUES 
(1, 2, 2, 5000, 100, '2026-01-10', '2027-12-31'), -- Paracetamol Lô A
(1, 2, 2, 5500, 50, '2026-03-01', '2028-06-15'),  -- Paracetamol Lô B
(2, 1, 3, 120000, 20, '2026-02-15', '2027-05-20'), -- Amoxicillin
(3, 2, 5, 3000, 200, '2026-03-10', '2026-11-11'), -- Hapacol
(4, 2, 2, 8000, 150, '2026-01-20', '2027-01-01'), -- Panadol
(5, 5, 2, 12000, 80, '2026-03-25', '2027-08-15'), -- Decolgen
(6, 3, 3, 45000, 40, '2026-02-01', '2028-02-01'), -- Enervon
(7, 6, 5, 5000, 300, '2026-03-15', '2026-12-20'), -- Smecta
(8, 6, 8, 25000, 60, '2026-01-05', '2027-03-10'), -- Berberin
(10, 5, 3, 65000, 25, '2026-03-20', '2028-10-25'); -- Eugica

-- 5. DỮ LIỆU BẢNG HOA_DON (10 mẫu)
-- Giả sử ID_USER 1 và 2 đã tạo ở lượt trước
INSERT INTO HOA_DON (NGAY_LAP, ID_USER) VALUES 
(GETDATE(), 1), (GETDATE(), 1), (GETDATE(), 2), (GETDATE(), 2), (GETDATE(), 1),
(GETDATE(), 2), (GETDATE(), 1), (GETDATE(), 2), (GETDATE(), 1), (GETDATE(), 2);

-- 6. DỮ LIỆU BẢNG CHI_TIET_HOA_DON (10 mẫu)
INSERT INTO CHI_TIET_HOA_DON (ID_HOA_DON, ID_THUOC, SO_LUONG, GIA_LUC_BAN) VALUES 
(1, 1, 2, 5000),  -- Hóa đơn 1 mua 2 vỉ Paracetamol lô 1
(1, 3, 1, 120000),-- Hóa đơn 1 mua thêm Amoxicillin
(2, 4, 5, 3000),
(3, 5, 2, 8000),
(4, 2, 1, 5500),  -- Mua Paracetamol nhưng ở lô 2
(5, 6, 3, 12000),
(6, 7, 10, 45000),
(7, 8, 2, 5000),
(8, 9, 1, 25000),
(9, 10, 2, 65000);