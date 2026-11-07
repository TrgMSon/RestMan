package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Manager6;

public class MemberDAO6 extends DAO6 {
    public MemberDAO6() { super(); }

    /** Kiểm tra đăng nhập của nhân viên quản lý. Trả về null nếu sai thông tin hoặc không phải quản lý. */
    public Manager6 checkLoginManager(String userName, String password) {
        String sql = "SELECT m.id, m.userName, m.fullName, s.position "
                   + "FROM tblMember m JOIN tblStaff s ON s.tblMemberId = m.id "
                   + "WHERE m.userName = ? AND m.password = ? AND s.position = 'MANAGER'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userName);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Manager6 m = new Manager6();
                    m.setId(rs.getInt("id"));
                    m.setUserName(rs.getString("userName"));
                    m.setFullName(rs.getString("fullName"));
                    m.setPosition(rs.getString("position"));
                    return m;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
}
