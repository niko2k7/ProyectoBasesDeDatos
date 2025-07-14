package DataBase;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DataBaseConnection {
    
    private static String bd = "proyecto_base_datos";
    private static String host = "localhost";
    private static String server = "jdbc:mysql://" + host + "/" + bd + "?serverTimezone=UTC";
    private static Connection conexion = null;
    
    public static Connection connect(String user, String password) {
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
    
    public static Connection getActiveConnection() {
        return conexion;
    }
    
    public static void disconnect() {
        if (conexion != null) {
            try {
                conexion.close();
                System.out.println("Conexion cerrada correctamente... OK");
                conexion = null;
            } catch (SQLException e) {
                System.out.println("Error al cerrar la conexión.");
                e.printStackTrace();
            }
        }
    }
}
