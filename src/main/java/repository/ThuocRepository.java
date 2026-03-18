package repository;

import helper.DbConnector;
import model.Thuoc;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ThuocRepository {

    private Thuoc mapResultSetToThuoc(ResultSet rs) throws SQLException {
        return new Thuoc(
                rs.getInt("ID"),
                rs.getString("TEN_THUOC"),
                rs.getString("LOAI_THUOC"),
                rs.getInt("SO_LUONG_TON"),
                rs.getDate("HAN_SU_DUNG"),
                rs.getFloat("GIA_BAN")
        );
    }

    public List<Thuoc> getThuocDangConHang(String search) {
        List<Thuoc> list = new ArrayList<>();
        String sql = "SELECT * FROM THUOC WHERE TEN_THUOC LIKE ? AND SO_LUONG_TON > 0 ORDER BY HAN_SU_DUNG ASC";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + (search == null ? "" : search) + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToThuoc(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Thuoc> searchThuoc(String ten, String loai) {
        List<Thuoc> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM THUOC WHERE TEN_THUOC LIKE ? ");
        if (loai != null && !loai.isEmpty()) {
            sql.append(" AND LOAI_THUOC = ? ");
        }
        sql.append(" ORDER BY ID DESC");

        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            ps.setString(1, "%" + (ten == null ? "" : ten) + "%");
            if (loai != null && !loai.isEmpty()) {
                ps.setString(2, loai);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToThuoc(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public Thuoc getById(int id) {
        String sql = "SELECT * FROM THUOC WHERE ID = ?";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapResultSetToThuoc(rs);
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public void add(Thuoc t) {
        String sql = "INSERT INTO THUOC (TEN_THUOC, LOAI_THUOC, SO_LUONG_TON, HAN_SU_DUNG, GIA_BAN) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, t.getTenThuoc());
            ps.setString(2, t.getLoaiThuoc());
            ps.setInt(3, t.getSoLuongTon());
            ps.setDate(4, new java.sql.Date(t.getHanSuDung().getTime()));
            ps.setFloat(5, t.getGiaBan());
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void update(Thuoc t) {
        String sql = "UPDATE THUOC SET TEN_THUOC=?, LOAI_THUOC=?, SO_LUONG_TON=?, HAN_SU_DUNG=?, GIA_BAN=? WHERE ID=?";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, t.getTenThuoc());
            ps.setString(2, t.getLoaiThuoc());
            ps.setInt(3, t.getSoLuongTon());
            ps.setDate(4, new java.sql.Date(t.getHanSuDung().getTime()));
            ps.setFloat(5, t.getGiaBan());
            ps.setInt(6, t.getId());
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

    public void banThuoc(int idThuoc, int idUser) {
        String sqlGiamKho = "UPDATE THUOC SET SO_LUONG_TON = SO_LUONG_TON - 1 " +
                "WHERE ID = ? AND SO_LUONG_TON > 0 AND HAN_SU_DUNG >= CAST(GETDATE() AS DATE)";
        String sqlHoaDon = "INSERT INTO HOA_DON (ID_USER, NGAY_LAP) VALUES (?, GETDATE())";
        String sqlChiTiet = "INSERT INTO CHI_TIET_HOA_DON (ID_HOA_DON, ID_THUOC, SO_LUONG) VALUES (?, ?, 1)";

        Connection con = null;
        try {
            con = DbConnector.getConnection();
            con.setAutoCommit(false);
            try (PreparedStatement ps1 = con.prepareStatement(sqlGiamKho)) {
                ps1.setInt(1, idThuoc);
                if (ps1.executeUpdate() > 0) {
                    int idHD = -1;
                    try (PreparedStatement ps2 = con.prepareStatement(sqlHoaDon, Statement.RETURN_GENERATED_KEYS)) {
                        ps2.setInt(1, idUser);
                        ps2.executeUpdate();
                        ResultSet rs = ps2.getGeneratedKeys();
                        if (rs.next()) idHD = rs.getInt(1);
                    }
                    if (idHD > 0) {
                        try (PreparedStatement ps3 = con.prepareStatement(sqlChiTiet)) {
                            ps3.setInt(1, idHD); ps3.setInt(2, idThuoc);
                            ps3.executeUpdate();
                            con.commit();
                        }
                    } else { con.rollback(); }
                } else { con.rollback(); }
            }
        } catch (Exception e) {
            if (con != null) try { con.rollback(); } catch (SQLException ex) {}
            e.printStackTrace();
        } finally {
            if (con != null) try { con.close(); } catch (SQLException ex) {}
        }
    }

    public long getTotalStock() {
        String sql = "SELECT SUM(SO_LUONG_TON) FROM THUOC";
        try (Connection con = DbConnector.getConnection(); Statement st = con.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getLong(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public long countWarning() {
        String sql = "SELECT COUNT(*) FROM THUOC WHERE HAN_SU_DUNG >= CAST(GETDATE() AS DATE) AND HAN_SU_DUNG <= DATEADD(day, 30, CAST(GETDATE() AS DATE))";
        try (Connection con = DbConnector.getConnection(); Statement st = con.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getLong(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public long countExpired() {
        String sql = "SELECT COUNT(*) FROM THUOC WHERE HAN_SU_DUNG < CAST(GETDATE() AS DATE)";
        try (Connection con = DbConnector.getConnection(); Statement st = con.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getLong(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
}