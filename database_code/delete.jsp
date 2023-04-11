<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="UTF-8"%><%@ page import="java.sql.*"%>
    
<html><head><title>수강신청 삭제</title></head>
<body>
<%@ include file="top.jsp" %>
<%   if (session_id == null) response.sendRedirect("login.jsp"); %>

<table width="75%" align="center" border>
<br>
<tr><th>과목번호</th><th>과목명</th><th>분반</th>
<th>강의시간</th><th>강의실</th><th>담당교수</th><th>학점</th><th>수강취소</th></tr>

<% 
String dbdriver = "oracle.jdbc.driver.OracleDriver";
String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
String user = "db1715333";
String passwd = "ss2";

Connection conn = null;
Statement stmt = null;   Statement stmt2 = null;
CallableStatement cstmt = null;   CallableStatement cstmt2 = null;   CallableStatement cstmt3 = null;
ResultSet rs = null;   ResultSet rs2 = null; 

try {        
    Class.forName(dbdriver);
    conn=DriverManager.getConnection(dburl, user, passwd);
    stmt = conn.createStatement();
    
   String func = "{? = call Date2EnrollYear(SYSDATE)}";
   cstmt = conn.prepareCall(func);
   cstmt.registerOutParameter(1,java.sql.Types.INTEGER);
   cstmt.execute();
   int year = cstmt.getInt(1);

   String func2 = "{? = call Date2EnrollSemester(SYSDATE)}";
   cstmt2 = conn.prepareCall(func2);
   cstmt2.registerOutParameter(1,java.sql.Types.INTEGER);
   cstmt2.execute();
   int semester = cstmt2.getInt(1);
   
   session.setAttribute("yearNow", year);
   session.setAttribute("semesterNow", semester);
    
    String SQL="select c_id,c_class from enroll where s_id='" + session_id + "' and e_year=" + year + " and e_semester=" + semester;
    
    
    rs = stmt.executeQuery(SQL);
    
    if(rs.next()) {
       do {   
          String c_id = rs.getString("c_id");
          int c_class = rs.getInt("c_class");
       
             stmt2 = conn.createStatement(); 
             String SQL2 = "select c.c_name, t.t_day,t.t_time1, t.t_time2,t.t_location, c.c_credit,t.p_name from course c,teach t where t.t_year=" + year + " and t.t_semester=" + semester + " and c.c_id = '" + c_id + "' and c.c_id = t.c_id and t.c_class ="+ c_class; 
          rs2 = stmt2.executeQuery(SQL2); 
 
          rs2.next();
         String c_name = rs2.getString("c_name");  
         String t_day = rs2.getString("t_day");  
         String t_time1 = rs2.getString("t_time1"); 
         String t_time2 = rs2.getString("t_time2"); 
         String t_location = rs2.getString("t_location");
         int c_credit = rs2.getInt("c_credit"); 
         String p_name = rs2.getString("p_name");     
%>      
       
<tr>
<td align="center"><%=c_id%></td>
<td align="center"><%=c_name%></td>
<td align="center"><%=c_class%></td>
<td align="center"><%=t_day %> <%= t_time1%> - <%=t_time2%></td>
<td align="center"><%=t_location%></td>
<td align="center"><%=p_name%></td>
<td align="center"><%=c_credit%></td>
<td align="center"><a href="delete_verify.jsp?c_id=<%=c_id%>&c_class=<%=c_class%>">취소</a></td>
</tr>   
      
<% 
       } while(rs.next());
    } else {
       %>
       <tr>
       <td colspan=8><div align="center">신청한 강의가 없습니다. </div></td>
       </tr>
       <%
    }
    
    cstmt3 = conn.prepareCall("{call SumTable(?, ?, ?, ?, ?)}");
    cstmt3.setString(1, session_id);
    cstmt3.setInt(2, year);
    cstmt3.setInt(3, semester);
    cstmt3.registerOutParameter(4, java.sql.Types.INTEGER);
    cstmt3.registerOutParameter(5, java.sql.Types.INTEGER);

    cstmt3.execute();
    
    int classSum = cstmt3.getInt(4);
    int creditSum = cstmt3.getInt(5);

    %>
    </table>
    <br>
    
    <table width="30%" align="center" border>
       <tr>
       <td align="center">총 신청과목</td>
       <td align="center"><%=classSum%></td>
       <td align="center">총 신청 학점</td>
       <td align="center"><%=creditSum%></td>
       </tr>
    </table>

   <%
 } catch (ClassNotFoundException e) {
    System.out.println("jdbc driver 오류");
 } catch (SQLException e) {
      System.out.println("오라클 오류 -" + e.getErrorCode());
 } finally {
           if (rs2 != null) try { rs2.close(); } catch(SQLException ex) {}
           if (rs != null) try { rs.close(); } catch(SQLException ex) {}
           if (stmt2 != null) try { stmt2.close(); } catch(SQLException ex) {}
           if (stmt != null) try { stmt.close(); } catch(SQLException ex) {}
           if (cstmt3 != null) try { cstmt2.close(); } catch(SQLException ex) {}
           if (cstmt2 != null) try { cstmt2.close(); } catch(SQLException ex) {}
           if (cstmt != null) try { cstmt.close(); } catch(SQLException ex) {}
           if (conn != null) try { conn.close(); } catch(SQLException ex) {}
       }
%> 
</table>
</body>
</html>