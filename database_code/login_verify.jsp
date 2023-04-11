<%@ page language="java" contentType="text/html; charset=EUC-KR"
pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
	String userID = request.getParameter("userID");
String userPassword = request.getParameter("userPassword");

Connection conn = null;
Statement stmt = null;
ResultSet rs= null;

String dbdriver = "oracle.jdbc.driver.OracleDriver";
String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
String user = "db1715333";
String passwd = "ss2";

try {
	Class.forName(dbdriver);
	conn = DriverManager.getConnection(dburl, user, passwd);
	stmt = conn.createStatement();

	String SQL = "select s_id from student where s_id='" + userID + "'and s_pwd='" + userPassword + "'";

	rs = stmt.executeQuery(SQL);
//	System.out.println("id: " + userID + " pwd: " + userPassword);

	if (rs.next()) {
		session.setAttribute("session_id", userID);
		response.sendRedirect("main.jsp");
	} else {
		
		%>
		<script>   
		alert("사용자 아이디 혹은 암호가 틀렸습니다");
		location.href= "login.jsp";
		</script>
		<%
	}

} catch (ClassNotFoundException e) {
	System.out.println("jdbc driver 오류");
} catch (SQLException e) {
	System.out.println("오라클 오류");
}
finally {
	if (rs != null) try { rs.close(); } catch(SQLException ex) {}
    if (stmt != null) try { stmt.close(); } catch(SQLException ex) {}
    if (conn != null) try { conn.close(); } catch(SQLException ex) {}
}

%>