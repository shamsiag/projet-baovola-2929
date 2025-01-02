package assets;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Connexion {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/PROJETBAOVOLA2929?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    public static Connection connectToDatabase() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            connection.setAutoCommit(true);
            System.out.println("Connexion à la base de données établie.");
            return connection;
        } catch (ClassNotFoundException e) {
            throw new SQLException("Pilote JDBC MySQL non trouvé", e);
        }
    }

    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static void insert(String table, String column, String constraint, String values) throws SQLException {
        String query = constraint == null
                ? "INSERT INTO " + table + " (" + column + ") VALUES(" + values + ")"
                : "INSERT INTO " + table + " (" + column + ") VALUES(" + values + ") WHERE " + constraint;

        try (Connection connection = connectToDatabase();
                PreparedStatement preparedStatement = connection.prepareStatement(query)) {

            preparedStatement.executeUpdate();
            connection.commit();
            System.out.println("Données insérées avec succès.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static ArrayList<String> select(String table, String column, String constraint) throws SQLException {
        ArrayList<String> result = new ArrayList<>();
        List<String> columns = Arrays.asList(column.split(","));
        String query = "SELECT " + column + " FROM " + table + (constraint != null ? " WHERE " + constraint : "");

        try (Connection connection = connectToDatabase();
                PreparedStatement preparedStatement = connection.prepareStatement(query);
                ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                for (String col : columns) {
                    result.add(resultSet.getString(col));
                }
            }
            System.out.println("Résultats de la sélection : " + result);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
}
