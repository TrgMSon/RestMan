<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*,dao.*,util.Fmt" %>
<%
request.setCharacterEncoding("UTF-8");
if (session.getAttribute("manager") != null) {
    response.sendRedirect("ManagerMainUI6.jsp");
    return;
}
String error = null, userName = request.getParameter("userName");
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String password = request.getParameter("password");
    Manager6 m = (userName == null || password == null) ? null
               : new MemberDAO6().checkLoginManager(userName.trim(), password);
    if (m != null) {
        request.changeSessionId();                 // chống session fixation
        session.setAttribute("manager", m);
        response.sendRedirect("ManagerMainUI6.jsp");
        return;
    }
    error = "Sai tên đăng nhập hoặc mật khẩu, hoặc tài khoản không phải nhân viên quản lý.";
}
%>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Đăng nhập</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css"></head><body>
<h2>Đăng nhập nhân viên quản lý</h2>
<% if (error != null) { %><p style="color:red"><%=error%></p><% } %>
<form method="post" action="LoginUI6.jsp">
  <p>Tên đăng nhập: <input type="text" name="userName" value="<%=Fmt.esc(userName)%>" required autofocus></p>
  <p>Mật khẩu: <input type="password" name="password" required></p>
  <button type="submit">Đăng nhập</button>
</form>
<p><a class="btn" href="<%=request.getContextPath()%>/index.jsp">Về trang chủ</a></p>
</body></html>
