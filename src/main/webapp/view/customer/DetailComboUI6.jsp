<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,model.*,dao.*,util.Fmt" %>
<%
int id = 0;
try { id = Integer.parseInt(request.getParameter("id")); } catch (Exception e) {}
ComboDAO6 dao = new ComboDAO6();
Combo6 c = dao.getCombo(id);
List<ComboDetail6> details = dao.getDetail(id);
%>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Chi tiết combo</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css"></head><body>
<h2>Thông tin chi tiết combo</h2>
<% if (c == null) { %><p>Không tìm thấy combo.</p><% } else { %>
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
    <p><b>Giá gốc:</b> <span style="text-decoration:line-through;color:#888"><%=Fmt.money(c.getSellingPrice())%></span></p>
    <p><b>Giá bán:</b> <span style="color:#c8202f;font-weight:bold"><%=Fmt.money(c.getSalePrice())%></span></p>
    <p><b>Thời gian áp dụng:</b> <%=Fmt.esc(c.getDuration())%></p>
  </div>
</div>
<% } %>
<a class="btn" href="javascript:history.back()">Quay lại</a>
</body></html>
