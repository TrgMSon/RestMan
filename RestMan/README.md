# RestMan – Modul Tìm kiếm món ăn & Thống kê khách hàng theo doanh thu
1. Chạy `sql/restman.sql` trong MySQL 8 (tạo DB `restman` + dữ liệu mẫu).
2. Sửa user/password MySQL trong `src/main/java/dao/DAO6.java`.
3. `mvn clean package` -> deploy `target/RestMan.war` vào Tomcat 9 (javax.servlet), JDK 11+.
4. Mở http://localhost:8080/RestMan/
   - Khách hàng: view/customer/CustomerMainUI6.jsp
   - Quản lý:    view/manager/ManagerMainUI6.jsp (thống kê thử: 2026-09-01 → 2026-10-31)

## Đăng nhập
- Chỉ nhân viên quản lý phải đăng nhập (`view/manager/LoginUI6.jsp`); khách hàng dùng thẳng không cần đăng nhập.
- Tài khoản mẫu: `manager` / `123456`. Các trang trong `view/manager/` (trừ trang đăng nhập) được bảo vệ bằng `auth.jspf`.

## Ảnh món ăn / combo
- Ảnh lưu trong `src/main/webapp/WEB-INF/images/` (không truy cập trực tiếp qua URL); cột `image` trong DB chỉ lưu **tên file**.
- `view.ImageServlet` (`/image?name=...`) đọc file từ thư mục ảnh trên server và trả về trình duyệt; thiếu ảnh -> `no-image.svg`.
- Thay ảnh thật: copy file (png/jpg/svg/webp) vào thư mục trên rồi sửa tên file ở cột `image`. Muốn dùng thư mục ngoài WAR: chạy Tomcat với `-Drestman.imageDir=D:/restman/images`.
