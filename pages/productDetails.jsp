<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
                <li><a href="login.jsp">Se connecter</a></li>
                <li><a href="register.jsp">S'inscrire</a></li>
            </ul>
        </nav>
    </header>

    <!-- Contenu principal -->
    <main class="container">
        <!-- Section des détails du produit -->
        <div class="product-details">
            <div class="product-image">
                <img src="path/to/your/product-image.jpg" alt="Image du produit">
            </div>
            <div class="product-info">
                <h1>Nom du produit</h1>
                <p class="price">Prix : 30€</p>
                <p class="description">
                    Description : Ce bouquet de roses fraîches est parfait pour toute occasion. Les fleurs sont soigneusement sélectionnées pour garantir leur qualité et leur beauté.
                </p>
                <form action="addToCartAction" method="post">
                    <div class="form-group">
                        <label for="quantity">Quantité :</label>
                        <input type="number" id="quantity" name="quantity" value="1" min="1" required>
                    </div>
                    <input type="hidden" name="productId" value="1"> <!-- ID du produit -->
                    <button type="submit" class="btn">Ajouter au panier</button>
                </form>
            </div>
        </div>

        <!-- Section des produits similaires -->
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
