package model;

import java.math.BigDecimal;
import java.time.LocalDate;

/** Thống kê doanh thu của một khách hàng: kế thừa Customer6 (id, họ tên...) + doanh thu trong khoảng thời gian. */
public class StatisticsCustomerRevenue6 extends Customer6 {
    private BigDecimal income;
    private LocalDate startDate, endDate;
    public BigDecimal getIncome() { return income; }
    public void setIncome(BigDecimal income) { this.income = income; }
    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }
    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }
}
