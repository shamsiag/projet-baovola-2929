<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, assets.*" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    OrderGlobalDAO orderGlobalDAO = new OrderGlobalDAO();
    ProductDAO productDAO = new ProductDAO();
    StockMovementDAO stock = new StockMovementDAO();
    List<OrderGlobal> orders = null;
    List<Product> products = null;

    try {
        orders = orderGlobalDAO.getAllOrdersWithStatus();
        products = productDAO.getAllProducts();
    } catch (Exception e) {
        e.printStackTrace();
        orders = null;
        products = null;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Commandes - Boutique de Fleurs</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        
        .container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .orders-history, .stock-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }
        .order-card, .stock-card {
            flex: 1 1 calc(30% - 20px);
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }
        .order-card h3, .stock-card h3 {
            margin: 0 0 10px;
        }
        .order-card p, .stock-card p {
            margin: 5px 0;
            color: #555;
        }
        .order-card a {
            display: inline-block;
            margin-top: 10px;
            text-decoration: none;
        }
        .order-card a:hover {
            text-decoration: underline;
        }
        .stock-card img {
            max-width: 100%;
            height: auto;
            border-radius: 5px;
        }
        h2 {
            border-bottom: 2px solid #ddd;
            padding-bottom: 5px;
            color: #333;
        }
        h1 {
            text-align: center;
            color: #222;
        }
    </style>
</head>
<body>
    <header>
        <nav class="navbar">
            <div class="logo">
                <a href="index.jsp">Boutique de Fleurs</a>
            </div>
            <ul class="nav-links">
                <li><a href="index.jsp">Accueil</a></li>
                <li><a href="orderManagement.jsp">Gestion des Commandes</a></li>
                <li><a href="logout.jsp">Se déconnecter</a></li>
            </ul>
        </nav>
    </header>

    <main class="container">
        <h1>Gestion des Commandes</h1>
        
        <section>
            <h2>Historique des Commandes</h2>
            <div class="orders-history">
                <%
                    if (orders != null && !orders.isEmpty()) {
                        for (OrderGlobal order : orders) {
                %>
                            <div class="order-card">
                                <h3>Commande n°<%= order.getId() %></h3>
                                <p><strong>Date :</strong> <%= order.getOrderLocalDateTime() %></p>
                                <p><strong>Valeur totale :</strong> <%= order.getTotalValue() %> €</p>
                                <p><strong>Statut :</strong> 
                                    <%= order.getStatus() == 1 ? "En attente" :
                                        order.getStatus() == 2 ? "Confirmée" :
                                        order.getStatus() == 3 ? "Expédiée" :
                                        order.getStatus() == 4 ? "Livrée" : "Inconnu" %>
                                </p>
                                <a href="orderDetails.jsp?orderId=<%= order.getId() %>">Voir détails</a>
                            </div>
                <%
                        }
                    } else {
                        out.println("<p>Aucune commande trouvée.</p>");
                    }
                %>
            </div>
        </section>

        <section>
            <h2>Stock Disponible</h2>
            <div class="stock-container">
                <%
                    if (products != null && !products.isEmpty()) {
                        for (Product product : products) {
                %>
                            <div class="stock-card">
                                <img src="<%= product.getPicture() != null ? product.getPicture() : "default-product.jpg" %>" alt="<%= product.getName() %>">
                                <h3><%= product.getName() %></h3>
                                <p><%= product.getDescription() %></p>
                                <p><strong>Quantité disponible :</strong> <%=stock.getAvailableStock(product.getId()) %></p>
                            </div>
                <%
                        }
                    } else {
                        out.println("<p>Aucun produit trouvé dans le stock.</p>");
                    }
                %>
            </div>
        </section>
    </main>
</body>
</html>

