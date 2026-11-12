<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,model.*,dao.*,util.Fmt" %>
<%
request.setCharacterEncoding("UTF-8");
String ctx = request.getContextPath();
String keyword = request.getParameter("keyword");
List<MenuItem6> items = null; List<Combo6> combos = null;
if (keyword != null) {
    keyword = keyword.trim();
    items  = new MenuItemDAO6().searchByName(keyword);
    combos = new ComboDAO6().searchByName(keyword);
    // Giữ nguyên các đối tượng kết quả để trang chi tiết lấy lại, không phải truy vấn lần nữa
    session.setAttribute("resultMenuItems", items);
    session.setAttribute("resultCombos", combos);
}
%>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Tìm kiếm món ăn</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css"></head><body>
<h2>Tìm kiếm món ăn</h2>
<form method="get" action="CustomerSearchUI6.jsp">
  Từ khóa: <input type="text" name="keyword" value="<%=Fmt.esc(keyword)%>">
  <button type="submit">Tìm kiếm</button>
</form>
<% if (items != null) { %>
<h3>Danh sách món ăn</h3>
<% if (items.isEmpty()) { %><div class="empty">Không có món ăn phù hợp</div><% } else { %>
<div class="grid">
<% for (MenuItem6 m : items) { %>
  <a class="card" href="DetailMenuItemUI6.jsp?id=<%=m.getId()%>">
    <img src="<%=Fmt.img(ctx, m.getImage())%>" alt="<%=Fmt.esc(m.getName())%>">
    <div class="title"><%=Fmt.esc(m.getName())%></div>
    <div class="sub"><%=Fmt.esc(m.getDescription())%></div>
    <div class="price"><%=Fmt.money(m.getPrice())%></div>
  </a>
<% } %>
</div>
<% } %>

<h3>Danh sách combo</h3>
<% if (combos.isEmpty()) { %><div class="empty">Không có combo phù hợp</div><% } else { %>
<div class="grid">
<% for (Combo6 c : combos) { %>
  <a class="card" href="DetailComboUI6.jsp?id=<%=c.getId()%>">
    <img src="<%=Fmt.img(ctx, c.getImage())%>" alt="<%=Fmt.esc(c.getName())%>">
    <div class="title"><%=Fmt.esc(c.getName())%></div>
    <div class="sub"><%=Fmt.esc(c.getDescription())%></div>
    <div class="price"><%=Fmt.money(c.getPrice())%></div>
  </a>
<% } %>
</div>
<% } %>
<% } %>
<p><a class="btn" href="CustomerMainUI6.jsp">Quay lại</a></p>
</body></html>
