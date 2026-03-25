package model;

public class DonViTinh {
    private int id;
    private String tenDonVi;

    public DonViTinh() {}

    public DonViTinh(int id, String tenDonVi) {
        this.id = id;
        this.tenDonVi = tenDonVi;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTenDonVi() { return tenDonVi; }
    public void setTenDonVi(String tenDonVi) { this.tenDonVi = tenDonVi; }
}