package repository;

import helper.DbConnector;
import model.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class ThuocRepository {

    // SỬA LỖI: Khởi tạo các object lồng nhau để JSP không bị NullPointerException
    private Thuoc mapResultSetToThuoc(ResultSet rs) throws SQLException {
        ThuocCha tc = new ThuocCha();
        tc.setId(rs.getInt("ID_TEN_THUOC"));

        // Khởi tạo sẵn các object con
        LoaiThuoc loai = new LoaiThuoc();
        DonViTinh dv = new DonViTinh();

        try {
            tc.setTen_thuoc_cha(rs.getString("TEN_THUOC_CHA"));
            // Lấy giá bán để hiển thị trên JSP
            tc.setGiaBanMacDinh(rs.getDouble("GIA_BAN_MAC_DINH"));

            // Gán dữ liệu cho Loai và Don Vi nếu câu SQL có JOIN
            loai.setTenLoai(rs.getString("TEN_LOAI"));
            dv.setTenDonVi(rs.getString("TEN_DON_VI"));
        } catch (SQLException e) {
            // Bỏ qua nếu query đơn giản không có các cột này, nhưng object loai/dv vẫn tồn tại (rỗng) -> JSP không crash
        }

        tc.setLoaiThuoc(loai);
        tc.setDonViTinh(dv);

        return new Thuoc(
                rs.getInt("ID"),
                tc,
                rs.getInt("SO_LUONG_TON"),
                rs.getTimestamp("NGAY_NHAP_THUOC"),
                rs.getDate("HAN_SU_DUNG")
        );
    }

    // 1. Giữ nguyên
    public List<Thuoc> getThuocDangConHang(String search) {
        List<Thuoc> list = new ArrayList<>();
        String sql = "SELECT t.*, tc.TEN_THUOC_CHA, tc.GIA_BAN_MAC_DINH FROM THUOC t " +
                "JOIN THUOC_CHA tc ON t.ID_TEN_THUOC = tc.ID " +
                "WHERE tc.TEN_THUOC_CHA LIKE ? AND t.SO_LUONG_TON > 0 " +
                "AND tc.TINH_TRANG = 1 AND t.HAN_SU_DUNG >= CAST(GETDATE() AS DATE) " +
                "ORDER BY t.HAN_SU_DUNG ASC";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + (search == null ? "" : search) + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapResultSetToThuoc(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 2. SỬA LỖI: Thêm JOIN để lấy TEN_LOAI và TEN_DON_VI cho trang danh sách
    public List<Thuoc> searchThuoc(String ten, String idLoai) {
        List<Thuoc> list = new ArrayList<>();
        String sql = "SELECT t.*, tc.TEN_THUOC_CHA, tc.GIA_BAN_MAC_DINH, l.TEN_LOAI, d.TEN_DON_VI " +
                "FROM THUOC t " +
                "JOIN THUOC_CHA tc ON t.ID_TEN_THUOC = tc.ID " +
                "LEFT JOIN LOAI_THUOC l ON tc.ID_LOAI = l.ID " +
                "LEFT JOIN DON_VI_TINH d ON tc.ID_DON_VI = d.ID " +
                "WHERE tc.TEN_THUOC_CHA LIKE ? AND tc.TINH_TRANG = 1 ";
        if (idLoai != null && !idLoai.isEmpty()) sql += " AND tc.ID_LOAI = ? ";
        sql += " ORDER BY t.ID DESC";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + (ten == null ? "" : ten) + "%");
            if (idLoai != null && !idLoai.isEmpty()) ps.setInt(2, Integer.parseInt(idLoai));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapResultSetToThuoc(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 3. SỬA LỖI: Thêm JOIN cho trang Chi tiết
    public Thuoc getById(int id) {
        String sql = "SELECT t.*, tc.TEN_THUOC_CHA, tc.GIA_BAN_MAC_DINH, l.TEN_LOAI, d.TEN_DON_VI " +
                "FROM THUOC t " +
                "JOIN THUOC_CHA tc ON t.ID_TEN_THUOC = tc.ID " +
                "LEFT JOIN LOAI_THUOC l ON tc.ID_LOAI = l.ID " +
                "LEFT JOIN DON_VI_TINH d ON tc.ID_DON_VI = d.ID " +
                "WHERE t.ID = ?";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapResultSetToThuoc(rs);
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // 4. Giữ nguyên
    public void add(Thuoc t) {
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
        // THÊM: NGAY_NHAP_THUOC=? vào câu lệnh SQL
        String sql = "UPDATE THUOC SET ID_TEN_THUOC=?, SO_LUONG_TON=?, NGAY_NHAP_THUOC=?, HAN_SU_DUNG=? WHERE ID=?";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, t.getThuocCha().getId());
            ps.setInt(2, t.getSoLuongTon());

            // BỔ SUNG: Gán giá trị cho NGAY_NHAP_THUOC (Dùng Timestamp để giữ cả giờ phút giây)
            if (t.getNgayNhapThuoc() != null) {
                ps.setTimestamp(3, new java.sql.Timestamp(t.getNgayNhapThuoc().getTime()));
            } else {
                ps.setNull(3, java.sql.Types.TIMESTAMP);
            }

            ps.setDate(4, new java.sql.Date(t.getHanSuDung().getTime()));
            ps.setInt(5, t.getId());

            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 6. Giữ nguyên
    public void delete(int id) {
        String sql = "DELETE FROM THUOC WHERE ID = ?";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 7. Giữ nguyên logic Transaction
    public void banThuoc(int idThuoc, int idUser) {
        String sqlGetGia = "SELECT GIA_BAN_MAC_DINH FROM THUOC_CHA tc JOIN THUOC t ON tc.ID = t.ID_TEN_THUOC WHERE t.ID = ?";
        String sqlGiamKho = "UPDATE THUOC SET SO_LUONG_TON = SO_LUONG_TON - 1 WHERE ID = ? AND SO_LUONG_TON > 0";
        String sqlHoaDon = "INSERT INTO HOA_DON (ID_USER, NGAY_LAP) VALUES (?, GETDATE())";
        String sqlChiTiet = "INSERT INTO CHI_TIET_HOA_DON (ID_HOA_DON, ID_THUOC, SO_LUONG, GIA_LUC_BAN) VALUES (?, ?, 1, ?)";
        try (Connection con = DbConnector.getConnection()) {
            con.setAutoCommit(false);
            double giaBan = 0;
            try (PreparedStatement psGia = con.prepareStatement(sqlGetGia)) {
                psGia.setInt(1, idThuoc);
                ResultSet rs = psGia.executeQuery();
                if (rs.next()) giaBan = rs.getDouble(1);
            }
            try (PreparedStatement ps1 = con.prepareStatement(sqlGiamKho)) {
                ps1.setInt(1, idThuoc);
                if (ps1.executeUpdate() > 0) {
                    int idHD = -1;
                    try (PreparedStatement ps2 = con.prepareStatement(sqlHoaDon, Statement.RETURN_GENERATED_KEYS)) {
                        ps2.setInt(1, idUser); ps2.executeUpdate();
                        ResultSet rs = ps2.getGeneratedKeys();
                        if (rs.next()) idHD = rs.getInt(1);
                    }
                    if (idHD > 0) {
                        try (PreparedStatement ps3 = con.prepareStatement(sqlChiTiet)) {
                            ps3.setInt(1, idHD); ps3.setInt(2, idThuoc); ps3.setDouble(3, giaBan);
                            ps3.executeUpdate();
                            con.commit();
                        }
                    } else con.rollback();
                } else con.rollback();
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 8. Giữ nguyên
    public long getTotalStock() {
        String sql = "SELECT SUM(t.SO_LUONG_TON) FROM THUOC t " +
                "JOIN THUOC_CHA tc ON t.ID_TEN_THUOC = tc.ID WHERE tc.TINH_TRANG = 1";
        try (Connection con = DbConnector.getConnection(); Statement st = con.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getLong(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // 9. Giữ nguyên
    public long countWarning() {
        String sql = "SELECT COUNT(*) FROM THUOC t JOIN THUOC_CHA tc ON t.ID_TEN_THUOC = tc.ID " +
                "WHERE t.HAN_SU_DUNG >= CAST(GETDATE() AS DATE) " +
                "AND t.HAN_SU_DUNG <= DATEADD(day, 30, CAST(GETDATE() AS DATE)) AND tc.TINH_TRANG = 1";
        try (Connection con = DbConnector.getConnection(); Statement st = con.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getLong(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // 10. Giữ nguyên
    public long countExpired() {
        String sql = "SELECT COUNT(*) FROM THUOC t JOIN THUOC_CHA tc ON t.ID_TEN_THUOC = tc.ID " +
                "WHERE t.HAN_SU_DUNG < CAST(GETDATE() AS DATE) AND tc.TINH_TRANG = 1";
        try (Connection con = DbConnector.getConnection(); Statement st = con.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getLong(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // 11. Giữ nguyên
    public boolean isThuocDaBan(int idThuoc) {
        String sql = "SELECT COUNT(*) FROM CHI_TIET_HOA_DON WHERE ID_THUOC = ?";
        try (Connection con = DbConnector.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idThuoc);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 12. Giữ nguyên
    public List<Thuoc> getThuocSapHetHan() {
        List<Thuoc> list = new ArrayList<>();
        String sql = "SELECT t.*, tc.TEN_THUOC_CHA, tc.GIA_BAN_MAC_DINH, l.TEN_LOAI, d.TEN_DON_VI FROM THUOC t " +
                "JOIN THUOC_CHA tc ON t.ID_TEN_THUOC = tc.ID " +
                "LEFT JOIN LOAI_THUOC l ON tc.ID_LOAI = l.ID " +
                "LEFT JOIN DON_VI_TINH d ON tc.ID_DON_VI = d.ID " +
                "WHERE t.HAN_SU_DUNG >= CAST(GETDATE() AS DATE) " +
                "AND t.HAN_SU_DUNG <= DATEADD(day, 30, CAST(GETDATE() AS DATE)) " +
                "ORDER BY t.HAN_SU_DUNG ASC";
        try (Connection con = DbConnector.getConnection(); Statement st = con.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapResultSetToThuoc(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 13. SỬA LỖI: Đồng bộ logic JOIN cho đồng nhất các hàm
    public List<Thuoc> getAllNgayNhap() {
        List<Thuoc> list = new ArrayList<>();
        String sql = "SELECT t.*, tc.TEN_THUOC_CHA, tc.GIA_BAN_MAC_DINH, l.TEN_LOAI, d.TEN_DON_VI FROM THUOC t " +
                "JOIN THUOC_CHA tc ON t.ID_TEN_THUOC = tc.ID " +
                "JOIN LOAI_THUOC l ON tc.ID_LOAI = l.ID " +
                "JOIN DON_VI_TINH d ON tc.ID_DON_VI = d.ID";
        try (Connection connection = DbConnector.getConnection();
             Statement st = connection.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapResultSetToThuoc(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void thanhToan(Map<Integer, GioHangItem> cart, int userId) throws Exception {
        Connection conn = DbConnector.getConnection();
        try {
            conn.setAutoCommit(false);

            // 1. Tạo hóa đơn
            String sqlHD = "INSERT INTO HOA_DON (NGAY_LAP, ID_USER) OUTPUT INSERTED.ID VALUES (GETDATE(), ?)";
            PreparedStatement psHD = conn.prepareStatement(sqlHD);
            psHD.setInt(1, userId);
            ResultSet rs = psHD.executeQuery();
            int hoaDonId = (rs.next()) ? rs.getInt(1) : 0;

            // 2. Lưu chi tiết & Trừ kho
            for (GioHangItem item : cart.values()) {
                // Lưu chi tiết (Ghi nhận số lượng bán thực tế)
                String sqlCT = "INSERT INTO CHI_TIET_HOA_DON (ID_HOA_DON, ID_THUOC, SO_LUONG, GIA_LUC_BAN) VALUES (?, ?, ?, ?)";
                PreparedStatement psCT = conn.prepareStatement(sqlCT);
                psCT.setInt(1, hoaDonId);
                psCT.setInt(2, item.getThuoc().getId());
                psCT.setInt(3, item.getSoLuong()); // Dùng số lượng từ giỏ hàng
                psCT.setDouble(4, item.getThuoc().getThuocCha().getGiaBanMacDinh());
                psCT.executeUpdate();

                // Trừ số lượng tồn trong bảng THUOC
                String sqlUpdate = "UPDATE THUOC SET SO_LUONG_TON = SO_LUONG_TON - ? WHERE ID = ?";
                PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate);
                psUpdate.setInt(1, item.getSoLuong()); // Trừ đúng số lượng đã chọn
                psUpdate.setInt(2, item.getThuoc().getId());
                psUpdate.executeUpdate();
            }
            conn.commit();
        } catch (Exception e) {
            conn.rollback();
            throw e;
        } finally { conn.close(); }
    }
}