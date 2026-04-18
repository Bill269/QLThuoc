package model;

import java.util.Date;

public class Thuoc {
    private int id;
    private ThuocCha thuocCha;
    private int soLuongTon;
    private java.util.Date ngayNhapThuoc;
    private java.util.Date hanSuDung;
    private String trangThaiThuoc;

    public Thuoc() {
        this.thuocCha = new ThuocCha();
    }

    public Thuoc(int id, ThuocCha thuocCha, int soLuongTon, Date ngayNhapThuoc, Date hanSuDung) {
        this.id = id;
        this.thuocCha = thuocCha;
        this.soLuongTon = soLuongTon;
        this.ngayNhapThuoc = ngayNhapThuoc;
        this.hanSuDung = hanSuDung;
    }

    // Getters and Setters...
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public ThuocCha getThuocCha() { return thuocCha; }
    public void setThuocCha(ThuocCha thuocCha) { this.thuocCha = thuocCha; }
    public int getSoLuongTon() { return soLuongTon; }
    public void setSoLuongTon(int soLuongTon) { this.soLuongTon = soLuongTon; }
    public Date getNgayNhapThuoc() { return ngayNhapThuoc; }
    public void setNgayNhapThuoc(Date ngayNhapThuoc) { this.ngayNhapThuoc = ngayNhapThuoc; }
    public Date getHanSuDung() { return hanSuDung; }
    public void setHanSuDung(Date hanSuDung) { this.hanSuDung = hanSuDung; }

    public String getTrangThaiThuoc() {
        return trangThaiThuoc;
    }

    public void setTrangThaiThuoc(String trangThaiThuoc) {
        this.trangThaiThuoc = trangThaiThuoc;
    }
}