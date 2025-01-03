<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="assets.*" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    String redirectPage = "productList.jsp"; // Page par défaut vers laquelle rediriger
    String message = "";

    try {

        if (session != null && session.getAttribute("userId") != null) {
            int userId = (int) session.getAttribute("userId");
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            UserCart userCart = new UserCart();
            userCart.setUserId(userId);
            userCart.setProductId(productId);
            userCart.setQuantity(quantity);
            userCart.setAddedOn(LocalDateTime.now());
            UserCartDAO cartDAO = new UserCartDAO();
            boolean success = cartDAO.addProductToCart(userCart);

            if (success) {
                message = "Produit ajouté au panier avec succès.";
                redirectPage = "userCart.jsp"; // Redirection vers le panier en cas de succès
            } else {
                message = "Une erreur est survenue lors de l'ajout du produit au panier.";
            }
        } else {
            message = "Veuillez vous connecter pour ajouter des produits à votre panier.";
            redirectPage = "login.jsp"; // Redirection vers la page de connexion si l'utilisateur n'est pas connecté
        }
    } catch (Exception e) {
        message = "Une erreur est survenue : " + e.getMessage();
        e.printStackTrace();
    }

    session.setAttribute("cartMessage", message); // Enregistrer le message pour l'afficher sur la page suivante
    response.sendRedirect(redirectPage); // Redirection vers la page cible
%>
