<%@ page import="java.util.List" %>
<%@ page import="assets.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Récupérer la chaîne de recherche depuis le formulaire
    String query = request.getParameter("searchQuery");
    if (query == null) {
        query = ""; // Si aucune recherche n'est effectuée, ne rien filtrer
    }
    
    // Créer une instance du ProductService
    ProductDAO productService = new ProductDAO();
    
    // Appeler la fonction de recherche
    List<Product> products = productService.searchProducts(query);
    request.setAttribute("products", products);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="style.css">
    <title>Liste des produits</title>
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

    <!-- Formulaire de recherche -->
    <main class="container">
        <h1>Recherche de produits</h1>
        
        <form action="productList.jsp" method="get">
            <input type="text" name="searchQuery" placeholder="Rechercher un produit..." value="<%= query %>">
            <button type="submit">Rechercher</button>
        </form>

        <div class="product-list">
            <% 
                if (products != null && !products.isEmpty()) {
                    for (Product product : products) {
            %>
                        <div class="product-card">
                            <img src="<%= product.getPicture() %>" alt="<%= product.getName() %>">
                            <h3><%= product.getName() %></h3>
                            <p><%= product.getDescription() %></p>
                            <p>Prix : <%= product.getPrice() %> €</p>
                            <a href="productDetails.jsp?productId=<%= product.getId() %>">Voir les détails</a>
                        </div>
            <%
                    }
                } else {
            %>
                    <p>Aucun produit trouvé.</p>
            <% 
                }
            %>
        </div>
    </main>
</body>
</html>
