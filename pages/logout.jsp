<%@ page language="java" import="assets.UserDAO" %>
<%@ page session="true" %>

<%
    UserDAO.logout(session);
    response.sendRedirect("login.jsp");
%>
