package model;

import java.util.Date;

public class Thuoc {
    private int id;
    private String tenThuoc;
    private String loaiThuoc;
    private int soLuongTon;
    private Date hanSuDung;

    public Thuoc() {
    }

    public Thuoc(int id, String tenThuoc, String loaiThuoc, int soLuongTon, Date hanSuDung) {
        this.id = id;
        this.tenThuoc = tenThuoc;
        this.loaiThuoc = loaiThuoc;
        this.soLuongTon = soLuongTon;
        this.hanSuDung = hanSuDung;
    }

    public Thuoc(String tenThuoc, String loaiThuoc, int soLuongTon, Date hanSuDung) {
        this.tenThuoc = tenThuoc;
        this.loaiThuoc = loaiThuoc;
        this.soLuongTon = soLuongTon;
        this.hanSuDung = hanSuDung;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTenThuoc() { return tenThuoc; }
    public void setTenThuoc(String tenThuoc) { this.tenThuoc = tenThuoc; }

    public String getLoaiThuoc() { return loaiThuoc; }
    public void setLoaiThuoc(String loaiThuoc) { this.loaiThuoc = loaiThuoc; }

    public int getSoLuongTon() { return soLuongTon; }
    public void setSoLuongTon(int soLuongTon) { this.soLuongTon = soLuongTon; }

    public Date getHanSuDung() { return hanSuDung; }
    public void setHanSuDung(Date hanSuDung) { this.hanSuDung = hanSuDung; }
}