<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*,util.Fmt" %>
<%
// Chưa đăng nhập -> chuyển về trang đăng nhập
if (session.getAttribute("manager") == null) {
    response.sendRedirect(request.getContextPath() + "/view/manager/LoginUI6.jsp");
    return;
}
%>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Chọn thống kê</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css"></head><body>
<% Manager6 _mgr = (Manager6) session.getAttribute("manager"); %>
<div class="user-info">
  <div class="name">&#128100; <%=Fmt.esc(_mgr.getFullName())%></div>
  <div class="meta">Nhân viên quản lý &middot; <%=Fmt.esc(_mgr.getUserName())%></div>
  <a href="<%=request.getContextPath()%>/view/manager/LogoutUI6.jsp">Đăng xuất</a>
</div>
<h2>Chọn thống kê</h2>
<p><a class="btn" href="CustomerRevenueStatisticUI6.jsp">Thống kê khách hàng theo doanh thu</a></p>
<a class="btn" href="ManagerMainUI6.jsp">Quay lại</a>
</body></html>
