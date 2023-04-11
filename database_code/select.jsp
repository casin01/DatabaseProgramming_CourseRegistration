<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
 <%@ page import="java.sql.*"  %>   
<html>
<head>
<title>수강 조회</title>
</head>
<body>
<%@ include file="top.jsp" %>
<br>
<form method="post" action="show_enroll.jsp">
   <center>
   <select name="year">
    <option value="2020" selected>2020년</option>
    <option value="2021">2021년</option>
   </select>

   <select name="semester">
    <option value="1" selected>1학기</option>
    <option value="2">2학기</option>
   </select>

   <input type="submit" value="검색">
   </center>
</form>

</body>
</html>