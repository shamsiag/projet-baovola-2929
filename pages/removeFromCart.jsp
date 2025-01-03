<%@ page import="assets.UserCartDAO" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page language="java" %>

<%
    String cartItemIdParam = request.getParameter("cartItemId");
    if (cartItemIdParam != null) {
        int cartItemId = Integer.parseInt(cartItemIdParam);

        UserCartDAO userCartDAO = new UserCartDAO();
        boolean success = userCartDAO.removeProductFromCart(cartItemId);

        if (success) {
            response.sendRedirect("userCart.jsp");
        } else {
            out.println("<p>Une erreur est survenue lors de la suppression de l'article.</p>");
        }
    } else {
        response.sendRedirect("userCart.jsp");
    }
%>
