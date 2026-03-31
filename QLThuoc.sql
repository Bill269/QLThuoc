-- 1. Tạo Database
CREATE DATABASE QUANLYTHUOC;
GO
USE QUANLYTHUOC;
GO

-- 2. Tạo bảng NGUOIDUNG (Có ID tự tăng để sau này sửa được Username)
CREATE TABLE NGUOIDUNG (
    ID INT IDENTITY(1,1) PRIMARY KEY,        -- ID tự động tăng (1, 2, 3...)
    TEN_DANG_NHAP VARCHAR(50) NOT NULL UNIQUE, -- Unique để không bị trùng tên
    MAT_KHAU VARCHAR(100) NOT NULL,
    NHOM_QUYEN VARCHAR(20) NOT NULL
);

-- 3. Tạo bảng THUOC (Dùng ID tự tăng làm khóa chính)
CREATE TABLE THUOC (
    ID INT IDENTITY(1,1) PRIMARY KEY,        -- ID tự động tăng
    TEN_THUOC NVARCHAR(255) NOT NULL,
    LOAI_THUOC NVARCHAR(50) NULL,
    SO_LUONG_TON INT NOT NULL DEFAULT 0,
	NGAY_NHAP_THUOC DATE NOT NULL,
    HAN_SU_DUNG DATE NOT NULL
);

-- 1. Tạo bảng Hóa Đơn (Lưu thông tin tổng quát)
CREATE TABLE HOA_DON (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    NGAY_LAP DATETIME DEFAULT GETDATE(),
    ID_USER INT FOREIGN KEY REFERENCES NGUOIDUNG(ID)
);

-- 2. Tạo bảng Chi Tiết Hóa Đơn (Lưu thông tin thuốc đã bán)
CREATE TABLE CHI_TIET_HOA_DON (
    ID_HOA_DON INT FOREIGN KEY REFERENCES HOA_DON(ID),
    ID_THUOC INT FOREIGN KEY REFERENCES THUOC(ID),
    SO_LUONG INT DEFAULT 1,
    PRIMARY KEY (ID_HOA_DON, ID_THUOC)
);

-- 4. Chèn dữ liệu mẫu cho NGUOIDUNG
-- Lưu ý: KHÔNG chèn cột ID vì máy tự sinh
INSERT INTO NGUOIDUNG (TEN_DANG_NHAP, MAT_KHAU, NHOM_QUYEN) 
VALUES 
('admin', '123', 'ADMIN'), -- Sẽ có ID = 1
('user', '123', 'USER');   -- Sẽ có ID = 2

-- 5. Chèn dữ liệu mẫu cho THUOC
-- Lưu ý: KHÔNG chèn cột ID
INSERT INTO THUOC (TEN_THUOC, LOAI_THUOC, SO_LUONG_TON, NGAY_NHAP_THUOC, HAN_SU_DUNG) 
VALUES 
(N'Paracetamol', N'Giảm đau', 100, '2026-03-29', '2026-12-25'),
(N'Amoxicillin', N'Kháng sinh', 50, '2026-03-29','2028-01-01'),
(N'Vitamin C', N'Vitamin', 200, '2026-03-29','2027-06-15'),
(N'Panadol Extra', N'Giảm đau', 150, '2026-03-29','2025-05-20');

-- 1. Tạo bảng Loại Thuốc
CREATE TABLE LOAI_THUOC (
    ID INT PRIMARY KEY IDENTITY(1,1),
    TEN_LOAI NVARCHAR(100) NOT NULL,
	TRANG_THAI BIT NOT NULL
);

-- 2. Thêm cột ID_LOAI vào bảng THUOC và tạo khóa ngoại
ALTER TABLE THUOC ADD ID_LOAI INT;
ALTER TABLE THUOC ADD CONSTRAINT FK_Thuoc_Loai FOREIGN KEY (ID_LOAI) REFERENCES LOAI_THUOC(ID);

-- 3. Chèn dữ liệu mẫu cho Loại Thuốc
INSERT INTO LOAI_THUOC (TEN_LOAI, TRANG_THAI) VALUES (N'Kháng sinh', 1), (N'Giảm đau', 1), (N'Vitamin', 1), (N'Thực phẩm chức năng', 1);
-- 6. Kiểm tra lại dữ liệu
SELECT * FROM NGUOIDUNG;
SELECT * FROM THUOC;

-- 1. Bổ sung cột GIA_BAN vào bảng THUOC
ALTER TABLE THUOC ADD GIA_BAN DECIMAL(18, 2) NOT NULL DEFAULT 0;

-- 2. Cập nhật giá và ID_LOAI cho dữ liệu mẫu hiện có
-- Giả sử: 1: Kháng sinh, 2: Giảm đau, 3: Vitamin
UPDATE THUOC SET GIA_BAN = 5000,  ID_LOAI = 2 WHERE TEN_THUOC = N'Paracetamol';
UPDATE THUOC SET GIA_BAN = 15000, ID_LOAI = 1 WHERE TEN_THUOC = N'Amoxicillin';
UPDATE THUOC SET GIA_BAN = 2000,  ID_LOAI = 3 WHERE TEN_THUOC = N'Vitamin C';
UPDATE THUOC SET GIA_BAN = 8000,  ID_LOAI = 2 WHERE TEN_THUOC = N'Panadol Extra';

-- 3. Cập nhật bảng CHI_TIET_HOA_DON để lưu giá lúc bán
ALTER TABLE CHI_TIET_HOA_DON ADD GIA_LUC_BAN DECIMAL(18, 2);

-- 4. Chèn thêm thuốc mới có đầy đủ giá
INSERT INTO THUOC (TEN_THUOC, ID_LOAI, SO_LUONG_TON, NGAY_NHAP_THUOC, HAN_SU_DUNG, GIA_BAN)
VALUES (N'Decolgen', 2, 80, '2026-03-29', '2026-10-10', 12000);

-- 5. Truy vấn kiểm tra tổng hợp (JOIN các bảng)
SELECT 
    T.ID, 
    T.TEN_THUOC, 
    L.TEN_LOAI, 
    T.GIA_BAN, 
    T.SO_LUONG_TON, 
	T. NGAY_NHAP_THUOC,
    T.HAN_SU_DUNG
FROM THUOC T
LEFT JOIN LOAI_THUOC L ON T.ID_LOAI = L.ID;

-- Tạo bảng Loại Số Lượng (Đơn vị tính)
-- 1. Tạo bảng đơn vị tính (Đồng nhất tên cột là TEN_DON_VI)
CREATE TABLE DON_VI_TINH (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TEN_DON_VI NVARCHAR(50) NOT NULL 
);

-- 2. Thêm cột khóa ngoại vào bảng THUOC
ALTER TABLE THUOC ADD ID_DON_VI INT;

-- 3. Thiết lập liên kết khóa ngoại
ALTER TABLE THUOC 
ADD CONSTRAINT FK_Thuoc_DonVi 
FOREIGN KEY (ID_DON_VI) REFERENCES DON_VI_TINH(ID);

-- 4. Chèn dữ liệu mẫu vào bảng DON_VI_TINH
-- Sau khi chạy lệnh này: Viên(1), Vỉ(2), Hộp(3), Gói(4), Chai(5)
INSERT INTO DON_VI_TINH(TEN_DON_VI) 
VALUES (N'Viên'), (N'Vỉ'), (N'Hộp'), (N'Gói'), (N'Chai');

-- 5. Cập nhật dữ liệu cho bảng THUOC
-- Paracetamol thường tính theo Vỉ (ID = 2)
UPDATE THUOC 
SET ID_DON_VI = 2 
WHERE TEN_THUOC = N'Paracetamol';

-- Vitamin C cập nhật theo Hộp (ID = 3) như chú thích của bạn
UPDATE THUOC 
SET ID_DON_VI = 3 
WHERE TEN_THUOC = N'Vitamin C';
UPDATE THUOC 
SET ID_DON_VI = 1 
WHERE TEN_THUOC = N'Decolgen';

-- Vitamin C cập nhật theo Hộp (ID = 3) như chú thích của bạn
UPDATE THUOC 
SET ID_DON_VI = 5 
WHERE TEN_THUOC = N'Panadol Extra';

UPDATE THUOC 
SET ID_DON_VI = 1 
WHERE TEN_THUOC = N'Amoxicillin';
select * from  thuoc 
select * from DON_VI_TINH

select * from NGUOIDUNG
