package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Combo6;
import model.ComboDetail6;
import model.MenuItem6;

public class ComboDAO6 extends DAO6 {
    public ComboDAO6() { super(); }

    private Combo6 map(ResultSet rs) throws Exception {
        Combo6 c = new Combo6();
        c.setId(rs.getInt("id"));
        c.setName(rs.getString("name"));
        c.setSellingPrice(rs.getBigDecimal("sellingPrice"));
        c.setSalePrice(rs.getBigDecimal("salePrice"));
        c.setDuration(rs.getString("duration"));
        c.setImage(rs.getString("image"));
        c.setDescription(rs.getString("description"));
        return c;
    }

    /** Tìm các combo có tên chứa từ khóa. */
    public List<Combo6> searchByName(String keyword) {
        List<Combo6> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM tblCombo WHERE name LIKE ? ORDER BY name")) {
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /** Thông tin chung của combo (bổ sung để hiển thị cả khi combo chưa có món). */
    public Combo6 getCombo(int idCombo) {
        try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM tblCombo WHERE id = ?")) {
            ps.setInt(1, idCombo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    /** Danh sách món (kèm số lượng) trong combo. */
    public List<ComboDetail6> getDetail(int idCombo) {
        List<ComboDetail6> list = new ArrayList<>();
        Combo6 combo = getCombo(idCombo);
        String sql = "SELECT cd.quantity, m.id, m.name, m.price "
                   + "FROM tblComboDetail cd JOIN tblMenuItem m ON cd.tblMenuItemId = m.id "
                   + "WHERE cd.tblComboId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idCombo);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MenuItem6 m = new MenuItem6();
                    m.setId(rs.getInt("id"));
                    m.setName(rs.getString("name"));
                    m.setPrice(rs.getBigDecimal("price"));
                    ComboDetail6 d = new ComboDetail6();
                    d.setQuantity(rs.getInt("quantity"));
                    d.setMenuItem(m);
                    d.setCombo(combo);
                    list.add(d);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}
