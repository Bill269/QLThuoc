package model;

public class ChiTietHoaDon {
    private int idHoaDon;
    private int idThuoc;
    private int soLuong;
    private double giaLucBan;

    // Các trường hỗ trợ hiển thị tên thuốc và loại thuốc trên giao diện
    private String tenThuoc;
    private String loaiThuoc;


    // Constructor mặc định
    public ChiTietHoaDon() {
    }

    // Constructor đầy đủ

    public ChiTietHoaDon(int idHoaDon, int idThuoc, int soLuong, double giaLucBan) {
        this.idHoaDon = idHoaDon;
        this.idThuoc = idThuoc;
        this.soLuong = soLuong;
        this.giaLucBan = giaLucBan;
    }
    public double getThanhTien() {
        return this.soLuong * this.giaLucBan;
    }

    // Getter và Setter

    public int getIdHoaDon() {
        return idHoaDon;
    }

    public void setIdHoaDon(int idHoaDon) {
        this.idHoaDon = idHoaDon;
    }

    public int getIdThuoc() {
        return idThuoc;
    }

    public void setIdThuoc(int idThuoc) {
        this.idThuoc = idThuoc;
    }

    public int getSoLuong() {
        return soLuong;
    }

    public void setSoLuong(int soLuong) {
        this.soLuong = soLuong;
    }

    public double getGiaLucBan() {
        return giaLucBan;
    }

    public void setGiaLucBan(double giaLucBan) {
        this.giaLucBan = giaLucBan;
    }

    public String getTenThuoc() {
        return tenThuoc;
    }

    public void setTenThuoc(String tenThuoc) {
        this.tenThuoc = tenThuoc;
    }

    public String getLoaiThuoc() {
        return loaiThuoc;
    }

    public void setLoaiThuoc(String loaiThuoc) {
        this.loaiThuoc = loaiThuoc;
    }
}