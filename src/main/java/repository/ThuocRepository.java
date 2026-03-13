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
                rs.getDate("HAN_SU_DUNG")
        );
    }

    public List<Thuoc> getAll() {
        List<Thuoc> list = new ArrayList<>();
        String sql = "SELECT * FROM THUOC ORDER BY ID DESC";
        try (Connection con = DbConnector.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
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
        String sql = "INSERT INTO THUOC (TEN_THUOC, LOAI_THUOC, SO_LUONG_TON, HAN_SU_DUNG) VALUES (?, ?, ?, ?)";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, t.getTenThuoc());
            ps.setString(2, t.getLoaiThuoc());
            ps.setInt(3, t.getSoLuongTon());
            ps.setDate(4, new java.sql.Date(t.getHanSuDung().getTime()));
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void update(Thuoc t) {
        String sql = "UPDATE THUOC SET TEN_THUOC = ?, LOAI_THUOC = ?, SO_LUONG_TON = ?, HAN_SU_DUNG = ? WHERE ID = ?";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, t.getTenThuoc());
            ps.setString(2, t.getLoaiThuoc());
            ps.setInt(3, t.getSoLuongTon());
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

    public long getTotalStock() {
        String sql = "SELECT SUM(SO_LUONG_TON) AS Total FROM THUOC";
        try (Connection con = DbConnector.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getLong("Total");
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public long countWarning() {
        String sql = "SELECT COUNT(*) FROM THUOC WHERE HAN_SU_DUNG >= CAST(GETDATE() AS DATE) AND HAN_SU_DUNG <= DATEADD(day, 30, CAST(GETDATE() AS DATE))";
        try (Connection con = DbConnector.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getLong(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public long countExpired() {
        String sql = "SELECT COUNT(*) FROM THUOC WHERE HAN_SU_DUNG < CAST(GETDATE() AS DATE)";
        try (Connection con = DbConnector.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getLong(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
}