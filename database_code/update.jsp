<%@ page contentType="text/html; charset=EUC-KR"%>
<%@ page import="java.sql.*"%>
<html>
<head><title>������û ����� ���� ����</title></head>
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
			<td><div align="center">�̸�</div></td>
			<td><div><%=rs.getString("s_name")%></div></td>
		</tr>

		<tr>
			<td><div align="center">�й�</div></td>
			<td><div><%=rs.getString("s_id")%></div></td>
		</tr>

		<tr>
			<td><div align="center">�а�</div></td>
			<td><div><%=rs.getString("s_major")%></div></td>
		</tr>

	<%
		}
	} catch (ClassNotFoundException e) {
			System.out.println("jdbc driver ����");
	} catch (SQLException e) {
			System.out.println("����Ŭ ����");
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
				<td><div align="center">���� ��й�ȣ</div></td>
				<td><div align="left"> <input type="password" name="userPassword"> </div></td>
			</tr>
			<tr>
				<td><div align="center">�� ��й�ȣ</div></td>
				<td><div align="left"> <input type="password" name="newPassword"> </div></td>
			</tr>
			<tr>
				<td colspan=2><div align="center">
				<INPUT TYPE="SUBMIT" NAME="Submit" VALUE="��й�ȣ ����"> <INPUT TYPE="RESET" VALUE="���"> </div></td>
			</tr>
		</form>
	</table>
</body>
</html>