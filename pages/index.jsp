<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accueil - Boutique de Fleurs</title>
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
                <li><a href="login.jsp">Se connecter</a></li>
                <li><a href="register.jsp">S'inscrire</a></li>
            </ul>
        </nav>
    </header>

    <!-- Section principale -->
    <main class="container">
        <!-- Barre de recherche -->
        <div class="search-bar">
            <form action="searchAction" method="get">
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
                <div class="product-card">
                    <img src="path/to/product1.jpg" alt="Produit 1">
                    <h3>Bouquet de Roses</h3>
                    <p>Prix : 30€</p>
                    <a href="productDetails.jsp?id=1" class="btn">Voir le produit</a>
                </div>
                <div class="product-card">
                    <img src="path/to/product2.jpg" alt="Produit 2">
                    <h3>Orchidée Élégante</h3>
                    <p>Prix : 45€</p>
                    <a href="productDetails.jsp?id=2" class="btn">Voir le produit</a>
                </div>
                <div class="product-card">
                    <img src="path/to/product3.jpg" alt="Produit 3">
                    <h3>Bouquet Mélangé</h3>
                    <p>Prix : 25€</p>
                    <a href="productDetails.jsp?id=3" class="btn">Voir le produit</a>
                </div>
                <!-- Ajoutez plus de cartes produit si nécessaire -->
            </div>
        </section>
    </main>
</body>
</html>
