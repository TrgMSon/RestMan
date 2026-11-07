package dao;

import java.sql.Connection;
import java.sql.DriverManager;

/** Lớp cha của mọi DAO: quản lý kết nối MySQL (JDBC). */
public class DAO6 {
    private static final String URL = "jdbc:mysql://localhost:3306/restman"
            + "?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh&useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASS = "root";   // <-- đổi theo máy của bạn

    protected static Connection conn;

    public DAO6() {
        synchronized (DAO6.class) {
            try {
                if (conn == null || conn.isClosed() || !conn.isValid(2)) {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(URL, USER, PASS);
                }
            } catch (Exception e) {
                throw new RuntimeException("Không kết nối được CSDL: " + e.getMessage(), e);
            }
        }
    }
}
