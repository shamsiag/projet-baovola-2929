<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="assets.*" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    // Initialisation
    String message = (String) request.getAttribute("message");
    boolean checkoutSuccess = request.getAttribute("checkoutSuccess") != null
            && (boolean) request.getAttribute("checkoutSuccess");
    Product temp = new Product();
    ProductDAO productDAO = new ProductDAO();

    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp"); 
        return;
    }

    int userId = (int) session.getAttribute("userId");

    UserCartDAO cartDAO = new UserCartDAO();
    List<UserCart> UserCarts = cartDAO.getCartItems(userId);

    if (UserCarts == null || UserCarts.isEmpty()) {
        message = "Votre panier est vide.";
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

        <% if (message != null && !message.isEmpty()) { %>
        <p class="<%= checkoutSuccess ? "success" : "error" %>"><%= message %></p>
        <% } %>


        <% if (UserCarts != null && !UserCarts.isEmpty() && !checkoutSuccess) { %>
            <form action="checkoutAction.jsp" method="post">
                <div class="cart-summary">
                    <h2>Résumé de votre panier :</h2>
                    <ul>
                        <% double total = 0.0; %>
                        <% for (UserCart item : UserCarts) { 
                            temp=productDAO.getProductById(item.getProductId());
                            %>
                            <li>
                                <strong><%= temp.getName() %></strong> - 
                                Quantité : <%= item.getQuantity() %> - 
                                Prix : <%= String.format("%.2f", temp.getPrice()) %> €
                                <% total += temp.getPrice() * item.getQuantity(); %>
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
