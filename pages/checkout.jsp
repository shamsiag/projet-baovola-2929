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
    <link rel="stylesheet" type="text/css" href="style.css">
    <title>Finaliser la commande - Boutique de Fleurs</title>
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
                <li><a href="logout.jsp">Se déconnecter</a></li>
            </ul>
        </nav>
    </header>

    <!-- Section Checkout -->
    <main class="container">
        <h1>Finaliser la commande</h1>
        
        <!-- Récapitulatif des articles -->
        <section>
            <h2>Récapitulatif de votre panier</h2>
            <div class="cart-summary">
                <%
                    java.sql.Connection conn = null;
                    java.sql.PreparedStatement stmt = null;
                    java.sql.ResultSet rs = null;
                    double totalPrice = 0.0;
                    int userId = (int) session.getAttribute("userId");

                    try {
                        // Connexion à la base de données
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = java.sql.DriverManager.getConnection("jdbc:mysql://localhost:3306/PROJETBAOVOLA2929", "username", "password");

                        // Requête pour récupérer les produits dans le panier
                        String query = "SELECT P.NAME, C.QUANTITY, P.PRICE, (C.QUANTITY * P.PRICE) AS TOTAL " +
                                       "FROM USER_CART C " +
                                       "JOIN PRODUCT P ON C.IDPRODUCT = P.ID " +
                                       "WHERE C.IDUSER = ? AND C.DELETEDAT IS NULL";

                        stmt = conn.prepareStatement(query);
                        stmt.setInt(1, userId);
                        rs = stmt.executeQuery();

                        while (rs.next()) {
                            String productName = rs.getString("NAME");
                            int quantity = rs.getInt("QUANTITY");
                            double price = rs.getDouble("PRICE");
                            double total = rs.getDouble("TOTAL");
                            totalPrice += total;
                %>
                            <div class="cart-item">
                                <p><strong><%= productName %></strong> (x<%= quantity %>) - Prix unitaire : <%= price %>€ - Total : <%= total %>€</p>
                            </div>
                <%
                        }
                %>
                <div class="cart-total">
                    <h3>Total à payer : <%= totalPrice %>€</h3>
                </div>
                <%
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<p>Une erreur est survenue lors du chargement du panier.</p>");
                    } finally {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    }
                %>
            </div>
        </section>

        <!-- Formulaire de Checkout -->
        <section>
            <h2>Informations de livraison et paiement</h2>
            <form action="placeOrder" method="post">
                <!-- Adresse de livraison -->
                <div class="form-group">
                    <label for="address">Adresse de livraison :</label>
                    <textarea id="address" name="address" required></textarea>
                </div>

                <!-- Mode de paiement -->
                <div class="form-group">
                    <label for="paymentMethod">Mode de paiement :</label>
                    <select id="paymentMethod" name="paymentMethod" required>
                        <option value="credit_card">Carte de crédit</option>
                        <option value="paypal">PayPal</option>
                        <option value="cash_on_delivery">Paiement à la livraison</option>
                    </select>
                </div>

                <!-- Bouton de validation -->
                <div class="form-actions">
                    <button type="submit" class="btn">Finaliser la commande</button>
                </div>
            </form>
        </section>
    </main>
</body>
</html>
