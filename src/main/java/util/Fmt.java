package util;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/** Hàm tiện ích định dạng dữ liệu hiển thị trong JSP. */
public class Fmt {
    public static String esc(Object o) {
        if (o == null)
            return "";
        return o.toString().replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;");
    }

    public static String money(BigDecimal v) {
        if (v == null)
            return "0";
        String orgin = v.toString();
        String fmt = "";
        for (int i = orgin.length() - 1; i >= 0; i--) {
            if (i % 3 == orgin.length() % 3 && i != 0) {
                fmt = "." + orgin.charAt(i) + fmt;
            } else {
                fmt = orgin.charAt(i) + fmt;
            }
        }
        return fmt;
    }

    public static String dt(LocalDateTime t) {
        return t == null ? "" : t.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }

    public static String formatDate(String dateStr) {
        if (dateStr == null || dateStr.isEmpty())
            return "";
        try {
            // Giả sử dateStr từ DB hoặc input có dạng "yyyy-MM-dd"
            LocalDate date = LocalDate.parse(dateStr);
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            return date.format(formatter);
        } catch (Exception e) {
            return dateStr; // Trả về nguyên bản nếu không parse được
        }
    }

    /** URL của ảnh được phục vụ bởi ImageServlet (rỗng -> ảnh mặc định). */
    public static String img(String contextPath, String fileName) {
        String n = (fileName == null || fileName.trim().isEmpty()) ? "no-image.svg" : fileName.trim();
        try {
            n = java.net.URLEncoder.encode(n, "UTF-8");
        } catch (Exception e) {
        }
        return contextPath + "/image?name=" + n;
    }
}
