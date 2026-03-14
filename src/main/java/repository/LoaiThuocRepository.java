package repository;

import helper.DbConnector;
import model.LoaiThuoc;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LoaiThuocRepository {

    public List<LoaiThuoc> getAll() {
        List<LoaiThuoc> list = new ArrayList<>();
        String sql = "SELECT * FROM LOAI_THUOC";
        try (Connection con = DbConnector.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new LoaiThuoc(rs.getInt("ID"), rs.getString("TEN_LOAI")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public LoaiThuoc getById(int id) {
        String sql = "SELECT * FROM LOAI_THUOC WHERE ID = ?";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new LoaiThuoc(rs.getInt("ID"), rs.getString("TEN_LOAI"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void add(LoaiThuoc lt) throws Exception {
        String sql = "INSERT INTO LOAI_THUOC (TEN_LOAI) VALUES (?)";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, lt.getTenLoai());
            ps.executeUpdate();
        }
    }


    public void update(LoaiThuoc lt) throws Exception {
        String sql = "UPDATE LOAI_THUOC SET TEN_LOAI = ? WHERE ID = ?";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, lt.getTenLoai());
            ps.setInt(2, lt.getId());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws Exception {
        String sql = "DELETE FROM LOAI_THUOC WHERE ID = ?";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
}