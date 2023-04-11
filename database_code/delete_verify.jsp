<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="UTF-8"%><%@ page import="java.sql.*"%>
<html><head><title>수강신청 삭제</title></head>
<body>
<% 
String s_id = (String) session.getAttribute("session_id");
String c_id = request.getParameter("c_id");
int c_class = Integer.parseInt(request.getParameter("c_class"));

Integer year = (Integer) session.getAttribute("yearNow");
Integer semester = (Integer) session.getAttribute("semesterNow");


String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
String user = "db1715333";
String passwd = "ss2";
String dbdriver = "oracle.jdbc.driver.OracleDriver";
Class.forName(dbdriver);
Connection conn = DriverManager.getConnection(dburl, user, passwd);

Statement stmt = conn.createStatement();

String SQL = "DELETE FROM enroll WHERE s_id='"+s_id+"' and c_id='"+c_id+"' and c_class=" + c_class + " and e_year="+year+"and e_semester="+semester;
int resultSet = stmt.executeUpdate(SQL);

stmt.close();
conn.close();
%>

<script>
   alert("수강취소가 완료 되었습니다.");
   location.href="delete.jsp";
</script>

</body>
</html>