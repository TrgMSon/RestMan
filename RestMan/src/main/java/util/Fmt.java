package util;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/** Hàm tiện ích định dạng dữ liệu hiển thị trong JSP. */
public class Fmt {
    public static String esc(Object o) {
        if (o == null) return "";
        return o.toString().replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;");
    }
    public static String money(BigDecimal v) {
        return v == null ? "0" : new DecimalFormat("#,##0").format(v) + " đ";
    }
    public static String dt(LocalDateTime t) {
        return t == null ? "" : t.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }

    /** URL của ảnh được phục vụ bởi ImageServlet (rỗng -> ảnh mặc định). */
    public static String img(String contextPath, String fileName) {
        String n = (fileName == null || fileName.trim().isEmpty()) ? "no-image.svg" : fileName.trim();
        try { n = java.net.URLEncoder.encode(n, "UTF-8"); } catch (Exception e) { }
        return contextPath + "/image?name=" + n;
    }
}
