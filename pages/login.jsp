<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Boutique de Fleurs</title>
</head>
<body>
    <div class="container">
        <!-- Section gauche pour l'image -->
        <div class="left-section">
            <img src="path/to/your/image.jpg" alt="Image de fleurs" class="image-placeholder">
        </div>

        <!-- Section droite pour le formulaire de login -->
        <div class="right-section">
            <h2>Connexion</h2>
            <form action="loginAction" method="post">
                <div class="form-group">
                    <label for="username">Nom d'utilisateur :</label>
                    <input type="text" id="username" name="username" required>
                </div>
                <div class="form-group">
                    <label for="password">Mot de passe :</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <div class="form-group">
                    <button type="submit">Se connecter</button>
                </div>
            </form>
            <p>Pas encore inscrit ? <a href="register.jsp">Créer un compte</a></p>
        </div>
    </div>
</body>
</html>
