<%@ page import="assets.UserCart" %>
<%@ page import="assets.UserCartDAO" %>
<%@ page import="assets.ProductDAO" %>
<%@ page import="assets.PriceDAO" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="style.css">
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
                <li><a href="productList.jsp">Produits</a></li>
                <li><a href="cart.jsp">Mon Panier</a></li>
                <li><a href="logout.jsp">Se déconnecter</a></li>
            </ul>
        </nav>
    </header>

    <!-- Contenu principal -->
    <main class="container">
        <h1>Mon Panier</h1>

        <%
            // Récupérer l'ID de l'utilisateur depuis la session
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId != null) {
                // Récupérer les produits dans le panier de l'utilisateur
                UserCartDAO userCartDAO = new UserCartDAO();
                List<UserCart> cartItems = userCartDAO.getCartItems(userId);

                if (cartItems.isEmpty()) {
        %>
                    <p>Votre panier est vide.</p>
        <%
                } else {
        %>
                    <table>
                        <thead>
                            <tr>
                                <th>Produit</th>
                                <th>Quantité</th>
                                <th>Prix Unitaire</th>
                                <th>Prix Total</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                double total = 0;
                                ProductDAO productDAO = new ProductDAO();
                                PriceDAO priceDAO = new PriceDAO();

                                for (UserCart cartItem : cartItems) {
                                    // Récupérer les informations du produit
                                    Product product = productDAO.getProductById(cartItem.getProductId());
                                    double price = priceDAO.getLatestPriceForProduct(cartItem.getProductId());

                                    // Calculer le prix total pour cet élément
                                    double itemTotalPrice = price * cartItem.getQuantity();
                                    total += itemTotalPrice;
                            %>
                                <tr>
                                    <td><%= product.getName() %></td>
                                    <td><%= cartItem.getQuantity() %></td>
                                    <td><%= price %> €</td>
                                    <td><%= itemTotalPrice %> €</td>
                                    <td>
                                        <!-- Formulaire pour supprimer l'élément du panier -->
                                        <form action="removeFromCart.jsp" method="post">
                                            <input type="hidden" name="cartItemId" value="<%= cartItem.getId() %>">
                                            <button type="submit">Supprimer</button>
                                        </form>
                                    </td>
                                </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                    <div class="total">
                        <h3>Total : <%= total %> €</h3>
                    </div>
                    <div class="checkout">
                        <a href="checkout.jsp" class="button">Passer à la caisse</a>
                    </div>
        <%
                }
            } else {
        %>
                <p>Vous devez vous connecter pour voir votre panier.</p>
        <%
            }
        %>
    </main>

</body>
</html>
