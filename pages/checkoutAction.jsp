<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="assets.*" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp"); 
        return;
    }

    int userId = (int) session.getAttribute("userId");

    UserCartDAO cartDAO = new UserCartDAO();
    List<UserCart> UserCarts = cartDAO.getCartItems(userId);

    String message;
    boolean checkoutSuccess;

    if (UserCarts == null || UserCarts.isEmpty()) {
        message = "Votre panier est vide.";
        checkoutSuccess = false;
    } else {
        OrderDAO orderDAO = new OrderDAO();
        checkoutSuccess = orderDAO.processCheckout(userId, UserCarts);

        if (checkoutSuccess) {
            message = "Votre commande a été validée avec succès.";
        } else {
            message = "Une erreur est survenue lors du traitement de votre commande.";
        }
    }

    // Redirection vers checkout.jsp avec les messages
    request.setAttribute("message", message);
    request.setAttribute("checkoutSuccess", checkoutSuccess);
    request.getRequestDispatcher("checkout.jsp").forward(request, response);
%>
