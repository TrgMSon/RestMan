package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Detail6;

public class DetailDAO6 extends DAO6 {
    public DetailDAO6() { super(); }

    /** Các dòng chi tiết (món lẻ + combo) của 1 hóa đơn. */
    public List<Detail6> getDetail(int idInvoice) {
        List<Detail6> list = new ArrayList<>();
        String sql = "SELECT d.id, x.tblMenuItemId AS code, d.name, d.quantity, d.sellingPrice "
                   + "FROM tblInvoiceDetailMenuItem x JOIN tblDetail d ON x.tblDetailId = d.id WHERE x.tblInvoiceId = ? "
                   + "UNION ALL "
                   + "SELECT d.id, y.tblComboId AS code, d.name, d.quantity, y.salePrice AS sellingPrice "
                   + "FROM tblInvoiceDetailCombo y JOIN tblDetail d ON y.tblDetailId = d.id WHERE y.tblInvoiceId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idInvoice);
            ps.setInt(2, idInvoice);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Detail6 d = new Detail6();
                    d.setId(rs.getInt("id"));
                    d.setCode(rs.getInt("code"));
                    d.setName(rs.getString("name"));
                    d.setQuantity(rs.getInt("quantity"));
                    d.setSellingPrice(rs.getBigDecimal("sellingPrice"));
                    list.add(d);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}
