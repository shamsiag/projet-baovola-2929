<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - Boutique de Fleurs</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <div class="container">
        <!-- Section gauche pour l'image -->
        <div class="left-section">
            <img src="path/to/your/image.jpg" alt="Image de fleurs" class="image-placeholder">
        </div>

        <!-- Section droite pour le formulaire d'inscription -->
        <div class="right-section">
            <h2>Créer un compte</h2>
            <form action="registerAction" method="post">
                <div class="form-group">
                    <label for="fullname">Nom complet :</label>
                    <input type="text" id="fullname" name="fullname" required>
                </div>
                <div class="form-group">
                    <label for="email">Adresse e-mail :</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="username">Nom d'utilisateur :</label>
                    <input type="text" id="username" name="username" required>
                </div>
                <div class="form-group">
                    <label for="password">Mot de passe :</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Confirmer le mot de passe :</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                </div>
                <div class="form-group">
                    <button type="submit">S'inscrire</button>
                </div>
            </form>
            <p>Déjà inscrit ? <a href="login.jsp">Se connecter</a></p>
        </div>
    </div>
</body>
</html>
