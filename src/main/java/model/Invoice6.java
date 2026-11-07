package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Invoice6 {
    private int id;
    private LocalDateTime purchasedAt;
    private BigDecimal totalAmount;
    private String purchaseMethod;
    private Customer6 customer;
    private Table6 table;
    private WaitStaff6 waitStaff;
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public LocalDateTime getPurchasedAt() { return purchasedAt; }
    public void setPurchasedAt(LocalDateTime v) { this.purchasedAt = v; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal v) { this.totalAmount = v; }
    public String getPurchaseMethod() { return purchaseMethod; }
    public void setPurchaseMethod(String v) { this.purchaseMethod = v; }
    public Customer6 getCustomer() { return customer; }
    public void setCustomer(Customer6 customer) { this.customer = customer; }
    public Table6 getTable() { return table; }
    public void setTable(Table6 table) { this.table = table; }
    public WaitStaff6 getWaitStaff() { return waitStaff; }
    public void setWaitStaff(WaitStaff6 waitStaff) { this.waitStaff = waitStaff; }
}
