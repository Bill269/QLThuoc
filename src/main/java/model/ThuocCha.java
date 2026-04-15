package model;

public class ThuocCha {
    private int id;
    private String ten_thuoc_cha;
    private int id_loai;
    private int id_don_vi;
    private Double gia_mac_dinh;
    private Boolean tinh_trang;
    private String hanDung;
    private String moTa;

    // --- PHẦN BỔ SUNG ĐỂ HẾT LỖI ĐỎ ---
    private LoaiThuoc loaiThuoc;  // Đối tượng chứa thông tin Loại thuốc
    private DonViTinh donViTinh;  // Đối tượng chứa thông tin Đơn vị tính

    public ThuocCha() {}

    public ThuocCha(String ten_thuoc_cha, int id_loai, int id_don_vi, Double gia_mac_dinh, Boolean tinh_trang, String hanDung, String moTa, LoaiThuoc loaiThuoc, DonViTinh donViTinh) {
        this.ten_thuoc_cha = ten_thuoc_cha;
        this.id_loai = id_loai;
        this.id_don_vi = id_don_vi;
        this.gia_mac_dinh = gia_mac_dinh;
        this.tinh_trang = tinh_trang;
        this.hanDung = hanDung;
        this.moTa = moTa;
        this.loaiThuoc = loaiThuoc;
        this.donViTinh = donViTinh;
    }

    public ThuocCha(int id, String ten_thuoc_cha, int id_loai, int id_don_vi, Double gia_mac_dinh, Boolean tinh_trang, String hanDung, String moTa, LoaiThuoc loaiThuoc, DonViTinh donViTinh) {
        this.id = id;
        this.ten_thuoc_cha = ten_thuoc_cha;
        this.id_loai = id_loai;
        this.id_don_vi = id_don_vi;
        this.gia_mac_dinh = gia_mac_dinh;
        this.tinh_trang = tinh_trang;
        this.hanDung = hanDung;
        this.moTa = moTa;
        this.loaiThuoc = loaiThuoc;
        this.donViTinh = donViTinh;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTen_thuoc_cha() {
        return ten_thuoc_cha;
    }

    public void setTen_thuoc_cha(String ten_thuoc_cha) {
        this.ten_thuoc_cha = ten_thuoc_cha;
    }

    public int getId_loai() {
        return id_loai;
    }

    public void setId_loai(int id_loai) {
        this.id_loai = id_loai;
    }

    public int getId_don_vi() {
        return id_don_vi;
    }

    public void setId_don_vi(int id_don_vi) {
        this.id_don_vi = id_don_vi;
    }

    public Double getGia_mac_dinh() {
        return gia_mac_dinh;
    }

    public void setGia_mac_dinh(Double gia_mac_dinh) {
        this.gia_mac_dinh = gia_mac_dinh;
    }

    public Boolean getTinh_trang() {
        return tinh_trang;
    }

    public void setTinh_trang(Boolean tinh_trang) {
        this.tinh_trang = tinh_trang;
    }

    public String getHanDung() {
        return hanDung;
    }

    public void setHanDung(String hanDung) {
        this.hanDung = hanDung;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    // Sửa lỗi dòng 26 (Nếu Repo gọi setGiaBanMacDinh thì nó sẽ gán vào gia_mac_dinh)
    public void setGiaBanMacDinh(Double gia) { this.gia_mac_dinh = gia; }
    public Double getGiaBanMacDinh() { return gia_mac_dinh; }

    // Sửa lỗi dòng 35 (Để tc.setLoaiThuoc(loai) không còn đỏ)
    public LoaiThuoc getLoaiThuoc() { return loaiThuoc; }
    public void setLoaiThuoc(LoaiThuoc loaiThuoc) { this.loaiThuoc = loaiThuoc; }

    // Sửa lỗi dòng 36 (Để tc.setDonViTinh(dv) không còn đỏ)
    public DonViTinh getDonViTinh() { return donViTinh; }
    public void setDonViTinh(DonViTinh donViTinh) { this.donViTinh = donViTinh; }


}