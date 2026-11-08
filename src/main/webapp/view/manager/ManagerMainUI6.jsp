<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*,util.Fmt" %>
<%
// Chưa đăng nhập -> chuyển về trang đăng nhập
if (session.getAttribute("manager") == null) {
    response.sendRedirect(request.getContextPath() + "/view/manager/LoginUI6.jsp");
    return;
}
%>
<% Manager6 mgr = (Manager6) session.getAttribute("manager"); %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Trang chủ quản lý</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css"></head><body>
<h2>Trang chủ quản lý</h2>
<p>Xin chào, <b><%=Fmt.esc(mgr.getFullName())%></b></p>
<a class="btn" href="StatisticsUI6.jsp">Xem báo cáo</a>
<a class="btn" href="LogoutUI6.jsp">Đăng xuất</a>
</body></html>
