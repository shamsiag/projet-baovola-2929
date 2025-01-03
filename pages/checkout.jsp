<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="assets.*" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    // Initialisation
    String message = "";
    boolean checkoutSuccess = false;

    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp"); // Redirection vers login si non connecté
        return;
    }

    int userId = (int) session.getAttribute("userId");

    // Récupérer les articles du panier
    UserCartDAO cartDAO = new UserCartDAO();
    List<UserCart> UserCarts = cartDAO.getCartItems(userId);

    if (UserCarts == null || UserCarts.isEmpty()) {
        message = "Votre panier est vide.";
    } else if (request.getMethod().equalsIgnoreCase("POST")) {
        // Effectuer le checkout
        OrderDAO orderDAO = new OrderDAO();
        checkoutSuccess = orderDAO.processCheckout(userId, UserCarts);

        if (checkoutSuccess) {
            message = "Votre commande a été validée avec succès.";
        } else {
            message = "Une erreur est survenue lors du traitement de votre commande.";
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="style.css">
    <title>Checkout - Boutique de Fleurs</title>
</head>
<body>
    <header>
        <nav class="navbar">
            <div class="logo">
                <a href="index.jsp">Boutique de Fleurs</a>
            </div>
            <ul class="nav-links">
                <li><a href="index.jsp">Accueil</a></li>
                <li><a href="viewCart.jsp">Mon Panier</a></li>
                <li><a href="logout.jsp">Se déconnecter</a></li>
            </ul>
        </nav>
    </header>

    <main class="container">
        <h1>Confirmation de la commande</h1>

        <% if (!message.isEmpty()) { %>
            <p class="<%= checkoutSuccess ? "success" : "error" %>"><%= message %></p>
        <% } %>

        <% if (UserCarts != null && !UserCarts.isEmpty() && !checkoutSuccess) { %>
            <form action="checkout.jsp" method="post">
                <div class="cart-summary">
                    <h2>Résumé de votre panier :</h2>
                    <ul>
                        <% double total = 0.0; %>
                        <% for (UserCart item : UserCarts) { %>
                            <li>
                                <strong><%= item.getProductName() %></strong> - 
                                Quantité : <%= item.getQuantity() %> - 
                                Prix : <%= String.format("%.2f", item.getPrice()) %> €
                                <% total += item.getPrice() * item.getQuantity(); %>
                            </li>
                        <% } %>
                    </ul>
                    <h3>Total : <%= String.format("%.2f", total) %> €</h3>
                </div>
                <div class="form-group">
                    <button type="submit">Confirmer la commande</button>
                </div>
            </form>
        <% } %>
    </main>
</body>
</html>
