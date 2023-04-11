<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>

<html>
<head><title>수강신청 입력</title></head>
<body>
   <%@ include file="top.jsp"%>
   <% if (session_id == null)   response.sendRedirect("login.jsp"); %>
   
   <table width="75%" align="center" border>
      <br><tr>
         <th>과목번호</th><th>분반</th><th>과목명</th><th>학점</th><th>요일</th>
         <th>시간</th><th>장소</th><th>담당교수</th><th>최대수강인원</th><th>여석</th><th>수강신청</th>
      </tr>
      <%
      Connection myConn = null;
      PreparedStatement pstmt = null;
      CallableStatement cstmt1 = null;
      CallableStatement cstmt2 = null;
      ResultSet myResultSet = null;
      String dbdriver = "oracle.jdbc.driver.OracleDriver";
      String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
      String user = "db1715333";
      String password = "ss2";
      
      PreparedStatement pstmt2 = null;
      ResultSet rs=null;
      String mysql=null;
      
      int year=0; int semester=0;
      
      try {
         Class.forName(dbdriver);
         myConn = DriverManager.getConnection(dburl, user, password);
         
         cstmt1 = myConn.prepareCall("{? = call Date2EnrollYear(SYSDATE)}");
         cstmt2 = myConn.prepareCall("{? = call Date2EnrollSemester(SYSDATE)}");
         cstmt1.registerOutParameter(1,java.sql.Types.INTEGER);
         cstmt2.registerOutParameter(1,java.sql.Types.INTEGER);
         cstmt1.execute();
         cstmt2.execute();
         
         year = cstmt1.getInt(1);
         semester = cstmt2.getInt(1);
         
         String SQL= "select c.c_id, t.c_class, c.c_name, c.c_credit, t.t_day, t.t_time1, t.t_time2, t.t_location, t.p_name, t.t_max from course c, teach t where t_year=? and t_semester=? and t.c_id =c.c_id and (t.c_id, t.c_class) not in (select c_id, c_class from enroll where s_id=?)";
         
         pstmt =myConn.prepareStatement (SQL);
         pstmt.setInt(1, year);
         pstmt.setInt(2, semester);
         pstmt.setString(3, session_id);
         
         myResultSet = pstmt.executeQuery();

         if (myResultSet != null) {
            while (myResultSet.next()) {
               int st_num = 0;
               String c_id = myResultSet.getString("c_id");
               int c_class = myResultSet.getInt("c_class");
               String c_name = myResultSet.getString("c_name");
               int c_credit = myResultSet.getInt("c_credit");
               String t_day = myResultSet.getString("t_day");
               String time1 = myResultSet.getString("t_time1");
               String time2 = myResultSet.getString("t_time2");
               String t_location = myResultSet.getString("t_location");
               String p_name = myResultSet.getString("p_name");
               int t_max = myResultSet.getInt("t_max");
               
               //여석 가져오기
               mysql ="select st_num from enroll_student e, teach t where e.c_id = ? and e.c_class = ? and e.e_year=? and e.e_semester = ?";
               pstmt2 = myConn.prepareStatement(mysql);
               pstmt2.setString(1, c_id);
               pstmt2.setInt(2, c_class);
               pstmt2.setInt(3, year);
               pstmt2.setInt(4, semester);
            
               rs = pstmt2.executeQuery();
               
               if(rs.next() != false){
                  st_num = rs.getInt("st_num");
               }
           %>
         <tr>
            <td align="center"><%=c_id%></td>
            <td align="center"><%=c_class%></td>
            <td align="center"><%=c_name%></td>
            <td align="center"><%=c_credit%></td>
            <td align="center"><%=t_day%></td>
            <td align="center"><%=time1+"~"+time2%></td>
            <td align="center"><%=t_location%></td>
            <td align="center"><%=p_name%></td>
            <td align="center"><%=t_max%></td>
            <td align="center"><%=t_max-st_num%></td>
            <td align="center"><a href="insert_verify.jsp?c_id=<%=c_id%>&c_class=<%=c_class%>">신청</a></td>
         </tr>
         <%
            }
         }
      } catch (SQLException ex) {
         System.err.println("SQLException: " + ex.getMessage());
      }
      
      finally {
	      if (myResultSet != null) myResultSet.close();
	      if (pstmt != null) pstmt.close();
	      if (cstmt1 != null) cstmt1.close();
	      if (cstmt2 != null) cstmt2.close();
	      if (rs != null) rs.close();
	      if (pstmt2 != null) pstmt2.close();
	      if (myConn != null) myConn.close();
      }

      %>
   </table>
</body>
</html>