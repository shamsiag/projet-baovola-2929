<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="style.css">
    <title>Historique des Ventes - Boutique de Fleurs</title>
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
                <li><a href="userCart.jsp">Mon Panier</a></li>
                <li><a href="orderHistory.jsp">Historique des Ventes</a></li>
                <li><a href="logout.jsp">Se déconnecter</a></li>
            </ul>
        </nav>
    </header>

    <!-- Section Historique des Commandes -->
    <main class="container">
        <h1>Historique des Ventes</h1>
        
        <!-- Liste des commandes -->
        <section>
            <h2>Mes commandes passées</h2>
            <div class="order-history">
                <%
                    java.sql.Connection conn = null;
                    java.sql.PreparedStatement stmt = null;
                    java.sql.ResultSet rs = null;
                    int userId = (int) session.getAttribute("userId");

                    try {
                        // Connexion à la base de données
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = java.sql.DriverManager.getConnection("jdbc:mysql://localhost:3306/PROJETBAOVOLA2929", "username", "password");

                        // Requête pour récupérer les commandes de l'utilisateur
                        String query = "SELECT OG.ID, OG.ORDERDATE, OG.TOTALVALUE, S.NAME AS STATUS_NAME " +
                                       "FROM ORDER_GLOBAL OG " +
                                       "JOIN STATUS S ON OG.STATUS = S.ID " +
                                       "WHERE OG.IDUSER = ? " +
                                       "ORDER BY OG.ORDERDATE DESC";

                        stmt = conn.prepareStatement(query);
                        stmt.setInt(1, userId);
                        rs = stmt.executeQuery();

                        while (rs.next()) {
                            int orderId = rs.getInt("ID");
                            String orderDate = rs.getString("ORDERDATE");
                            double totalValue = rs.getDouble("TOTALVALUE");
                            String statusName = rs.getString("STATUS_NAME");
                %>
                            <div class="order-card">
                                <h3>Commande n°<%= orderId %></h3>
                                <p>Date : <%= orderDate %></p>
                                <p>Valeur totale : <%= totalValue %>€</p>
                                <p>Statut : <%= statusName %></p>
                                
                                <!-- Afficher les détails des produits dans cette commande -->
                                <div class="order-details">
                                    <h4>Détails des produits</h4>
                                    <%
                                        // Requête pour récupérer les produits associés à cette commande
                                        String productQuery = "SELECT P.NAME, C.QUANTITY, P.PRICE, (C.QUANTITY * P.PRICE) AS TOTAL " +
                                                              "FROM USER_CART C " +
                                                              "JOIN PRODUCT P ON C.IDPRODUCT = P.ID " +
                                                              "WHERE C.IDUSER = ? AND C.BOUGHTON IS NOT NULL AND C.IDORDER = ?";
                                        PreparedStatement productStmt = conn.prepareStatement(productQuery);
                                        productStmt.setInt(1, userId);
                                        productStmt.setInt(2, orderId);
                                        ResultSet productRs = productStmt.executeQuery();

                                        while (productRs.next()) {
                                            String productName = productRs.getString("NAME");
                                            int quantity = productRs.getInt("QUANTITY");
                                            double price = productRs.getDouble("PRICE");
                                            double productTotal = productRs.getDouble("TOTAL");
                                    %>
                                        <div class="order-item">
                                            <p><strong><%= productName %></strong> (x<%= quantity %>) - Prix unitaire : <%= price %>€ - Total produit : <%= productTotal %>€</p>
                                        </div>
                                    <%
                                        }
                                    %>
                                </div>
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
    </main>
</body>
</html>
