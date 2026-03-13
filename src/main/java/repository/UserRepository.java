package repository;

import helper.DbConnector;
import model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class UserRepository {

    public User login(String tenDangNhap, String matKhau) {
        String sql = "SELECT NHOM_QUYEN FROM NGUOIDUNG WHERE TEN_DANG_NHAP = ? AND MAT_KHAU = ?";

        try (Connection con = DbConnector.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setString(1, tenDangNhap);
            pstmt.setString(2, matKhau);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String nhomQuyen = rs.getString("NHOM_QUYEN");
                    return new User(tenDangNhap, matKhau, nhomQuyen);
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi đăng nhập CSDL: " + e.getMessage());
        }
        return null;
    }
    public List<User> getAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM NGUOIDUNG";
        try (Connection con = DbConnector.getConnection();
             Statement st = con.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(new User(rs.getString(1), rs.getString(2), rs.getString(3)));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public void save(User u, boolean isUpdate) throws Exception {
        String sql = isUpdate ? "UPDATE NGUOIDUNG SET MAT_KHAU=?, NHOM_QUYEN=? WHERE TEN_DANG_NHAP=?"
                : "INSERT INTO NGUOIDUNG VALUES(?,?,?)";
        try (Connection con = DbConnector.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, isUpdate ? u.getMatKhau() : u.getTenDangNhap());
            ps.setString(2, isUpdate ? u.getNhomQuyen() : u.getMatKhau());
            ps.setString(3, isUpdate ? u.getTenDangNhap() : u.getNhomQuyen());
            ps.executeUpdate();
        }
    }

    public void delete(String username) throws Exception {
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement("DELETE FROM NGUOIDUNG WHERE TEN_DANG_NHAP=?")) {
            ps.setString(1, username);
            ps.executeUpdate();
        }
    }
}