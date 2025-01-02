<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.util.*, assets.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    ProductDAO productService = new ProductDAO();
    List<Product> products = productService.getAllProducts();
    request.setAttribute("products", products);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accueil - Boutique de Fleurs</title>
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

    <!-- Section principale -->
    <main class="container">
        <!-- Barre de recherche -->
        <div class="search-bar">
            <form action="productList.jsp" method="get">
                <input type="text" name="query" placeholder="Recherchez des fleurs, bouquets..." required>
                <button type="submit">Rechercher</button>
            </form>
        </div>

        <!-- Filtres -->
        <aside class="filters">
            <h3>Filtres</h3>
            <form action="filterAction" method="get">
                <div class="form-group">
                    <label for="category">Catégorie :</label>
                    <select id="category" name="category">
                        <option value="all">Toutes</option>
                        <option value="roses">Roses</option>
                        <option value="tulips">Tulipes</option>
                        <option value="orchids">Orchidées</option>
                        <option value="mixed">Bouquets Mélangés</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="priceRange">Plage de prix :</label>
                    <select id="priceRange" name="priceRange">
                        <option value="all">Toutes</option>
                        <option value="low">0-20€</option>
                        <option value="medium">20-50€</option>
                        <option value="high">50€ et plus</option>
                    </select>
                </div>
                <div class="form-group">
                    <button type="submit">Appliquer</button>
                </div>
            </form>
        </aside>

        <!-- Section des produits -->
        <section class="product-cards">
            <h2>Produits en vedette</h2>
            <div class="cards-container">
                <% 
                for (Product product : products) { 
                %>
                <div class="product-card">
                    <img src="<%= product.getPicture()%>" alt="<%= product.getName() %>">
                    <h3><%= product.getName() %></h3>
                    <p><%= product.getPrice() %></p>
                    <a href="productDetails.jsp?productId=<%= product.getId() %>">Voir les détails</a>
                </div>
                <% } %>
            </div>
        </section>
    </main>
</body>
</html>
