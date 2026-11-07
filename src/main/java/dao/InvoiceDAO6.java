package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Customer6;
import model.Invoice6;
import model.Table6;
import model.WaitStaff6;

public class InvoiceDAO6 extends DAO6 {
    public InvoiceDAO6() { super(); }

    /** Các hóa đơn của 1 khách trong khoảng [start, end). */
    public List<Invoice6> getInvoiceByCustomerId(int idCustomer, LocalDateTime start, LocalDateTime end) {
        List<Invoice6> list = new ArrayList<>();
        String sql = "SELECT id, totalAmount, purchasedAt, purchaseMethod FROM tblInvoice "
                   + "WHERE customerId = ? AND tableId IS NULL AND purchasedAt >= ? AND purchasedAt < ? ORDER BY purchasedAt";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idCustomer);
            ps.setTimestamp(2, Timestamp.valueOf(start));
            ps.setTimestamp(3, Timestamp.valueOf(end));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Invoice6 i = new Invoice6();
                    i.setId(rs.getInt("id"));
                    i.setTotalAmount(rs.getBigDecimal("totalAmount"));
                    i.setPurchasedAt(rs.getTimestamp("purchasedAt").toLocalDateTime());
                    i.setPurchaseMethod(rs.getString("purchaseMethod"));
                    list.add(i);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /** Thông tin chung của 1 hóa đơn (khách, nhân viên, bàn, thời điểm). */
    public Invoice6 getDetail(int idInvoice) {
        String sql = "SELECT i.id, i.totalAmount, i.purchasedAt, i.purchaseMethod, "
                   + "c.id AS cid, c.fullName AS cname, w.id AS wid, w.fullName AS wname, t.id AS tid, t.`number` AS tnum "
                   + "FROM tblInvoice i LEFT JOIN tblMember c ON i.customerId = c.id "
                   + "LEFT JOIN tblMember w ON i.waitStaffId = w.id LEFT JOIN tblTable t ON i.tableId = t.id "
                   + "WHERE i.id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idInvoice);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Invoice6 i = new Invoice6();
                    i.setId(rs.getInt("id"));
                    i.setTotalAmount(rs.getBigDecimal("totalAmount"));
                    i.setPurchasedAt(rs.getTimestamp("purchasedAt").toLocalDateTime());
                    i.setPurchaseMethod(rs.getString("purchaseMethod"));
                    Customer6 c = new Customer6();
                    c.setId(rs.getInt("cid")); c.setFullName(rs.getString("cname"));
                    i.setCustomer(c);
                    WaitStaff6 w = new WaitStaff6();
                    w.setId(rs.getInt("wid")); w.setFullName(rs.getString("wname"));
                    i.setWaitStaff(w);
                    if (rs.getObject("tid") != null) {          // hóa đơn tại quán mới có bàn
                        Table6 t = new Table6();
                        t.setId(rs.getInt("tid")); t.setNumber(rs.getInt("tnum"));
                        i.setTable(t);
                    }
                    return i;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
}
