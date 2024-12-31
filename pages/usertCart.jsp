<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Panier - Boutique de Fleurs</title>
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
                <li><a href="userFavorites.jsp">Mes Favoris</a></li>
                <li><a href="userCart.jsp">Mon Panier</a></li>
                <li><a href="logout.jsp">Se déconnecter</a></li>
            </ul>
        </nav>
    </header>

    <!-- Section du panier -->
    <main class="container">
        <h1>Mon Panier</h1>
        <div class="cart-container">
            <%
                java.sql.Connection conn = null;
                java.sql.PreparedStatement stmt = null;
                java.sql.ResultSet rs = null;

                // ID de l'utilisateur connecté (à récupérer depuis la session)
                int userId = (int) session.getAttribute("userId");
                double totalPrice = 0.0;

                try {
                    // Connexion à la base de données
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = java.sql.DriverManager.getConnection("jdbc:mysql://localhost:3306/PROJETBAOVOLA2929", "username", "password");

                    // Requête pour récupérer les produits du panier de l'utilisateur
                    String query = "SELECT C.ID AS CART_ID, P.ID AS PRODUCT_ID, P.NAME, P.DESCRIPTION, P.PICTURE, C.QUANTITY, P.PRICE " +
                                   "FROM USER_CART C " +
                                   "JOIN PRODUCT P ON C.IDPRODUCT = P.ID " +
                                   "WHERE C.IDUSER = ? AND C.DELETEDAT IS NULL";

                    stmt = conn.prepareStatement(query);
                    stmt.setInt(1, userId);
                    rs = stmt.executeQuery();

                    // Affichage des produits
                    while (rs.next()) {
                        int cartId = rs.getInt("CART_ID");
                        String productName = rs.getString("NAME");
                        String productDescription = rs.getString("DESCRIPTION");
                        String productImage = rs.getString("PICTURE");
                        int quantity = rs.getInt("QUANTITY");
                        double price = rs.getDouble("PRICE");
                        double totalProductPrice = quantity * price;
                        totalPrice += totalProductPrice;
            %>
                        <div class="cart-item">
                            <img src="<%= productImage != null ? productImage : "default-product.jpg" %>" alt="<%= productName %>">
                            <h3><%= productName %></h3>
                            <p><%= productDescription %></p>
                            <p>Prix unitaire : <%= price %>€</p>
                            <p>Quantité : <%= quantity %></p>
                            <p>Prix total : <%= totalProductPrice %>€</p>
                            <form action="removeFromCart" method="post">
                                <input type="hidden" name="cartId" value="<%= cartId %>">
                                <button type="submit" class="btn">Retirer du panier</button>
                            </form>
                        </div>
            <%
                    }
            %>
        </div>
        <div class="cart-summary">
            <h2>Total : <%= totalPrice %>€</h2>
            <form action="checkout" method="post">
                <button type="submit" class="btn">Passer à la caisse</button>
            </form>
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
    </main>
</body>
</html>
