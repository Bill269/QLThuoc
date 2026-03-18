package model;

import java.util.Date;

public class Thuoc {
    private int id;
    private String tenThuoc;
    private String loaiThuoc; // Dùng trực tiếp tên loại (VD: "Giảm đau", "Kháng sinh")
    private int soLuongTon;
    private Date hanSuDung;
    private float giaBan;

    public Thuoc(String tenThuoc, String loaiThuoc, int soLuongTon, Date hanSuDung, float giaBan) {
        this.tenThuoc = tenThuoc;
        this.loaiThuoc = loaiThuoc;
        this.soLuongTon = soLuongTon;
        this.hanSuDung = hanSuDung;
        this.giaBan = giaBan;
    }

    public Thuoc(int id, String tenThuoc, String loaiThuoc, int soLuongTon, Date hanSuDung, float giaBan) {
        this.id = id;
        this.tenThuoc = tenThuoc;
        this.loaiThuoc = loaiThuoc;
        this.soLuongTon = soLuongTon;
        this.hanSuDung = hanSuDung;
        this.giaBan = giaBan;
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
}