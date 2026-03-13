package repository;

import helper.DbConnector;
import model.Thuoc;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;
import java.util.Date;

public class ThuocRepository {

    private Thuoc mapResultSetToThuoc(ResultSet rs) throws SQLException {
        return new Thuoc(
                rs.getLong("ID"),
                rs.getString("TEN_THUOC"),
                rs.getString("LOAI_THUOC"),
                rs.getInt("SO_LUONG_TON"),
                rs.getDate("HAN_SU_DUNG")
        );
    }

    private Long findNextAvailableId() {
        String sql = "SELECT ID FROM THUOC ORDER BY ID ASC";
        List<Long> existingIds = new ArrayList<>();

        try (Connection con = DbConnector.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                existingIds.add(rs.getLong("ID"));
            }
        } catch (Exception e) {
            System.err.println("Lỗi tìm ID khả dụng: " + e.getMessage());
            return 1L;
        }

        for (long i = 1; i <= existingIds.size(); i++) {
            if (!existingIds.contains(i)) {
                return i;
            }
        }

        return existingIds.isEmpty() ? 1L : existingIds.get(existingIds.size() - 1) + 1;
    }

    public List<Thuoc> getAll() {
        List<Thuoc> dsThuoc = new ArrayList<>();
        String sql = "SELECT ID, TEN_THUOC, LOAI_THUOC, SO_LUONG_TON, HAN_SU_DUNG FROM THUOC ORDER BY ID ASC";

        try (Connection con = DbConnector.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                dsThuoc.add(mapResultSetToThuoc(rs));
            }
        } catch (Exception e) {
            System.err.println("Lỗi getAll: " + e.getMessage());
        }
        return dsThuoc;
    }

    public Thuoc getById(Long id) {
        String sql = "SELECT ID, TEN_THUOC, LOAI_THUOC, SO_LUONG_TON, HAN_SU_DUNG FROM THUOC WHERE ID = ?";

        try (Connection con = DbConnector.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setLong(1, id);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToThuoc(rs);
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi getById: " + e.getMessage());
        }
        return null;
    }

    public void add(Thuoc thuoc) {
        Long nextId = findNextAvailableId();

        String sql = "INSERT INTO THUOC (ID, TEN_THUOC, LOAI_THUOC, SO_LUONG_TON, HAN_SU_DUNG) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DbConnector.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setLong(1, nextId);
            pstmt.setString(2, thuoc.getTenThuoc());
            pstmt.setString(3, thuoc.getLoaiThuoc());
            pstmt.setInt(4, thuoc.getSoLuongTon());
            pstmt.setDate(5, new java.sql.Date(thuoc.getHanSuDung().getTime()));

            pstmt.executeUpdate();

        } catch (Exception e) {
            System.err.println("LỖI THÊM THUỐC: " + e.getMessage());
        }
    }

    public void update(Thuoc updatedThuoc) {
        String sql = "UPDATE THUOC SET TEN_THUOC = ?, LOAI_THUOC = ?, SO_LUONG_TON = ?, HAN_SU_DUNG = ? WHERE ID = ?";

        try (Connection con = DbConnector.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setString(1, updatedThuoc.getTenThuoc());
            pstmt.setString(2, updatedThuoc.getLoaiThuoc());
            pstmt.setInt(3, updatedThuoc.getSoLuongTon());
            pstmt.setDate(4, new java.sql.Date(updatedThuoc.getHanSuDung().getTime()));
            pstmt.setLong(5, updatedThuoc.getId());

            pstmt.executeUpdate();

        } catch (Exception e) {
            System.err.println("Lỗi update: " + e.getMessage());
        }
    }

    public void delete(Long id) {
        String sql = "DELETE FROM THUOC WHERE ID = ?";

        try (Connection con = DbConnector.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setLong(1, id);
            pstmt.executeUpdate();

        } catch (Exception e) {
            System.err.println("Lỗi delete: " + e.getMessage());
        }
    }

    public List<Thuoc> filter(String loaiThuoc, Boolean sapHetHan) {
        List<Thuoc> dsLoc = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT ID, TEN_THUOC, LOAI_THUOC, SO_LUONG_TON, HAN_SU_DUNG FROM THUOC WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (loaiThuoc != null && !loaiThuoc.isEmpty()) {
            sql.append(" AND LOAI_THUOC = ?");
            params.add(loaiThuoc);
        }

        if (sapHetHan != null && sapHetHan) {
            sql.append(" AND HAN_SU_DUNG BETWEEN GETDATE() AND DATEADD(day, 30, GETDATE())");
        }

        sql.append(" ORDER BY ID ASC");

        try (Connection con = DbConnector.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    pstmt.setString(paramIndex++, (String) param);
                }
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    dsLoc.add(mapResultSetToThuoc(rs));
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi filter: " + e.getMessage());
        }
        return dsLoc;
    }

    public long getTotalStock() {
        String sql = "SELECT ISNULL(SUM(SO_LUONG_TON), 0) AS Total FROM THUOC";
        try (Connection con = DbConnector.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getLong("Total");
            }
        } catch (Exception e) {
            System.err.println("Lỗi getTotalStock: " + e.getMessage());
        }
        return 0;
    }

    public long countExpired() {
        String sql = "SELECT COUNT(*) AS ExpiredCount FROM THUOC WHERE HAN_SU_DUNG < GETDATE()";
        try (Connection con = DbConnector.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getLong("ExpiredCount");
            }
        } catch (Exception e) {
            System.err.println("Lỗi countExpired: " + e.getMessage());
        }
        return 0;
    }

    public long countWarning() {
        String sql = "SELECT COUNT(*) AS WarningCount FROM THUOC WHERE HAN_SU_DUNG BETWEEN GETDATE() AND DATEADD(day, 30, GETDATE())";
        try (Connection con = DbConnector.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getLong("WarningCount");
            }
        } catch (Exception e) {
            System.err.println("Lỗi countWarning: " + e.getMessage());
        }
        return 0;
    }
}