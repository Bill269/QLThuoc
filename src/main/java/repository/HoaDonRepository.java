package repository;

import helper.DbConnector;
import model.ChiTietHoaDon;
import model.HoaDon;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class HoaDonRepository {

    /**
     * Lấy lịch sử bán hàng chi tiết.
     * JOIN từ CHI_TIET_HOA_DON sang THUOC_CHA để lấy tên thuốc chính xác.
     */
    public List<HoaDon> getLichSuBanHangGop(String searchId) {
        Map<Integer, HoaDon> mapHD = new java.util.LinkedHashMap<>();

        String sql = "SELECT h.ID, h.NGAY_LAP, h.ID_USER, u.TEN_DANG_NHAP, " +
                "h.TenKhachHang, h.SoDienThoai, h.Email, h.DiaChi, " +
                "ct.SO_LUONG, ct.GIA_LUC_BAN, tc.TEN_THUOC_CHA, l.TEN_LOAI " +
                "FROM HOA_DON h " +
                "JOIN NGUOIDUNG u ON h.ID_USER = u.ID " +
                "JOIN CHI_TIET_HOA_DON ct ON h.ID = ct.ID_HOA_DON " +
                "JOIN THUOC t ON ct.ID_THUOC = t.ID " +
                "JOIN THUOC_CHA tc ON t.ID_TEN_THUOC = tc.ID " +
                "LEFT JOIN LOAI_THUOC l ON tc.ID_LOAI = l.ID ";

        // --- THAY ĐỔI TẠI ĐÂY ---
        if (searchId != null && !searchId.trim().isEmpty()) {
            // Chuyển ID sang kiểu chuỗi (VARCHAR) để dùng LIKE
            sql += " WHERE CAST(h.ID AS VARCHAR) LIKE ? ";
        }

        sql += " ORDER BY h.ID DESC";

        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (searchId != null && !searchId.trim().isEmpty()) {
                // Thêm % vào hai đầu để tìm kiếm chứa số đó
                ps.setString(1, "%" + searchId.trim() + "%");
            }

            try (ResultSet rs = ps.executeQuery()) {
                // ... (Phần logic while (rs.next()) giữ nguyên như cũ)
                while (rs.next()) {
                    int hdId = rs.getInt("ID");
                    if (!mapHD.containsKey(hdId)) {
                        HoaDon hd = new HoaDon();
                        hd.setId(hdId);
                        hd.setNgayLap(rs.getTimestamp("NGAY_LAP"));
                        hd.setTenNguoiDung(rs.getString("TEN_DANG_NHAP"));
                        hd.setTenKhachHang(rs.getNString("TenKhachHang"));
                        hd.setSoDienThoai(rs.getString("SoDienThoai"));
                        hd.setDiaChi(rs.getNString("DiaChi"));
                        hd.setTongTien(0);
                        mapHD.put(hdId, hd);
                    }
                    ChiTietHoaDon ct = new ChiTietHoaDon();
                    ct.setTenThuoc(rs.getString("TEN_THUOC_CHA"));
                    int soLuong = rs.getInt("SO_LUONG");
                    double giaBan = rs.getDouble("GIA_LUC_BAN");
                    ct.setSoLuong(soLuong);
                    ct.setGiaLucBan(giaBan);
                    HoaDon hdHienTai = mapHD.get(hdId);
                    hdHienTai.getChiTietList().add(ct);
                    hdHienTai.setTongTien(hdHienTai.getTongTien() + (soLuong * giaBan));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new ArrayList<>(mapHD.values());
    }

    /**
     * Tạo hóa đơn mới và trả về ID tự động tăng (Dùng cho lưu Database)
     */
    public int createHoaDon(int idUser, String tenKH, String sdt, String email, String diaChi) {
        String sql = "INSERT INTO HOA_DON (ID_USER, NGAY_LAP, TenKhachHang, SoDienThoai, Email, DiaChi) " +
                "VALUES (?, GETDATE(), ?, ?, ?, ?)";
        try (Connection conn = DbConnector.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, idUser);
            ps.setNString(2, tenKH);
            ps.setString(3, sdt);
            ps.setString(4, email);
            ps.setNString(5, diaChi);
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Thêm chi tiết vào hóa đơn (Dùng cho lưu Database)
     */
    public void addChiTiet(int idHD, int idThuoc, int soLuong, double gia) {
        String sql = "INSERT INTO CHI_TIET_HOA_DON (ID_HOA_DON, ID_THUOC, SO_LUONG, GIA_LUC_BAN) VALUES (?, ?, ?, ?)";
        try (Connection conn = DbConnector.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idHD);
            ps.setInt(2, idThuoc);
            ps.setInt(3, soLuong);
            ps.setDouble(4, gia);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public List<ChiTietHoaDon> getChiTietByHoaDonId(int idHD) {
        List<ChiTietHoaDon> list = new ArrayList<>();
        String sql = "SELECT ct.*, tc.TEN_THUOC_CHA, l.TEN_LOAI " +
                "FROM CHI_TIET_HOA_DON ct " +
                "JOIN THUOC t ON ct.ID_THUOC = t.ID " +
                "JOIN THUOC_CHA tc ON t.ID_TEN_THUOC = tc.ID " +
                "LEFT JOIN LOAI_THUOC l ON tc.ID_LOAI = l.ID " +
                "WHERE ct.ID_HOA_DON = ?";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idHD);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ChiTietHoaDon ct = new ChiTietHoaDon();
                ct.setTenThuoc(rs.getString("TEN_THUOC_CHA"));
                ct.setLoaiThuoc(rs.getString("TEN_LOAI"));
                ct.setSoLuong(rs.getInt("SO_LUONG"));
                ct.setGiaLucBan(rs.getDouble("GIA_LUC_BAN"));
                list.add(ct);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}