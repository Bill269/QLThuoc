package model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class HoaDon {
    private int id;
    private Timestamp ngayLap;
    private int idUser;

    // Thêm tên người dùng để hiển thị trên giao diện (Không có trong bảng SQL nhưng cần cho View)
    private String tenNguoiDung;
    private double tongTien;
    private int tongSoLuong;

    // khac hang
    private String tenKhachHang;
    private String soDienThoai;
    private String email;
    private String diaChi;
    // Constructor mặc định

    public HoaDon() {
    }

    // Constructor đầy đủ
    public HoaDon(int id, Timestamp ngayLap, int idUser) {
        this.id = id;
        this.ngayLap = ngayLap;
        this.idUser = idUser;
    }

    // Trong file model/HoaDon.java
    private List<ChiTietHoaDon> chiTietList = new ArrayList<>();

    public List<ChiTietHoaDon> getChiTietList() {
        return chiTietList;
    }

    public void setChiTietList(List<ChiTietHoaDon> chiTietList) {
        this.chiTietList = chiTietList;
    }
    // Getter và Setter


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Timestamp getNgayLap() {
        return ngayLap;
    }

    public void setNgayLap(Timestamp ngayLap) {
        this.ngayLap = ngayLap;
    }

    public int getIdUser() {
        return idUser;
    }

    public void setIdUser(int idUser) {
        this.idUser = idUser;
    }

    public String getTenNguoiDung() {
        return tenNguoiDung;
    }

    public void setTenNguoiDung(String tenNguoiDung) {
        this.tenNguoiDung = tenNguoiDung;
    }

    public double getTongTien() {
        return tongTien;
    }

    public void setTongTien(double tongTien) {
        this.tongTien = tongTien;
    }

    public int getTongSoLuong() {
        return tongSoLuong;
    }

    public void setTongSoLuong(int tongSoLuong) {
        this.tongSoLuong = tongSoLuong;
    }

    public String getTenKhachHang() {
        return tenKhachHang;
    }

    public void setTenKhachHang(String tenKhachHang) {
        this.tenKhachHang = tenKhachHang;
    }

    public String getSoDienThoai() {
        return soDienThoai;
    }

    public void setSoDienThoai(String soDienThoai) {
        this.soDienThoai = soDienThoai;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getDiaChi() {
        return diaChi;
    }

    public void setDiaChi(String diaChi) {
        this.diaChi = diaChi;
    }
}