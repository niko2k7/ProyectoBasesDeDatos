package Controllers;

import DataBase.DataBaseConnection;
import java.sql.Connection;
import java.sql.SQLException;
import javafx.fxml.FXML;
import javafx.scene.control.TextField;
import javafx.scene.control.PasswordField;
import javafx.scene.control.Label;
import javafx.event.ActionEvent;

public class LoginController {
    @FXML private TextField usernameField;
    @FXML private PasswordField passwordField;
    @FXML private Label messageLabel;

    @FXML
    private void onClickIngresar(ActionEvent event) {
        String usuario = usernameField.getText();
        String contrasena = passwordField.getText();
        handleConnection(usuario, contrasena);
    }
    
    private void handleConnection(String usuario, String contrasena){
    
        Connection conn = DataBaseConnection.connect(usuario, contrasena);

        if (conn != null) {
            // Éxito en la conexión
            messageLabel.setVisible(false);
            System.out.println("Conectado a la base de datos");

            // Aquí podrías cargar la siguiente escena
            // loadAdminScene();

            // Si quieres cerrar conexión inmediatamente:
            try {
                conn.close();
                System.out.println("Conexion cerrada");
            } catch (SQLException e) {
                System.out.println("Error al cerrar la conexión");
            }

        } else {
            // Falló la conexión
            messageLabel.setVisible(true);
            messageLabel.setText("Usuario o contraseña incorrectos. Intente nuevamente");
        }
    }
    
}
