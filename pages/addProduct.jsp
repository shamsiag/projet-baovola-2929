<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File" %>
<%@ page language="java" import="java.util.*, assets.*" %>
<%@ page import="java.io.IOException" %>

<%@ page session="true" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Category productService = new Category();
    List<Category> categories = productService.getAllCategories();
    request.setAttribute("categories", categories);

    String message = "";

%>

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

         

        <form action="addProductAction.jsp" method="POST" enctype="multipart/form-data">
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
                <option value="" disabled selected>Choisir une catégorie</option>
                <% for (Category category : categories) { %>
                <option value="<%= category.getId() %>"><%= category.getName() %></option>
                 <% } %>
                </select>
            </div>
            <div class="form-group">
                <button type="submit">Ajouter le produit</button>
            </div>
        </form>
    </main>
</body>
</html>
