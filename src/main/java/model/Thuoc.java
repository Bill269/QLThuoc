package model;

import java.util.Date;

public class Thuoc {
    private Long id;
    private String tenThuoc;
    private String loaiThuoc;
    private int soLuongTon;
    private Date hanSuDung;

    public Thuoc() {}

    public Thuoc(Long id, String tenThuoc, String loaiThuoc, int soLuongTon, Date hanSuDung) {
        this.id = id;
        this.tenThuoc = tenThuoc;
        this.loaiThuoc = loaiThuoc;
        this.soLuongTon = soLuongTon;
        this.hanSuDung = hanSuDung;
    }

    public Long getId() {
        return id;
    }

    public String getTenThuoc() {
        return tenThuoc;
    }

    public String getLoaiThuoc() {
        return loaiThuoc;
    }

    public int getSoLuongTon() {
        return soLuongTon;
    }

    public java.util.Date getHanSuDung() {
        return hanSuDung;
    }


    public void setId(Long id) {
        this.id = id;
    }

    public void setTenThuoc(String tenThuoc) {
        this.tenThuoc = tenThuoc;
    }

    public void setLoaiThuoc(String loaiThuoc) {
        this.loaiThuoc = loaiThuoc;
    }

    public void setSoLuongTon(int soLuongTon) {
        this.soLuongTon = soLuongTon;
    }

    public void setHanSuDung(java.util.Date hanSuDung) {
        this.hanSuDung = hanSuDung;
    }
}