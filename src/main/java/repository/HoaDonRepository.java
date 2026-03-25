package repository;

import helper.DbConnector;
import model.ChiTietHoaDon;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HoaDonRepository {

    /**
     * Lấy danh sách lịch sử bán hàng chi tiết
     * Kết hợp dữ liệu từ CHI_TIET_HOA_DON, HOA_DON và THUOC
     */
    public List<ChiTietHoaDon> getLichSuBanHang() {
        List<ChiTietHoaDon> list = new ArrayList<>();
        // Query lấy dữ liệu đổ vào model ChiTietHoaDon (bao gồm tên thuốc và loại thuốc)
        String sql = "SELECT CT.ID_HOA_DON, T.TEN_THUOC, T.LOAI_THUOC, CT.SO_LUONG " +
                "FROM CHI_TIET_HOA_DON CT " +
                "JOIN HOA_DON HD ON CT.ID_HOA_DON = HD.ID " +
                "JOIN THUOC T ON CT.ID_THUOC = T.ID " +
                "ORDER BY HD.NGAY_LAP ASC";

        try (Connection con = DbConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ChiTietHoaDon ct = new ChiTietHoaDon();
                ct.setIdHoaDon(rs.getInt("ID_HOA_DON"));
                ct.setTenThuoc(rs.getString("TEN_THUOC"));
                ct.setLoaiThuoc(rs.getString("LOAI_THUOC"));
                ct.setSoLuong(rs.getInt("SO_LUONG"));
                list.add(ct);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Hàm bổ trợ để Servlet gọi (Tránh lỗi Cannot resolve method)
     * Trả về cùng dữ liệu với getLichSuBanHang nhưng tên hàm khớp với Servlet bạn đang viết
     */
    public List<ChiTietHoaDon> getAllHoaDonDetail() {
        return getLichSuBanHang();
    }

    /**
     * Tạo hóa đơn mới và trả về ID tự động tăng
     * Dùng trong logic bán hàng (Transaction)
     */
    public int createHoaDon(int idUser) {
        String sql = "INSERT INTO HOA_DON (ID_USER, NGAY_LAP) VALUES (?, GETDATE())";
        try (Connection conn = DbConnector.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, idUser);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Lưu chi tiết hóa đơn
     */
    public void addChiTiet(int idHD, int idThuoc, int soLuong) {
        String sql = "INSERT INTO CHI_TIET_HOA_DON (ID_HOA_DON, ID_THUOC, SO_LUONG) VALUES (?, ?, ?)";
        try (Connection conn = DbConnector.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idHD);
            ps.setInt(2, idThuoc);
            ps.setInt(3, soLuong);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}