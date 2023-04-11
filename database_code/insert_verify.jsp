<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>

<html><head><title> 수강신청 입력 </title></head>
<body>
<%	
	String s_id = (String)session.getAttribute("session_id");
	String c_id = request.getParameter("c_id");
	int c_class = Integer.parseInt(request.getParameter("c_class"));

%>
<%		
	Connection myConn = null;    String	result = null;	
	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
	String user = "db1715333";
	String password = "ss2";

	try {
		Class.forName(dbdriver);
  	        myConn =  DriverManager.getConnection (dburl, user, password);
  	        myConn.setAutoCommit(false);

    } catch(SQLException ex) {
	     System.err.println("SQLException: " + ex.getMessage());
    }
    CallableStatement cstmt = myConn.prepareCall("{ call InsertEnroll(?, ?, ?, ?) }");	
	cstmt.setString(1, s_id);
	cstmt.setString(2, c_id);
	cstmt.setInt(3, c_class);
	cstmt.registerOutParameter(4, java.sql.Types.VARCHAR);
	try  {
		cstmt.execute();
		result = cstmt.getString(4);
		System.out.println(" "+s_id+" "+c_id+" "+c_class); //콘솔 창 출력
%>
<script>	
	alert("<%= result %>");
	location.href="insert.jsp";
</script>
<%		
	} catch(SQLException ex) {		
		 System.err.println("SQLException: " + ex.getMessage());
	}  
	finally {
	    if (cstmt != null) 
	    	try { myConn.commit(); cstmt.close();  myConn.close(); }
        catch(SQLException ex) { }
     }
%>

</body></html>