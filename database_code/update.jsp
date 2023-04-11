<%@ page contentType="text/html; charset=EUC-KR"%>
<%@ page import="java.sql.*"%>
<html>
<head><title>수강신청 사용자 정보 수정</title></head>
<body>
<%@ include file="top.jsp"%>
<%
	if (session_id == null)	response.sendRedirect("login.jsp");
%>
	<table width="75%" align="center" border>
<%

	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
	String user = "db1715333";
	String passwd = "ss2";

	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;

	try {
		Class.forName(dbdriver);
		conn = DriverManager.getConnection(dburl, user, passwd);

		stmt = conn.createStatement();
		String SQL = "select * from student where s_id = '" + session_id + "'";
		rs = stmt.executeQuery(SQL);

		if (rs.next()) {
	%>
		<tr>
			<td><div align="center">이름</div></td>
			<td><div><%=rs.getString("s_name")%></div></td>
		</tr>

		<tr>
			<td><div align="center">학번</div></td>
			<td><div><%=rs.getString("s_id")%></div></td>
		</tr>

		<tr>
			<td><div align="center">학과</div></td>
			<td><div><%=rs.getString("s_major")%></div></td>
		</tr>

	<%
		}
	} catch (ClassNotFoundException e) {
			System.out.println("jdbc driver 오류");
	} catch (SQLException e) {
			System.out.println("오라클 오류");
	} finally {
			if (rs != null)
				try { rs.close(); } catch (SQLException ex) {}
			if (stmt != null)
				try { stmt.close(); } catch (SQLException ex) {}
			if (conn != null)
				try { conn.close(); } catch (SQLException ex) {}
	}
	%>
		<form method="post" action="update_verify.jsp">
			<tr>
				<td><div align="center">현재 비밀번호</div></td>
				<td><div align="left"> <input type="password" name="userPassword"> </div></td>
			</tr>
			<tr>
				<td><div align="center">새 비밀번호</div></td>
				<td><div align="left"> <input type="password" name="newPassword"> </div></td>
			</tr>
			<tr>
				<td colspan=2><div align="center">
				<INPUT TYPE="SUBMIT" NAME="Submit" VALUE="비밀번호 변경"> <INPUT TYPE="RESET" VALUE="취소"> </div></td>
			</tr>
		</form>
	</table>
</body>
</html>