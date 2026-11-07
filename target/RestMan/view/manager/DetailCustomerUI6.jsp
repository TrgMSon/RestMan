<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,java.time.*,model.*,dao.*,util.Fmt" %>
<%@ include file="auth.jspf" %>
<%
int id = 0;
try { id = Integer.parseInt(request.getParameter("id")); } catch (Exception ex) {}
String s = request.getParameter("startDate"), e = request.getParameter("endDate");
Customer6 c = new CustomerRevenueDAO6().getDetailCustomer(id);
List<Invoice6> invoices = new ArrayList<>();
try {
    invoices = new InvoiceDAO6().getInvoiceByCustomerId(id,
        LocalDate.parse(s).atStartOfDay(), LocalDate.parse(e).plusDays(1).atStartOfDay());
} catch (Exception ex) {}
java.math.BigDecimal total = java.math.BigDecimal.ZERO;
%>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Các hóa đơn của khách hàng</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css"></head><body>
<h2>Các hóa đơn của khách hàng</h2>
<p>Ngày bắt đầu: <b><%=Fmt.esc(s)%></b> &nbsp; Ngày kết thúc: <b><%=Fmt.esc(e)%></b></p>
<p>Tên khách hàng: <b><%=c==null?"":Fmt.esc(c.getFullName())%></b></p>
<table><tr><th>STT</th><th>Mã hóa đơn</th><th>Tổng tiền</th><th>Thời điểm thanh toán</th></tr>
<% int i = 1; for (Invoice6 inv : invoices) { total = total.add(inv.getTotalAmount()); %>
 <tr><td><%=i++%></td>
     <td><a href="DetailInvoiceUI6.jsp?id=<%=inv.getId()%>"><%=inv.getId()%></a></td>
     <td class="r"><%=Fmt.money(inv.getTotalAmount())%></td>
     <td><%=Fmt.dt(inv.getPurchasedAt())%></td></tr>
<% } %>
<tr><td colspan="2"><b>Tổng:</b></td><td class="r"><b><%=Fmt.money(total)%></b></td><td></td></tr>
</table>
<a class="btn" href="CustomerRevenueStatisticUI6.jsp?startDate=<%=Fmt.esc(s)%>&endDate=<%=Fmt.esc(e)%>">Quay lại</a>
</body></html>
