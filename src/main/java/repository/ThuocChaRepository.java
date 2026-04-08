package repository;

import helper.DbConnector;
import model.DonViTinh;
import model.LoaiThuoc;
import model.ThuocCha;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ThuocChaRepository {
    public List<ThuocCha> getAll() {
        List<ThuocCha> list = new ArrayList<>();
        // Thêm JOIN để lấy tên loại và đơn vị
        String sql = "SELECT tc.*, l.TEN_LOAI, d.TEN_DON_VI " +
                "FROM THUOC_CHA tc " +
                "LEFT JOIN LOAI_THUOC l ON tc.ID_LOAI = l.ID " +
                "LEFT JOIN DON_VI_TINH d ON tc.ID_DON_VI = d.ID";
        try (Connection con = DbConnector.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                ThuocCha tc = new ThuocCha(
                        rs.getInt("ID"),
                        rs.getString("TEN_THUOC_CHA"),
                        rs.getInt("ID_LOAI"),
                        rs.getInt("ID_DON_VI"),
                        rs.getDouble("GIA_BAN_MAC_DINH"),
                        rs.getBoolean("TINH_TRANG")
                );

                // Đổ dữ liệu vào object LoaiThuoc và DonViTinh
                LoaiThuoc lt = new LoaiThuoc();
                lt.setId(rs.getInt("ID_LOAI"));
                lt.setTenLoai(rs.getString("TEN_LOAI"));
                tc.setLoaiThuoc(lt);

                DonViTinh dv = new DonViTinh();
                dv.setId(rs.getInt("ID_DON_VI"));
                dv.setTenDonVi(rs.getString("TEN_DON_VI"));
                tc.setDonViTinh(dv);

                list.add(tc);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public ThuocCha getById(int id) {
        String sql = "SELECT tc.*, l.TEN_LOAI, d.TEN_DON_VI " +
                "FROM THUOC_CHA tc " +
                "LEFT JOIN LOAI_THUOC l ON tc.ID_LOAI = l.ID " +
                "LEFT JOIN DON_VI_TINH d ON tc.ID_DON_VI = d.ID " +
                "WHERE tc.ID = ?";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ThuocCha tc = new ThuocCha(
                        rs.getInt("ID"),
                        rs.getString("TEN_THUOC_CHA"),
                        rs.getInt("ID_LOAI"),
                        rs.getInt("ID_DON_VI"),
                        rs.getDouble("GIA_BAN_MAC_DINH"),
                        rs.getBoolean("TINH_TRANG")
                );

                LoaiThuoc lt = new LoaiThuoc();
                lt.setTenLoai(rs.getString("TEN_LOAI"));
                tc.setLoaiThuoc(lt);

                DonViTinh dv = new DonViTinh();
                dv.setTenDonVi(rs.getString("TEN_DON_VI"));
                tc.setDonViTinh(dv);

                return tc;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public void add(ThuocCha tc) throws Exception {
        String sql = "INSERT INTO THUOC_CHA (TEN_THUOC_CHA, ID_LOAI, ID_DON_VI, GIA_BAN_MAC_DINH, TINH_TRANG) VALUES(?,?,?,?,?)";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, tc.getTen_thuoc_cha());
            ps.setInt(2, tc.getId_loai());
            ps.setInt(3, tc.getId_don_vi());
            ps.setDouble(4, tc.getGia_mac_dinh());
            ps.setBoolean(5, tc.getTinh_trang());
            ps.executeUpdate();
        }
    }

    public void update(ThuocCha tc) throws Exception {
        String sql = "UPDATE THUOC_CHA SET TEN_THUOC_CHA = ?, ID_LOAI = ?, ID_DON_VI = ?, GIA_BAN_MAC_DINH = ?, TINH_TRANG = ? WHERE ID = ?";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, tc.getTen_thuoc_cha());
            ps.setInt(2, tc.getId_loai());
            ps.setInt(3, tc.getId_don_vi());
            ps.setDouble(4, tc.getGia_mac_dinh());
            ps.setBoolean(5, tc.getTinh_trang());
            ps.setInt(6, tc.getId());
            ps.executeUpdate();
        }
    }

    public void deleteById(int id) {
        String sql = "DELETE FROM THUOC_CHA WHERE ID = ?";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public List<ThuocCha> search(String timkiem) {
        List<ThuocCha> list = new ArrayList<>();
        // Thêm JOIN để lấy TEN_LOAI và TEN_DON_VI khi tìm kiếm
        String sql = "SELECT tc.*, l.TEN_LOAI, d.TEN_DON_VI " +
                "FROM THUOC_CHA tc " +
                "LEFT JOIN LOAI_THUOC l ON tc.ID_LOAI = l.ID " +
                "LEFT JOIN DON_VI_TINH d ON tc.ID_DON_VI = d.ID " +
                "WHERE tc.TEN_THUOC_CHA LIKE ?";

        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + timkiem + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ThuocCha tc = new ThuocCha(
                        rs.getInt("ID"),
                        rs.getString("TEN_THUOC_CHA"),
                        rs.getInt("ID_LOAI"),
                        rs.getInt("ID_DON_VI"),
                        rs.getDouble("GIA_BAN_MAC_DINH"),
                        rs.getBoolean("TINH_TRANG")
                );

                // Khởi tạo và đổ dữ liệu cho đối tượng LoaiThuoc
                LoaiThuoc lt = new LoaiThuoc();
                lt.setId(rs.getInt("ID_LOAI"));
                lt.setTenLoai(rs.getString("TEN_LOAI"));
                tc.setLoaiThuoc(lt);

                // Khởi tạo và đổ dữ liệu cho đối tượng DonViTinh
                DonViTinh dv = new DonViTinh();
                dv.setId(rs.getInt("ID_DON_VI"));
                dv.setTenDonVi(rs.getString("TEN_DON_VI"));
                tc.setDonViTinh(dv);

                list.add(tc);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<DonViTinh> getAllDonViTinh() {
        List<DonViTinh> list = new ArrayList<>();
        String sql = "SELECT ID, TEN_DON_VI FROM DON_VI_TINH";
        try (Connection con = DbConnector.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new DonViTinh(rs.getInt("ID"), rs.getString("TEN_DON_VI")));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<LoaiThuoc> getAllLoaiThuoc() {
        List<LoaiThuoc> list = new ArrayList<>();
        String sql = "SELECT ID, TEN_LOAI FROM LOAI_THUOC WHERE TRANG_THAI = 1";
        try (Connection con = DbConnector.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                LoaiThuoc lt = new LoaiThuoc();
                lt.setId(rs.getInt("ID"));
                lt.setTenLoai(rs.getString("TEN_LOAI"));
                list.add(lt);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean isThuocDaCoLo(int idThuoc) {
        // Sửa lại cho khớp hoàn toàn với CREATE TABLE bạn vừa gửi
        String sql = "SELECT COUNT(*) FROM THUOC WHERE ID_TEN_THUOC = ?";
        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idThuoc);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Hàm chuyên biệt cho Combobox Nhập Kho - Tối ưu nhất
    public List<ThuocCha> getThuocChaDangBan() {
        List<ThuocCha> list = new ArrayList<>();
        // Chỉ lấy ID và Tên để Combobox load cực nhanh
        String sql = "SELECT ID, TEN_THUOC_CHA FROM THUOC_CHA WHERE TINH_TRANG = 1 ORDER BY TEN_THUOC_CHA ASC";

        try (Connection con = DbConnector.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                ThuocCha tc = new ThuocCha();
                tc.setId(rs.getInt("ID"));
                tc.setTen_thuoc_cha(rs.getString("TEN_THUOC_CHA"));
                list.add(tc);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}