<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Stocks - Boutique de Fleurs</title>
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
                <li><a href="stockMovement.jsp">Gestion des Stocks</a></li>
                <li><a href="logout.jsp">Se déconnecter</a></li>
            </ul>
        </nav>
    </header>

    <!-- Formulaire de gestion des mouvements de stock -->
    <main class="container">
        <h1>Ajouter un nouveau mouvement de stock</h1>
        
        <!-- Formulaire d'insertion -->
        <section>
            <form action="insertStockMovement" method="post">
                <!-- Sélection du produit -->
                <div class="form-group">
                    <label for="product">Produit :</label>
                    <select id="product" name="productId" required>
                        <%
                            java.sql.Connection conn = null;
                            java.sql.PreparedStatement stmt = null;
                            java.sql.ResultSet rs = null;

                            try {
                                // Connexion à la base de données
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                conn = java.sql.DriverManager.getConnection("jdbc:mysql://localhost:3306/PROJETBAOVOLA2929", "username", "password");

                                // Récupérer la liste des produits
                                String query = "SELECT ID, NAME FROM PRODUCT";
                                stmt = conn.prepareStatement(query);
                                rs = stmt.executeQuery();

                                while (rs.next()) {
                                    int productId = rs.getInt("ID");
                                    String productName = rs.getString("NAME");
                    %>
                                    <option value="<%= productId %>"><%= productName %></option>
                    <%
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                out.println("<p>Une erreur est survenue lors du chargement des produits.</p>");
                            } finally {
                                if (rs != null) rs.close();
                                if (stmt != null) stmt.close();
                                if (conn != null) conn.close();
                            }
                    %>
                    </select>
                </div>

                <!-- Type de mouvement (ajout ou retrait) -->
                <div class="form-group">
                    <label for="movementType">Type de mouvement :</label>
                    <select id="movementType" name="movementType" required>
                        <option value="ajout">Ajout de stock</option>
                        <option value="retrait">Retrait de stock</option>
                    </select>
                </div>

                <!-- Quantité -->
                <div class="form-group">
                    <label for="quantity">Quantité :</label>
                    <input type="number" id="quantity" name="quantity" required min="1" />
                </div>

                <!-- Date du mouvement -->
                <div class="form-group">
                    <label for="movementDate">Date du mouvement :</label>
                    <input type="date" id="movementDate" name="movementDate" required />
                </div>

                <!-- Bouton de soumission -->
                <div class="form-actions">
                    <button type="submit" class="btn">Enregistrer le mouvement</button>
                </div>
            </form>
        </section>
    </main>
</body>
</html>
