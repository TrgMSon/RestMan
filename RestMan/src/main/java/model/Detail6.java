package model;

import java.math.BigDecimal;

public class Detail6 {
    private int id, quantity;
    private int code;               // mã món (MenuItem.id hoặc Combo.id)
    private BigDecimal sellingPrice;
    private String name;
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getCode() { return code; }
    public void setCode(int code) { this.code = code; }
    public BigDecimal getSellingPrice() { return sellingPrice; }
    public void setSellingPrice(BigDecimal v) { this.sellingPrice = v; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
}
