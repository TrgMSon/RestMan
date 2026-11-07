<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,java.time.*,model.*,dao.*,util.Fmt" %>
<%@ include file="auth.jspf" %>
<%
String s = request.getParameter("startDate"), e = request.getParameter("endDate");
List<StatisticsCustomerRevenue6> stats = null;
java.math.BigDecimal total = java.math.BigDecimal.ZERO;
String error = null;
if (s != null && e != null && !s.isEmpty() && !e.isEmpty()) {
    try {
        LocalDate sd = LocalDate.parse(s), ed = LocalDate.parse(e);
        if (ed.isBefore(sd)) error = "Ngày kết thúc phải sau hoặc bằng ngày bắt đầu.";
        else stats = new CustomerRevenueDAO6().getStatisticRevenueCustomer(sd.atStartOfDay(), ed.plusDays(1).atStartOfDay());
    } catch (Exception ex) { error = "Ngày không hợp lệ."; }
}
%>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Thống kê khách hàng theo doanh thu</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css"></head><body>
<h2>Thống kê khách hàng theo doanh thu</h2>
<form method="get" action="CustomerRevenueStatisticUI6.jsp">
  Ngày bắt đầu: <input type="date" name="startDate" value="<%=Fmt.esc(s)%>" required>
  Ngày kết thúc: <input type="date" name="endDate" value="<%=Fmt.esc(e)%>" required>
  <button type="submit">Xem thống kê</button>
</form>
<% if (error != null) { %><p style="color:red"><%=error%></p><% } %>
<% if (stats != null) { %>
<table><tr><th>STT</th><th>Mã khách hàng</th><th>Tên khách hàng</th><th>Doanh thu</th></tr>
<% int i = 1; for (StatisticsCustomerRevenue6 r : stats) { total = total.add(r.getIncome()); %>
 <tr><td><%=i++%></td>
     <td><a href="DetailCustomerUI6.jsp?id=<%=r.getId()%>&startDate=<%=s%>&endDate=<%=e%>"><%=r.getId()%></a></td>
     <td><%=Fmt.esc(r.getFullName())%></td>
     <td class="r"><%=Fmt.money(r.getIncome())%></td></tr>
<% } if (stats.isEmpty()) { %><tr><td colspan="4">Không có dữ liệu trong khoảng thời gian này</td></tr><% } %>
<tr><td colspan="3"><b>Tổng:</b></td><td class="r"><b><%=Fmt.money(total)%></b></td></tr>
</table>
<% } %>
<a class="btn" href="StatisticsUI6.jsp">Quay lại</a>
</body></html>
