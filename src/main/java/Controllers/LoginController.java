package Controllers;

import DataBase.DataBaseConnection;
import java.sql.Connection;
import java.sql.SQLException;
import javafx.fxml.FXML;
import javafx.scene.control.TextField;
import javafx.scene.control.PasswordField;
import javafx.scene.control.Label;
import javafx.event.ActionEvent;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.stage.Stage;

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
            // CAMBIAR A LA NUEVA ESCENA
            try {
                FXMLLoader loader = new FXMLLoader(getClass().getResource("/fxml/ventas_main.fxml"));
                Scene nuevaEscena = new Scene(loader.load());

                // Obtener el Stage actual desde el TextField o cualquier nodo
                Stage stage = (Stage) usernameField.getScene().getWindow();
                stage.setTitle("Panel de Ventas");
                stage.setScene(nuevaEscena);
                stage.show();
                stage.centerOnScreen();
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("Error al cargar la nueva escena.");
            }

        } else {
            // Falló la conexión
            messageLabel.setVisible(true);
            messageLabel.setText("Usuario o contraseña incorrectos. Intente nuevamente");
        }
    }
    
}
