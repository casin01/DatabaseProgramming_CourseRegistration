<%@ page contentType="text/html; charset=EUC-KR"%>
<%@ page import="java.sql.*"%>
<html>
<head><title>수강신청 사용자 정보 수정</title></head>
<body>
<%
	String s_id = (String) session.getAttribute("session_id");
	String userPassword = request.getParameter("userPassword");
	String newPassword = request.getParameter("newPassword");

	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
	String user = "db1715333";
	String passwd = "ss2";

	Connection conn = null;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt2 = null;
	ResultSet rs = null;

	try {
		Class.forName(dbdriver);
		conn = DriverManager.getConnection(dburl, user, passwd);

		pstmt = conn.prepareStatement("select * from student where s_id=? and s_pwd=?");
		pstmt.setString(1, s_id);
		pstmt.setString(2, userPassword);

		rs = pstmt.executeQuery();

		if (rs.next()) {
			pstmt2 = conn.prepareStatement("update student set s_pwd=? where s_id=?");
			pstmt2.setString(1, newPassword);
			pstmt2.setString(2, s_id);
			pstmt2.executeUpdate();
	%>
	<script>
      alert("비밀번호가 변경되었습니다. ");
      location.href="update.jsp";
    </script>
	<%
		} else {
	%>
	<script>
      alert("비밀번호가 틀렸습니다. ");
      location.href="update.jsp";
      </script>
	<%
		}
	} catch (SQLException ex) {
		String sMessage;
		if (ex.getErrorCode() == 20002)
			sMessage = "암호는 4자리 이상이어야 합니다.";
		else if (ex.getErrorCode() == 20003)
			sMessage = "암호에 공란은 입력되지 않습니다.";
		else
			sMessage = "잠시 후 다시 시도하십시오.";

	%>
	<script>
		alert("<%=sMessage%>");	history.back();
	</script>
	<%
		} finally {
		if (rs != null)
			try { rs.close(); } catch (SQLException ex) {}
		if (pstmt != null)
			try { pstmt.close(); } catch (SQLException ex) {}
		if (pstmt2 != null)
			try { pstmt2.close(); } catch (SQLException ex) {}
		if (conn != null)
			try { conn.close(); } catch (SQLException ex) {}
	}
	%>
</body>
</html>