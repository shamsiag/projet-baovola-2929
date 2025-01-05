<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.util.*, assets.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    int productId = Integer.parseInt(request.getParameter("productId"));
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    ProductDAO productService = new ProductDAO();
    Product product = productService.getProductById(productId);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails du produit - Boutique de Fleurs</title>
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
                <li><a href="about.jsp">À propos</a></li>
                <li><a href="contact.jsp">Contact</a></li>
                <li><a href="logout.jsp">Se déconnecter</a></li>
                <li><a href="register.jsp">S'inscrire</a></li>
            </ul>
        </nav>
    </header>

    <!-- Contenu principal -->
    <main class="container">
        <!-- Section des détails du produit -->
        <div class="product-details">
            <div class="product-image">
                <img src="<%= product.getPicture() %>" alt="Image du produit">
            </div>
            <div class="product-info">
                <h1><%= product.getName() %></h1>
                <p class="price"><%= product.getPrice() %></p>
                <p class="description">
                <%= product.getDescription() %>
                <p>Stock disponible : <%= StockMovementDAO.getAvailableStock(product.getId()) %></p>
                </p>
                <form action="addToCartAction.jsp" method="post">
                    <div class="form-group">
                        <label for="quantity">Quantité :</label>
                        <input type="number" id="quantity" name="quantity" value="1" min="1" required>
                    </div>
                    <input type="hidden" name="productId" value="<%= product.getId() %>"> <!-- ID du produit -->
                    <button type="submit" class="btn">Ajouter au panier</button>
                </form>
            </div>
        </div>


        <section class="related-products">
            <h2>Produits similaires</h2>
            <div class="cards-container">
                <div class="product-card">
                    <img src="path/to/similar-product1.jpg" alt="Produit similaire 1">
                    <h3>Tulipes Élégantes</h3>
                    <p>Prix : 25€</p>
                    <a href="productDetails.jsp?id=2" class="btn">Voir le produit</a>
                </div>
                <div class="product-card">
                    <img src="path/to/similar-product2.jpg" alt="Produit similaire 2">
                    <h3>Orchidée Sublime</h3>
                    <p>Prix : 45€</p>
                    <a href="productDetails.jsp?id=3" class="btn">Voir le produit</a>
                </div>
            </div>
        </section>
    </main>
</body>
</html>
