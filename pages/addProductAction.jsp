<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File, jakarta.servlet.http.Part, assets.*" %>

<%@ page import="java.io.IOException" %>
<%@ page import="java.util.*" %>

<%@ page session="true" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            // Log des paramètres pour débogage
            Enumeration<String> parameterNames = request.getParameterNames();
            while (parameterNames.hasMoreElements()) {
                String paramName = parameterNames.nextElement();
                System.out.println(paramName + ": " + request.getParameter(paramName));
            }

        Part namePart = request.getPart("productName");
        Part descriptionPart = request.getPart("productDescription");
        Part categoryPart = request.getPart("productCategory");

        String name = new String(namePart.getInputStream().readAllBytes(), "UTF-8").trim();
        String description = new String(descriptionPart.getInputStream().readAllBytes(), "UTF-8").trim();
        String categoryId = new String(categoryPart.getInputStream().readAllBytes(), "UTF-8").trim();

            if (name == null || description == null || categoryId == null || name.trim().isEmpty() || description.trim().isEmpty() || categoryId.trim().isEmpty()) {
                throw new Exception("Tous les champs obligatoires doivent être remplis.");
            }

            String picturePath = "";
            Part picturePart = request.getPart("productImage");
            if (picturePart != null && picturePart.getSize() > 0) {
                String fileName = picturePart.getSubmittedFileName();
                String uploadDirectory = "/Users/macbookpro/Downloads/apache-tomcat-10.1.15/webapps/projet-baovola-2929/WEB-INF/img";
                File uploadDir = new File(uploadDirectory);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs(); // Créer le répertoire si nécessaire
                }
                picturePath = uploadDirectory + "/" + fileName;
                picturePart.write(picturePath); // Sauvegarde l'image
            }

            Product product = new Product(0, name, description, picturePath, Integer.parseInt(categoryId));

            // Appel à la méthode pour insérer en base
            message = ProductDAO.addProduct(product);

            // Rediriger vers la page de gestion après succès
            response.sendRedirect("productManagement.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
            return;
        } catch (Exception e) {
            e.printStackTrace();
            message = "Erreur lors du traitement du formulaire : " + e.getMessage();
        }
    }

    // Affichage d'un message d'erreur si nécessaire
    if (!message.isEmpty()) {
        out.println("<script type='text/javascript'>alert('" + message.replace("'", "\\'") + "');</script>");
    }
%>
