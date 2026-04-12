package model;

public class GioHangItem {
    private Thuoc thuoc;
    private int soLuong;
    private double thanhTien; // Thêm dòng này

    public GioHangItem() {}

    public GioHangItem(Thuoc thuoc, int soLuong) {
        this.thuoc = thuoc;
        this.soLuong = soLuong;
        // Tự động tính thành tiền khi khởi tạo
        this.thanhTien = soLuong * thuoc.getThuocCha().getGiaBanMacDinh();
    }

    // Getters & Setters
    public Thuoc getThuoc() { return thuoc; }
    public void setThuoc(Thuoc thuoc) { this.thuoc = thuoc; }
    public int getSoLuong() { return soLuong; }
    public void setSoLuong(int soLuong) { this.soLuong = soLuong; }
    public double getThanhTien() {
        return thanhTien;
    }

    public void setThanhTien(double thanhTien) {
        this.thanhTien = thanhTien;
    }
}