package model;

import java.math.BigDecimal;

public class Combo6 {
    private int id;
    private String name, duration, image, description;
    private BigDecimal sellingPrice, salePrice;
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public BigDecimal getSellingPrice() { return sellingPrice; }
    public void setSellingPrice(BigDecimal v) { this.sellingPrice = v; }
    public BigDecimal getSalePrice() { return salePrice; }
    public void setSalePrice(BigDecimal v) { this.salePrice = v; }
    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    public void setDescription(String description) { this.description = description; }
    public String getDescription() { return description; }
}
