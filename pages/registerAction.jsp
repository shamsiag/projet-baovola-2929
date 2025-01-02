<%@ page import="assets.UserDAO" %>
<%@ page session="false" %>
<%
    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("fullname");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        message = UserDAO.registerUser(name, username, password);

        if (message.equals("Inscription réussie. Vous pouvez vous connecter.")) {
            response.sendRedirect("index.jsp");
            return; 
        }
    }
%>