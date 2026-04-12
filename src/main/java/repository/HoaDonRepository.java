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
    public List<HoaDon> getLichSuBanHangGop() {
        // Dùng Map để nhóm theo ID hóa đơn
        Map<Integer, HoaDon> mapHD = new java.util.LinkedHashMap<>();

        String sql = "SELECT h.ID, h.NGAY_LAP, ct.SO_LUONG, tc.TEN_THUOC_CHA, l.TEN_LOAI " +
                "FROM HOA_DON h " +
                "JOIN CHI_TIET_HOA_DON ct ON h.ID = ct.ID_HOA_DON " +
                "JOIN THUOC t ON ct.ID_THUOC = t.ID " +
                "JOIN THUOC_CHA tc ON t.ID_TEN_THUOC = tc.ID " +
                "LEFT JOIN LOAI_THUOC l ON tc.ID_LOAI = l.ID " +
                "ORDER BY h.ID DESC";

        try (Connection con = helper.DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int hdId = rs.getInt("ID");

                // Nếu chưa có hóa đơn này trong Map, tạo mới đối tượng HoaDon
                if (!mapHD.containsKey(hdId)) {
                    HoaDon hd = new HoaDon();
                    hd.setId(hdId);
                    hd.setNgayLap(rs.getTimestamp("NGAY_LAP"));
                    mapHD.put(hdId, hd);
                }

                // Tạo chi tiết thuốc và thêm vào danh sách của Hóa đơn tương ứng
                ChiTietHoaDon ct = new ChiTietHoaDon();
                ct.setTenThuoc(rs.getString("TEN_THUOC_CHA"));
                ct.setLoaiThuoc(rs.getString("TEN_LOAI"));
                ct.setSoLuong(rs.getInt("SO_LUONG"));

                mapHD.get(hdId).getChiTietList().add(ct);
            }
        } catch (Exception e) { e.printStackTrace(); }

        return new ArrayList<>(mapHD.values());
    }

    /**
     * Tạo hóa đơn mới và trả về ID tự động tăng (Dùng cho lưu Database)
     */
    public int createHoaDon(int idUser) {
        String sql = "INSERT INTO HOA_DON (ID_USER, NGAY_LAP) VALUES (?, GETDATE())";
        try (Connection conn = DbConnector.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, idUser);
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
}