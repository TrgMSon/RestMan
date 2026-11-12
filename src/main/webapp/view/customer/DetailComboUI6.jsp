<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,model.*,dao.*,util.Fmt" %>
<%
// Lấy lại đúng đối tượng Combo6 đã được trang tìm kiếm lưu trong session; chỉ truy vấn danh sách món trong combo
int id = 0;
try { id = Integer.parseInt(request.getParameter("id")); } catch (Exception e) { }
Combo6 c = null;
@SuppressWarnings("unchecked")
List<Combo6> results = (List<Combo6>) session.getAttribute("resultCombos");
if (results != null) {
    for (Combo6 x : results) { if (x.getId() == id) { c = x; break; } }
}
List<ComboDetail6> details = (c == null) ? new ArrayList<ComboDetail6>() : new ComboDAO6().getDetail(c.getId());
%>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Chi tiết combo</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css"></head><body>
<h2>Thông tin chi tiết combo</h2>
<% if (c == null) { %><p>Không tìm thấy combo trong kết quả tìm kiếm (có thể phiên làm việc đã hết hạn). Vui lòng tìm kiếm lại.</p><% } else { %>
<div class="detail">
  <div class="pic"><img src="<%=Fmt.img(request.getContextPath(), c.getImage())%>" alt="<%=Fmt.esc(c.getName())%>"></div>
  <div class="info">
    <p><b>Tên combo:</b> <%=Fmt.esc(c.getName())%></p>
    <p><b>Mô tả:</b> <%=Fmt.esc(c.getDescription())%></p>
    <p><b>Danh sách món ăn:</b></p>
    <table><tr><th>Tên</th><th>Số lượng</th><th>Đơn giá</th></tr>
    <% for (ComboDetail6 d : details) { %>
      <tr><td><%=Fmt.esc(d.getMenuItem().getName())%></td><td><%=d.getQuantity()%></td>
          <td class="r"><%=Fmt.money(d.getMenuItem().getPrice())%></td></tr>
    <% } %></table>
    <p><b>Giá bán:</b> <span style="color:#c8202f;font-weight:bold"><%=Fmt.money(c.getPrice())%></span></p>
    <p><b>Thời gian áp dụng:</b> <%=Fmt.esc(c.getDuration())%></p>
  </div>
</div>
<% } %>
<a class="btn" href="javascript:history.back()">Quay lại</a>
</body></html>
