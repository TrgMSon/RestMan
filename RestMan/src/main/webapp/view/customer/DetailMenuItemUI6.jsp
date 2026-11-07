<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,model.*,dao.*,util.Fmt" %>
<%
int id = 0;
try { id = Integer.parseInt(request.getParameter("id")); } catch (Exception e) {}
MenuItem6 m = new MenuItemDAO6().getDetail(id);
%>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Chi tiết món ăn</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css"></head><body>
<h2>Thông tin chi tiết món ăn</h2>
<% if (m == null) { %><p>Không tìm thấy món ăn.</p><% } else { %>
<div class="detail">
  <div class="pic"><img src="<%=Fmt.img(request.getContextPath(), m.getImage())%>" alt="<%=Fmt.esc(m.getName())%>"></div>
  <div class="info">
    <p><b>Tên món:</b> <%=Fmt.esc(m.getName())%></p>
    <p><b>Loại:</b> <%=Fmt.esc(m.getCategory()==null?"":m.getCategory().getName())%></p>
    <p><b>Mô tả:</b> <%=Fmt.esc(m.getDescription())%></p>
    <p><b>Giá bán:</b> <span style="color:#c8202f;font-weight:bold"><%=Fmt.money(m.getPrice())%></span></p>
  </div>
</div>
<% } %>
<a class="btn" href="javascript:history.back()">Quay lại</a>
</body></html>
