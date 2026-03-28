package model;

public class LoaiThuoc {
    private int id;
    private String tenLoai;
    private  Boolean trangThai;

    public LoaiThuoc() {
    }

    public LoaiThuoc(int id, String tenLoai, Boolean trangThai) {
        this.id = id;
        this.tenLoai = tenLoai;
        this.trangThai = trangThai;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTenLoai() { return tenLoai; }
    public void setTenLoai(String tenLoai) { this.tenLoai = tenLoai; }

    public Boolean getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(Boolean trangThai) {
        this.trangThai = trangThai;
    }
}