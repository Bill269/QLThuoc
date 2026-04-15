package model;

public class User {
    private int id;
    private String tenDangNhap;
    private String matKhau;
    private String nhomQuyen;
    private boolean trangThai;

    public User() {
    }

    public User(String tenDangNhap, String matKhau, String nhomQuyen, boolean trangThai) {
        this.tenDangNhap = tenDangNhap;
        this.matKhau = matKhau;
        this.nhomQuyen = nhomQuyen;
        this.trangThai = trangThai;
    }

    public User(int id, String tenDangNhap, String matKhau, String nhomQuyen, boolean trangThai) {
        this.id = id;
        this.tenDangNhap = tenDangNhap;
        this.matKhau = matKhau;
        this.nhomQuyen = nhomQuyen;
        this.trangThai = trangThai;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTenDangNhap() {
        return tenDangNhap;
    }

    public void setTenDangNhap(String tenDangNhap) {
        this.tenDangNhap = tenDangNhap;
    }

    public String getMatKhau() {
        return matKhau;
    }

    public void setMatKhau(String matKhau) {
        this.matKhau = matKhau;
    }

    public String getNhomQuyen() {
        return nhomQuyen;
    }

    public void setNhomQuyen(String nhomQuyen) {
        this.nhomQuyen = nhomQuyen;
    }

    public boolean isTrangThai() {
        return trangThai;
    }

    public void setTrangThai(boolean trangThai) {
        this.trangThai = trangThai;
    }
}