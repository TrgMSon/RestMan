package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.MenuItem6;

public class MenuItemDAO6 extends DAO6 {
    public MenuItemDAO6() { super(); }

    private static final String SELECT =
        "SELECT m.id, m.name, m.price, m.image, m.description "
      + "FROM tblMenuItem m ";

    private MenuItem6 map(ResultSet rs) throws Exception {
        MenuItem6 m = new MenuItem6();
        m.setId(rs.getInt("id"));
        m.setName(rs.getString("name"));
        m.setPrice(rs.getBigDecimal("price"));
        m.setImage(rs.getString("image"));
        m.setDescription(rs.getString("description"));
        return m;
    }

    /** Tìm các món ăn có tên chứa từ khóa. */
    public List<MenuItem6> searchByName(String keyword) {
        List<MenuItem6> list = new ArrayList<>();
        String sql = SELECT + "WHERE m.name LIKE ? AND m.status = 'ACTIVE' ORDER BY m.name";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /** Lấy chi tiết 1 món ăn. */
    public MenuItem6 getDetail(int idMenuItem) {
        try (PreparedStatement ps = conn.prepareStatement(SELECT + "WHERE m.id = ?")) {
            ps.setInt(1, idMenuItem);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
}
