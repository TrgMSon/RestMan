<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,java.time.*,model.*,dao.*,util.Fmt" %>
<%
// Chưa đăng nhập -> chuyển về trang đăng nhập
if (session.getAttribute("manager") == null) {
    response.sendRedirect(request.getContextPath() + "/view/manager/LoginUI6.jsp");
    return;
}
%>
<%
String s = request.getParameter("startDate"), e = request.getParameter("endDate");
LocalDate today = LocalDate.now(ZoneId.of("Asia/Ho_Chi_Minh"));
List<StatisticsCustomerRevenue6> stats = null;
java.math.BigDecimal total = java.math.BigDecimal.ZERO;
String error = null;
if (s != null && e != null && !s.isEmpty() && !e.isEmpty()) {
    try {
        LocalDate sd = LocalDate.parse(s), ed = LocalDate.parse(e);
        if (ed.isBefore(sd)) error = "Ngày kết thúc phải sau hoặc bằng ngày bắt đầu.";
        else if (sd.isAfter(today)) error = "Ngày bắt đầu không được ở tương lai.";
        else if (ed.isAfter(today)) error = "Ngày kết thúc không được ở tương lai.";
        else stats = new CustomerRevenueDAO6().getStatisticRevenueCustomer(sd.atStartOfDay(), ed.plusDays(1).atStartOfDay());
    } catch (Exception ex) { error = "Ngày không hợp lệ."; }
}
%>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Thống kê khách hàng theo doanh thu</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css"></head><body>
<% Manager6 _mgr = (Manager6) session.getAttribute("manager"); %>
<div class="user-info">
  <div class="name">&#128100; <%=Fmt.esc(_mgr.getFullName())%></div>
  <div class="meta">Nhân viên quản lý &middot;</div>
  <a href="<%=request.getContextPath()%>/view/manager/LogoutUI6.jsp">Đăng xuất</a>
</div>
<h2>Thống kê khách hàng theo doanh thu</h2>
<form method="get" action="CustomerRevenueStatisticUI6.jsp">
  Ngày bắt đầu: <input type="date" name="startDate" value="<%=Fmt.esc(s)%>" max="<%=today%>" required>
  Ngày kết thúc: <input type="date" name="endDate" value="<%=Fmt.esc(e)%>" max="<%=today%>" required>
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
