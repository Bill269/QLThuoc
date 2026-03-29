package model;

import java.util.Date;

public class Thuoc {
    private int id;
    private String tenThuoc;
    private int idLoai;      // Khóa ngoại ID loại
    private String loaiThuoc; // Tên loại để hiển thị
    private int soLuongTon;
    private java.util.Date ngayNhapThuoc;
    private java.util.Date hanSuDung;
    private float giaBan;
    private int idDonVi;     // Khóa ngoại ID đơn vị
    private String tenDonVi;  // Tên đơn vị để hiển thị
    //hỗ trợ hiển thị trạng thái lô hàng vì dùng EL để hiển thị trên table, v.v
    private String trangThaiThuoc;

    public Thuoc(String tenThuoc, int idLoai, String loaiThuoc, int soLuongTon, Date ngayNhapThuoc, Date hanSuDung, float giaBan, int idDonVi, String tenDonVi) {
        this.tenThuoc = tenThuoc;
        this.idLoai = idLoai;
        this.loaiThuoc = loaiThuoc;
        this.soLuongTon = soLuongTon;
        this.ngayNhapThuoc = ngayNhapThuoc;
        this.hanSuDung = hanSuDung;
        this.giaBan = giaBan;
        this.idDonVi = idDonVi;
        this.tenDonVi = tenDonVi;
    }

    public Thuoc(int id, String tenThuoc, int idLoai, String loaiThuoc, int soLuongTon, Date ngayNhapThuoc, Date hanSuDung, float giaBan, int idDonVi, String tenDonVi) {
        this.id = id;
        this.tenThuoc = tenThuoc;
        this.idLoai = idLoai;
        this.loaiThuoc = loaiThuoc;
        this.soLuongTon = soLuongTon;
        this.ngayNhapThuoc = ngayNhapThuoc;
        this.hanSuDung = hanSuDung;
        this.giaBan = giaBan;
        this.idDonVi = idDonVi;
        this.tenDonVi = tenDonVi;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTenThuoc() {
        return tenThuoc;
    }

    public void setTenThuoc(String tenThuoc) {
        this.tenThuoc = tenThuoc;
    }

    public int getIdLoai() {
        return idLoai;
    }

    public void setIdLoai(int idLoai) {
        this.idLoai = idLoai;
    }

    public String getLoaiThuoc() {
        return loaiThuoc;
    }

    public void setLoaiThuoc(String loaiThuoc) {
        this.loaiThuoc = loaiThuoc;
    }

    public int getSoLuongTon() {
        return soLuongTon;
    }

    public void setSoLuongTon(int soLuongTon) {
        this.soLuongTon = soLuongTon;
    }

    public Date getNgayNhapThuoc() {
        return ngayNhapThuoc;
    }

    public void setNgayNhapThuoc(Date ngayNhapThuoc) {
        this.ngayNhapThuoc = ngayNhapThuoc;
    }

    public Date getHanSuDung() {
        return hanSuDung;
    }

    public void setHanSuDung(Date hanSuDung) {
        this.hanSuDung = hanSuDung;
    }

    public float getGiaBan() {
        return giaBan;
    }

    public void setGiaBan(float giaBan) {
        this.giaBan = giaBan;
    }

    public int getIdDonVi() {
        return idDonVi;
    }

    public void setIdDonVi(int idDonVi) {
        this.idDonVi = idDonVi;
    }

    public String getTenDonVi() {
        return tenDonVi;
    }

    public void setTenDonVi(String tenDonVi) {
        this.tenDonVi = tenDonVi;
    }

    public String getTrangThaiThuoc() {
        return trangThaiThuoc;
    }

    public void setTrangThaiThuoc(String trangThaiThuoc) {
        this.trangThaiThuoc = trangThaiThuoc;
    }
}