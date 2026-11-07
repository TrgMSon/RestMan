package view;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Locale;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Đọc ảnh món ăn / combo từ thư mục ảnh trên server rồi trả về cho trình duyệt.
 * URL: /image?name=ga-gion-vui-ve.svg
 *
 * Thư mục ảnh mặc định: WEB-INF/images (trong source: src/main/webapp/WEB-INF/images).
 * Muốn đổi sang thư mục khác trên ổ đĩa của server, chạy Tomcat với
 * -Drestman.imageDir=D:/restman/images
 */
@WebServlet("/image")
public class ImageServlet extends HttpServlet {
    private static final Pattern VALID_NAME = Pattern.compile("[A-Za-z0-9_\\-]+\\.(svg|png|jpg|jpeg|gif|webp)");
    private static final String DEFAULT_IMAGE = "no-image.svg";
    private static final String WEB_DIR = "/WEB-INF/images/";

    private Path imageDir;   // null nếu WAR không được giải nén -> đọc qua ServletContext

    @Override
    public void init() throws ServletException {
        String cfg = System.getProperty("restman.imageDir");
        if (cfg != null && !cfg.trim().isEmpty()) {
            imageDir = Paths.get(cfg.trim()).toAbsolutePath().normalize();
        } else {
            String real = getServletContext().getRealPath(WEB_DIR);
            if (real != null) imageDir = Paths.get(real).toAbsolutePath().normalize();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String name = req.getParameter("name");
        if (name == null || !VALID_NAME.matcher(name).matches()) name = DEFAULT_IMAGE;   // chặn ../ và tên lạ

        InputStream in = open(name);
        if (in == null && !name.equals(DEFAULT_IMAGE)) { name = DEFAULT_IMAGE; in = open(name); }
        if (in == null) { resp.sendError(HttpServletResponse.SC_NOT_FOUND); return; }

        resp.setContentType(mimeOf(name));
        resp.setHeader("Cache-Control", "public, max-age=86400");
        try (InputStream is = in; OutputStream os = resp.getOutputStream()) {
            byte[] buf = new byte[8192];
            int n;
            while ((n = is.read(buf)) != -1) os.write(buf, 0, n);
        }
    }

    /** Mở file ảnh từ thư mục ảnh trên server; trả về null nếu không có. */
    private InputStream open(String name) throws IOException {
        if (imageDir != null) {
            Path f = imageDir.resolve(name).normalize();
            if (f.startsWith(imageDir) && Files.isRegularFile(f)) return Files.newInputStream(f);
            return null;
        }
        return getServletContext().getResourceAsStream(WEB_DIR + name);
    }

    private static String mimeOf(String name) {
        String n = name.toLowerCase(Locale.ROOT);
        if (n.endsWith(".svg")) return "image/svg+xml";
        if (n.endsWith(".png")) return "image/png";
        if (n.endsWith(".gif")) return "image/gif";
        if (n.endsWith(".webp")) return "image/webp";
        return "image/jpeg";
    }
}
