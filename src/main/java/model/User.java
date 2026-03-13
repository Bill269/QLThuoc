package model;

public class User {
    private String tenDangNhap;
    private String matKhau;
    private String nhomQuyen;

    public User(String tenDangNhap, String matKhau, String nhomQuyen) {
        this.tenDangNhap = tenDangNhap;
        this.matKhau = matKhau;
        this.nhomQuyen = nhomQuyen;
    }

    public String getTenDangNhap() { return tenDangNhap; }
    public String getMatKhau() { return matKhau; }
    public String getNhomQuyen() { return nhomQuyen; }

}