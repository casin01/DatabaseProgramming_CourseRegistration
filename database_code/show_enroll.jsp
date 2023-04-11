<%@ page language="java" contentType="text/html; charset=EUC-KR"
   pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@ include file="select.jsp"%>

<html>
<head>
<meta charset="EUC-KR">
<title>수강 조회</title></head>
<body>

   <table width="75%" align="center" border>
      <th>과목 번호</th><th>과목 이름</th>
      <th>분반</th><th>요일</th><th>시간</th>
      <th>장소</th><th>교수님</th><th>학점</th>
      <tbody id="enroll_table">
   <%
      String selec_year= (String) request.getParameter("year");
      String selec_semester= (String) request.getParameter("semester");
      
      if (selec_year == null ) selec_year="2020";
      
      if (selec_semester ==null ) selec_semester="1";
      
      int nowyear=0;
      int nowsem=0;
   %>

   <%
      if (session_id == null)   response.sendRedirect("login.jsp");

      String dbdriver = "oracle.jdbc.driver.OracleDriver";
      String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
      String user = "db1715333";
      String passwd = "ss2";

      Connection Conn = null;
      Statement stmt = null;
      Statement stmt2 = null;
      ResultSet rs = null;
      ResultSet rs2 = null;
      CallableStatement cstmt=null;   

      try {
         Class.forName(dbdriver);
         Conn = DriverManager.getConnection(dburl, user, passwd);
         stmt = Conn.createStatement();

         String SQL = "select c_id, c_class from enroll where s_id='" + session_id + "' and e_year='" + selec_year
         + "' and e_semester='" + selec_semester + "'";

         rs = stmt.executeQuery(SQL);

         while (rs.next() != false) {

            String c_id = "", c_name = "", t_day = "", t_time1 = "", t_time2 = "";
            String t_location = "", p_name = "";
            int c_credit, c_class;

            c_id = rs.getString("c_id");
            c_class = rs.getInt("c_class");

            stmt2 = Conn.createStatement();
            String SQL2 = "select c.c_id c_id,c.c_name c_name, t.c_class c_class,t.t_day t_day,t.t_time1 t_time1, t.t_time2 t_time2,t.t_location t_location,c.c_credit c_credit,t.p_name p_name from course c,teach t where t.t_year='"
            + selec_year + "' and t.t_semester='" + selec_semester + "' and c.c_id = '" + c_id + "' and c.c_id = t.c_id and t.c_class ='"+ c_class+"'"; 

            rs2 = stmt2.executeQuery(SQL2);

            while (rs2.next() != false) {
               c_id = rs2.getString("c_id");
               c_name = rs2.getString("c_name");
               c_class = rs2.getInt("c_class");
               t_day = rs2.getString("t_day");
               t_time1 = rs2.getString("t_time1");
               t_time2 = rs2.getString("t_time2");
               t_location = rs2.getString("t_location");
               c_credit = rs2.getInt("c_credit");
               p_name = rs2.getString("p_name");
            %>
      
            <tr>
               <td align="center"><%=c_id%></td>
               <td align="center"><%=c_name%></td>
               <td align="center"><%=c_class%></td>
               <td align="center"><%=t_day%></td>
               <td align="center"><%=t_time1%> - <%=t_time2%></td>
               <td align="center"><%=t_location%></td>
               <td align="center"><%=p_name%></td>
               <td align="center"><%=c_credit%></td>
            </tr>
            </tbody>
            
            <%
            }
      }
         
         nowyear= Integer.parseInt(selec_year);
         nowsem = Integer.parseInt(selec_semester);
         
         int nclass=0, nunit=0;
         cstmt = Conn.prepareCall("{ call SumTable(?, ?, ?, ?, ?) }");
         cstmt.setString(1, session_id);
         cstmt.setInt(2, nowyear);
         cstmt.setInt(3, nowsem);
         cstmt.registerOutParameter(4, java.sql.Types.INTEGER);
         cstmt.registerOutParameter(5, java.sql.Types.INTEGER);

         cstmt.execute();
         
         nclass=cstmt.getInt(4);
         nunit=cstmt.getInt(5);

         %>
         </table>
         <br>
         
         <table width="30%" align="center" border>
            <tr>
            <td align="center">총 신청과목</td>
            <td align="center"><%=nclass%></td>
            <td align="center">총 신청 학점</td>
            <td align="center"><%=nunit%></td>
            </tr>
         </table>

        <%
            } catch (ClassNotFoundException e) {
         System.out.println("jdbc driver 오류");
      } catch (SQLException e) {
         System.out.println("오라클 오류");
         System.err.println("SQLException: " + e.getMessage());
      } finally {
          if (rs2 != null) try { rs2.close(); } catch(SQLException ex) {}
            if (rs != null) try { rs.close(); } catch(SQLException ex) {}
            if (stmt2 != null) try { stmt2.close(); } catch(SQLException ex) {}
            if (stmt != null) try { stmt.close(); } catch(SQLException ex) {}
            if (cstmt != null) try { cstmt.close(); } catch(SQLException ex) {}
            if (Conn != null) try { Conn.close(); } catch(SQLException ex) {}
      }
      %>
   
</body>
</html>