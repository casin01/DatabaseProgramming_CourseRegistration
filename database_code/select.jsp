<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
 <%@ page import="java.sql.*"  %>   
<html>
<head>
<title>���� ��ȸ</title>
</head>
<body>
<%@ include file="top.jsp" %>
<br>
<form method="post" action="show_enroll.jsp">
   <center>
   <select name="year">
    <option value="2020" selected>2020��</option>
    <option value="2021">2021��</option>
   </select>

   <select name="semester">
    <option value="1" selected>1�б�</option>
    <option value="2">2�б�</option>
   </select>

   <input type="submit" value="�˻�">
   </center>
</form>

</body>
</html>