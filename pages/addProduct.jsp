<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="style.css">
    <title>Ajouter un produit - Boutique de Fleurs</title>
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
                <li><a href="productList.jsp">Produits</a></li>
                <li><a href="addProduct.jsp">Ajouter un produit</a></li>
                <li><a href="logout.jsp">Se déconnecter</a></li>
            </ul>
        </nav>
    </header>

    <!-- Formulaire d'ajout de produit -->
    <main class="container">
        <h1>Ajouter un produit</h1>
        <form action="addProductAction" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="productName">Nom du produit :</label>
                <input type="text" id="productName" name="productName" required>
            </div>
            <div class="form-group">
                <label for="productDescription">Description :</label>
                <textarea id="productDescription" name="productDescription" rows="4" required></textarea>
            </div>
            <div class="form-group">
                <label for="productImage">Image du produit :</label>
                <input type="file" id="productImage" name="productImage" accept="image/*">
            </div>
            <div class="form-group">
                <label for="productCategory">Catégorie :</label>
                <select id="productCategory" name="productCategory" required>
                    <!-- Catégories à générer dynamiquement depuis la base de données -->
                    <%
                        // Exemple de connexion pour récupérer les catégories
                        java.sql.Connection conn = null;
                        java.sql.Statement stmt = null;
                        java.sql.ResultSet rs = null;

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = java.sql.DriverManager.getConnection("jdbc:mysql://localhost:3306/PROJETBAOVOLA2929", "username", "password");
                            stmt = conn.createStatement();
                            rs = stmt.executeQuery("SELECT ID, NAME FROM CATEGORY");

                            while (rs.next()) {
                                int categoryId = rs.getInt("ID");
                                String categoryName = rs.getString("NAME");
                    %>
                                <option value="<%= categoryId %>"><%= categoryName %></option>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) rs.close();
                            if (stmt != null) stmt.close();
                            if (conn != null) conn.close();
                        }
                    %>
                </select>
            </div>
            <div class="form-group">
                <button type="submit">Ajouter le produit</button>
            </div>
        </form>
    </main>
</body>
</html>
