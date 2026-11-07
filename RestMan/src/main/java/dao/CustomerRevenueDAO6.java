package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Customer6;
import model.StatisticsCustomerRevenue6;

public class CustomerRevenueDAO6 extends DAO6 {
    public CustomerRevenueDAO6() { super(); }

    /** Thống kê doanh thu theo khách hàng trong khoảng [start, end), sắp xếp giảm dần. */
    public List<StatisticsCustomerRevenue6> getStatisticRevenueCustomer(LocalDateTime start, LocalDateTime end) {
        List<StatisticsCustomerRevenue6> list = new ArrayList<>();
        String sql = "SELECT m.id, m.fullName, SUM(i.totalAmount) AS income "
                   + "FROM tblInvoice i JOIN tblMember m ON i.customerId = m.id "
                   + "WHERE i.purchasedAt >= ? AND i.purchasedAt < ? "
                   + "GROUP BY m.id, m.fullName ORDER BY income DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(start));
            ps.setTimestamp(2, Timestamp.valueOf(end));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StatisticsCustomerRevenue6 s = new StatisticsCustomerRevenue6();
                    s.setId(rs.getInt("id"));
                    s.setFullName(rs.getString("fullName"));
                    s.setIncome(rs.getBigDecimal("income"));
                    s.setStartDate(start.toLocalDate());
                    s.setEndDate(end.toLocalDate().minusDays(1));
                    list.add(s);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /** Thông tin 1 khách hàng. */
    public Customer6 getDetailCustomer(int idCustomer) {
        try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM tblMember WHERE id = ?")) {
            ps.setInt(1, idCustomer);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer6 c = new Customer6();
                    c.setId(rs.getInt("id"));
                    c.setUserName(rs.getString("userName"));
                    c.setFullName(rs.getString("fullName"));
                    c.setEmail(rs.getString("email"));
                    c.setPhoneNumber(rs.getString("phoneNumber"));
                    c.setAddress(rs.getString("address"));
                    return c;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
}
