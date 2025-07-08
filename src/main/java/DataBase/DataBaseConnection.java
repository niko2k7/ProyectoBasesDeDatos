package DataBase;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DataBaseConnection {
    
    private static String bd = "museo_bd";
    private static String host = "localhost";
    private static String server = "jdbc:mysql://" + host + "/" + bd + "?serverTimezone=UTC";

    public static Connection connect(String user, String password) {
        Connection conexion = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conexion = DriverManager.getConnection(server, user, password);
            System.out.println("Conexion a base de datos " + server + " ... OK");
        } catch (ClassNotFoundException ex) {
            System.out.println("Error cargando el Driver MySQL JDBC ... FAIL");
        } catch (SQLException ex) {
            System.out.println("Imposible realizar conexion con " + server + " ... FAIL");
            System.out.println("SQLException: " + ex.getMessage());
        }
        return conexion;
    }
}
