package repository;

import helper.DbConnector;
import model.DonViTinh;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DonViRepository {

    public List<DonViTinh> getAll() {
        List<DonViTinh> list = new ArrayList<>();
        String sql = "SELECT * FROM DON_VI_TINH ORDER BY TEN_DON_VI ASC";

        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new DonViTinh(
                        rs.getInt("ID"),
                        rs.getString("TEN_DON_VI")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public String getTenById(int id) {
        String sql = "SELECT TEN_DON_VI FROM DON_VI_TINH WHERE ID = ?";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }
}