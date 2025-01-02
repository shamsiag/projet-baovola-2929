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
    <title>Produits Favoris - Boutique de Fleurs</title>
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
                <li><a href="userFavorites.jsp">Mes Favoris</a></li>
                <li><a href="userCart.jsp">Mon Panier</a></li>
                <li><a href="logout.jsp">Se déconnecter</a></li>
            </ul>
        </nav>
    </header>

    <!-- Section des favoris -->
    <main class="container">
        <h1>Mes produits favoris</h1>
        <div class="favorites-container">
            <%
                java.sql.Connection conn = null;
                java.sql.PreparedStatement stmt = null;
                java.sql.ResultSet rs = null;

                // ID de l'utilisateur connecté (à récupérer depuis la session)
                int userId = (int) session.getAttribute("userId");

                try {
                    // Connexion à la base de données
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = java.sql.DriverManager.getConnection("jdbc:mysql://localhost:3306/PROJETBAOVOLA2929", "username", "password");

                    // Requête pour récupérer les produits favoris de l'utilisateur
                    String query = "SELECT P.ID, P.NAME, P.DESCRIPTION, P.PICTURE " +
                                   "FROM USER_FAVORITE UF " +
                                   "JOIN PRODUCT P ON UF.IDPRODUCT = P.ID " +
                                   "WHERE UF.IDUSER = ? AND UF.REMOVEDON IS NULL";

                    stmt = conn.prepareStatement(query);
                    stmt.setInt(1, userId);
                    rs = stmt.executeQuery();

                    // Affichage des produits
                    while (rs.next()) {
                        int productId = rs.getInt("ID");
                        String productName = rs.getString("NAME");
                        String productDescription = rs.getString("DESCRIPTION");
                        String productImage = rs.getString("PICTURE");
            %>
                        <div class="favorite-product">
                            <img src="<%= productImage != null ? productImage : "default-product.jpg" %>" alt="<%= productName %>">
                            <h3><%= productName %></h3>
                            <p><%= productDescription %></p>
                            <a href="productDetails.jsp?id=<%= productId %>" class="btn">Voir le produit</a>
                        </div>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<p>Une erreur est survenue lors du chargement des produits favoris.</p>");
                } finally {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                }
            %>
        </div>
    </main>
</body>
</html>
