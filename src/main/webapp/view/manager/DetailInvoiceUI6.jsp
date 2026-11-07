<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,java.time.*,model.*,dao.*,util.Fmt" %>
<%@ include file="auth.jspf" %>
<%
int id = 0;
try { id = Integer.parseInt(request.getParameter("id")); } catch (Exception ex) {}
Invoice6 inv = new InvoiceDAO6().getDetail(id);
List<Detail6> items = new DetailDAO6().getDetail(id);
%>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Chi tiết hóa đơn</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css"></head><body>
<h2>Thông tin chi tiết hóa đơn</h2>
<% if (inv == null) { %><p>Không tìm thấy hóa đơn.</p><% } else { %>
<p><b>Mã hóa đơn:</b> <%=inv.getId()%></p>
<p><b>Khách hàng:</b> <%=Fmt.esc(inv.getCustomer().getFullName())%></p>
<p><b>Nhân viên tạo đơn:</b> <%=Fmt.esc(inv.getWaitStaff().getFullName())%></p>
<p><b>Thời điểm tạo đơn:</b> <%=Fmt.dt(inv.getPurchasedAt())%></p>
<table><tr><th>STT</th><th>Mã món</th><th>Tên món</th><th>Số lượng</th><th>Đơn giá</th></tr>
<% int i = 1; for (Detail6 d : items) { %>
 <tr><td><%=i++%></td><td><%=d.getCode()%></td><td><%=Fmt.esc(d.getName())%></td>
     <td><%=d.getQuantity()%></td><td class="r"><%=Fmt.money(d.getSellingPrice())%></td></tr>
<% } %>
<tr><td colspan="4"><b>Tổng tiền:</b></td><td class="r"><b><%=Fmt.money(inv.getTotalAmount())%></b></td></tr>
</table>
<% } %>
<a class="btn" href="javascript:history.back()">Quay lại</a>
</body></html>
