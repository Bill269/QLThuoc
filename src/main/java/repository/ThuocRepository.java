package repository;

import helper.DbConnector;
import model.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class ThuocRepository {

    // Hàm map dữ liệu chung - Đã đảm bảo lấy MO_TA và Timestamp
    private Thuoc mapResultSetToThuoc(ResultSet rs) throws SQLException {
        ThuocCha tc = new ThuocCha();
        tc.setId(rs.getInt("ID_TEN_THUOC"));
        tc.setTen_thuoc_cha(rs.getString("TEN_THUOC_CHA"));
        tc.setGiaBanMacDinh(rs.getDouble("GIA_BAN_MAC_DINH"));
        tc.setMoTa(rs.getString("MO_TA"));

        LoaiThuoc loai = new LoaiThuoc();
        loai.setTenLoai(rs.getString("TEN_LOAI"));
        tc.setLoaiThuoc(loai);

        DonViTinh dv = new DonViTinh();
        dv.setTenDonVi(rs.getString("TEN_DON_VI"));
        tc.setDonViTinh(dv);

        return new Thuoc(
                rs.getInt("ID"),
                tc,
                rs.getInt("SO_LUONG_TON"),
                rs.getTimestamp("NGAY_NHAP_THUOC"), // Lấy đầy đủ giờ:phút:giây
                rs.getDate("HAN_SU_DUNG")
        );
    }
    // Thêm hàm này vào trong class ThuocRepository
    public List<Thuoc> getThuocDangConHang(String search) {
        List<Thuoc> list = new ArrayList<>();
        // Truy vấn lấy thuốc còn hạn, còn hàng và đang ở trạng thái kinh doanh (TINH_TRANG = 1)
        String sql = "SELECT t.*, tc.TEN_THUOC_CHA, tc.GIA_BAN_MAC_DINH, tc.MO_TA, l.TEN_LOAI, d.TEN_DON_VI " +
                "FROM THUOC t " +
                "JOIN THUOC_CHA tc ON t.ID_TEN_THUOC = tc.ID " +
                "LEFT JOIN LOAI_THUOC l ON tc.ID_LOAI = l.ID " +
                "LEFT JOIN DON_VI_TINH d ON tc.ID_DON_VI = d.ID " +
                "WHERE tc.TEN_THUOC_CHA LIKE ? AND t.SO_LUONG_TON > 0 " +
                "AND tc.TINH_TRANG = 1 AND t.HAN_SU_DUNG >= CAST(GETDATE() AS DATE) " +
                "ORDER BY t.HAN_SU_DUNG ASC"; // Ưu tiên hàng sắp hết hạn bán trước
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + (search == null ? "" : search) + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToThuoc(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    // MỚI: Hàm lấy lịch sử các lô hàng của ĐÚNG loại thuốc đó
    public List<Thuoc> getHistoryByThuocCha(int idThuocCha) {
        List<Thuoc> list = new ArrayList<>();
        String sql = "SELECT t.*, tc.TEN_THUOC_CHA, tc.GIA_BAN_MAC_DINH, tc.MO_TA, l.TEN_LOAI, d.TEN_DON_VI " +
                "FROM THUOC t JOIN THUOC_CHA tc ON t.ID_TEN_THUOC = tc.ID " +
                "LEFT JOIN LOAI_THUOC l ON tc.ID_LOAI = l.ID " +
                "LEFT JOIN DON_VI_TINH d ON tc.ID_DON_VI = d.ID " +
                "WHERE t.ID_TEN_THUOC = ? " +
                "ORDER BY t.NGAY_NHAP_THUOC DESC"; // Lô mới nhất lên đầu (Phân biệt lô trước lô sau)
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idThuocCha);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapResultSetToThuoc(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Thuoc> searchThuoc(String ten, String idLoai) {
        List<Thuoc> list = new ArrayList<>();
        String sql = "SELECT t.*, tc.TEN_THUOC_CHA, tc.GIA_BAN_MAC_DINH, tc.MO_TA, l.TEN_LOAI, d.TEN_DON_VI " +
                "FROM THUOC t JOIN THUOC_CHA tc ON t.ID_TEN_THUOC = tc.ID " +
                "LEFT JOIN LOAI_THUOC l ON tc.ID_LOAI = l.ID " +
                "LEFT JOIN DON_VI_TINH d ON tc.ID_DON_VI = d.ID " +
                "WHERE tc.TEN_THUOC_CHA LIKE ? AND tc.TINH_TRANG = 1 ";
        if (idLoai != null && !idLoai.isEmpty()) sql += " AND tc.ID_LOAI = ? ";
        sql += " ORDER BY t.NGAY_NHAP_THUOC DESC";

        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + (ten == null ? "" : ten) + "%");
            if (idLoai != null && !idLoai.isEmpty()) ps.setInt(2, Integer.parseInt(idLoai));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapResultSetToThuoc(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public Thuoc getById(int id) {
        String sql = "SELECT t.*, tc.TEN_THUOC_CHA, tc.GIA_BAN_MAC_DINH, tc.MO_TA, l.TEN_LOAI, d.TEN_DON_VI " +
                "FROM THUOC t JOIN THUOC_CHA tc ON t.ID_TEN_THUOC = tc.ID " +
                "LEFT JOIN LOAI_THUOC l ON tc.ID_LOAI = l.ID " +
                "LEFT JOIN DON_VI_TINH d ON tc.ID_DON_VI = d.ID WHERE t.ID = ?";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapResultSetToThuoc(rs);
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public void add(Thuoc t) {
        // Sử dụng GETDATE() trực tiếp để lấy thời gian thực từ SQL Server
        String sql = "INSERT INTO THUOC (ID_TEN_THUOC, SO_LUONG_TON, HAN_SU_DUNG, NGAY_NHAP_THUOC) VALUES (?, ?, ?, GETDATE())";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, t.getThuocCha().getId());
            ps.setInt(2, t.getSoLuongTon());
            ps.setDate(3, new java.sql.Date(t.getHanSuDung().getTime()));
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void update(Thuoc t) {
        String sql = "UPDATE THUOC SET ID_TEN_THUOC=?, SO_LUONG_TON=?, NGAY_NHAP_THUOC=?, HAN_SU_DUNG=? WHERE ID=?";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, t.getThuocCha().getId());
            ps.setInt(2, t.getSoLuongTon());
            // Dùng setTimestamp để giữ nguyên giờ phút giây khi update
            ps.setTimestamp(3, new java.sql.Timestamp(t.getNgayNhapThuoc().getTime()));
            ps.setDate(4, new java.sql.Date(t.getHanSuDung().getTime()));
            ps.setInt(5, t.getId());
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void delete(int id) {
        String sql = "DELETE FROM THUOC WHERE ID = ?";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // --- Các hàm thống kê giữ nguyên logic ---
    public long getTotalStock() {
        String sql = "SELECT SUM(SO_LUONG_TON) FROM THUOC t JOIN THUOC_CHA tc ON t.ID_TEN_THUOC = tc.ID WHERE tc.TINH_TRANG = 1";
        try (Connection con = DbConnector.getConnection(); Statement st = con.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getLong(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public long countWarning() {
        String sql = "SELECT COUNT(*) FROM THUOC t JOIN THUOC_CHA tc ON t.ID_TEN_THUOC = tc.ID " +
                "WHERE t.HAN_SU_DUNG >= CAST(GETDATE() AS DATE) " +
                "AND t.HAN_SU_DUNG <= DATEADD(day, 30, CAST(GETDATE() AS DATE)) AND tc.TINH_TRANG = 1";
        try (Connection con = DbConnector.getConnection(); Statement st = con.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getLong(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public long countExpired() {
        String sql = "SELECT COUNT(*) FROM THUOC t JOIN THUOC_CHA tc ON t.ID_TEN_THUOC = tc.ID " +
                "WHERE t.HAN_SU_DUNG < CAST(GETDATE() AS DATE) AND tc.TINH_TRANG = 1";
        try (Connection con = DbConnector.getConnection(); Statement st = con.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getLong(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public boolean isThuocDaBan(int idThuoc) {
        String sql = "SELECT COUNT(*) FROM CHI_TIET_HOA_DON WHERE ID_THUOC = ?";
        try (Connection con = DbConnector.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idThuoc);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
    public void updateSoLuongTon(int idThuoc, int soLuongMua) throws Exception {
        // Trừ số lượng: SO_LUONG_TON mới = SO_LUONG_TON cũ - soLuongMua
        String sql = "UPDATE THUOC SET SO_LUONG_TON = SO_LUONG_TON - ? WHERE ID = ?";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, soLuongMua);
            ps.setInt(2, idThuoc);
            ps.executeUpdate();
        }
    }
}