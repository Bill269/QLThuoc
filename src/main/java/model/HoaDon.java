package model;

import java.sql.Timestamp;

public class HoaDon {
    private int id;
    private Timestamp ngayLap;
    private int idUser;

    // Thêm tên người dùng để hiển thị trên giao diện (Không có trong bảng SQL nhưng cần cho View)
    private String tenNguoiDung;

    // Constructor mặc định
    public HoaDon() {
    }

    // Constructor đầy đủ
    public HoaDon(int id, Timestamp ngayLap, int idUser) {
        this.id = id;
        this.ngayLap = ngayLap;
        this.idUser = idUser;
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
}