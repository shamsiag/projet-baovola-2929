<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Produits - Boutique de Fleurs</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <!-- Barre de navigation -->
    <header>
        <nav class="navbar">
            <div class="logo">
                <a href="index.jsp">Boutique de Fleurs</a>
            </div>
            <ul class="nav-links">
                <li><a href="index.jsp">Accueil</a></li>
                <li><a href="productManagement.jsp">Gestion des Produits</a></li>
                <li><a href="addProduct.jsp">Ajouter un produit</a></li>
                <li><a href="logout.jsp">Se déconnecter</a></li>
            </ul>
        </nav>
    </header>

    <!-- Section Gestion des Produits -->
    <main class="container">
        <h1>Gestion des Produits</h1>
        
        <!-- Section Historique des Ventes -->
        <section>
            <h2>Historique des Ventes</h2>
            <div class="sales-history">
                <%
                    java.sql.Connection conn = null;
                    java.sql.PreparedStatement stmt = null;
                    java.sql.ResultSet rs = null;

                    try {
                        // Connexion à la base de données
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = java.sql.DriverManager.getConnection("jdbc:mysql://localhost:3306/PROJETBAOVOLA2929", "username", "password");

                        // Requête pour l'historique des ventes
                        String query = "SELECT OG.ID, OG.ORDERDATE, OG.TOTALVALUE, S.NAME AS STATUS_NAME " +
                                       "FROM ORDER_GLOBAL OG " +
                                       "JOIN STATUS S ON OG.STATUS = S.ID " +
                                       "ORDER BY OG.ORDERDATE DESC";

                        stmt = conn.prepareStatement(query);
                        rs = stmt.executeQuery();

                        while (rs.next()) {
                            int orderId = rs.getInt("ID");
                            String orderDate = rs.getString("ORDERDATE");
                            double totalValue = rs.getDouble("TOTALVALUE");
                            String statusName = rs.getString("STATUS_NAME");
                %>
                            <div class="sales-card">
                                <h3>Commande n°<%= orderId %></h3>
                                <p>Date : <%= orderDate %></p>
                                <p>Valeur totale : <%= totalValue %>€</p>
                                <p>Statut : <%= statusName %></p>
                            </div>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<p>Une erreur est survenue lors du chargement de l'historique des ventes.</p>");
                    } finally {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    }
                %>
            </div>
        </section>

        <!-- Section Stock Disponible -->
        <section>
            <h2>Stock Disponible</h2>
            <div class="stock-container">
                <%
                    try {
                        // Connexion à la base de données (réutilisée)
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = java.sql.DriverManager.getConnection("jdbc:mysql://localhost:3306/PROJETBAOVOLA2929", "username", "password");

                        // Requête pour afficher les produits et leur stock
                        String query = "SELECT P.ID, P.NAME, P.DESCRIPTION, P.PICTURE, P.QUANTITY " +
                                       "FROM PRODUCT P";

                        stmt = conn.prepareStatement(query);
                        rs = stmt.executeQuery();

                        while (rs.next()) {
                            int productId = rs.getInt("ID");
                            String productName = rs.getString("NAME");
                            String productDescription = rs.getString("DESCRIPTION");
                            String productImage = rs.getString("PICTURE");
                            int stockQuantity = rs.getInt("QUANTITY");
                %>
                            <div class="stock-card">
                                <img src="<%= productImage != null ? productImage : "default-product.jpg" %>" alt="<%= productName %>">
                                <h3><%= productName %></h3>
                                <p><%= productDescription %></p>
                                <p>Quantité disponible : <%= stockQuantity %></p>
                            </div>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<p>Une erreur est survenue lors du chargement du stock disponible.</p>");
                    } finally {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    }
                %>
            </div>
        </section>
    </main>
</body>
</html>
