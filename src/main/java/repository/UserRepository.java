package repository;

import helper.DbConnector;
import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserRepository {

    public User login(String user, String pass) {
        String sql = "SELECT * FROM NGUOIDUNG WHERE TEN_DANG_NHAP = ? AND MAT_KHAU = ?";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user);
            ps.setString(2, pass);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getInt("ID"),
                        rs.getString("TEN_DANG_NHAP"),
                        rs.getString("MAT_KHAU"),
                        rs.getString("NHOM_QUYEN"),
                        rs.getBoolean("TRANG_THAI")
                );
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public List<User> getAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM NGUOIDUNG ORDER BY ID DESC";
        try (Connection con = DbConnector.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new User(
                        rs.getInt("ID"),
                        rs.getString("TEN_DANG_NHAP"),
                        rs.getString("MAT_KHAU"),
                        rs.getString("NHOM_QUYEN"),
                        rs.getBoolean("TRANG_THAI")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public User getById(int id) {
        String sql = "SELECT * FROM NGUOIDUNG WHERE ID = ?";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(rs.getInt("ID"), rs.getString("TEN_DANG_NHAP"),
                        rs.getString("MAT_KHAU"), rs.getString("NHOM_QUYEN"),
                        rs.getBoolean("TRANG_THAI"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
    public void save(User u, boolean isUpdate) throws Exception {
        String sql = isUpdate
                ? "UPDATE NGUOIDUNG SET TEN_DANG_NHAP=?, MAT_KHAU=?, NHOM_QUYEN=?, TRANG_THAI=? WHERE ID=?"
                : "INSERT INTO NGUOIDUNG (TEN_DANG_NHAP, MAT_KHAU, NHOM_QUYEN, TRANG_THAI) VALUES(?,?,?,1)";
        try (Connection con = DbConnector.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, u.getTenDangNhap());
            ps.setString(2, u.getMatKhau());
            ps.setString(3, u.getNhomQuyen());
            if (isUpdate) {
                ps.setBoolean(4, u.isTrangThai());
                ps.setInt(5, u.getId());
            }
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws Exception {
        String sql = "DELETE FROM NGUOIDUNG WHERE ID = ?";
        try (Connection con = DbConnector.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
    public List<User> searchUsers(String keyword) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM NGUOIDUNG WHERE TEN_DANG_NHAP LIKE ? ORDER BY ID DESC";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + (keyword == null ? "" : keyword) + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new User(
                        rs.getInt("ID"),
                        rs.getString("TEN_DANG_NHAP"),
                        rs.getString("MAT_KHAU"),
                        rs.getString("NHOM_QUYEN"),
                        rs.getBoolean("TRANG_THAI")
                ));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM NGUOIDUNG WHERE TEN_DANG_NHAP = ?";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}