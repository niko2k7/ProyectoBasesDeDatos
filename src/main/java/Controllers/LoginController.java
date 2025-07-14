package Controllers;

import DataBase.DataBaseConnection;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
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
    
    private void handleConnection(String usuario, String contrasena) {
        if (DataBaseConnection.connect(usuario, contrasena) == null) {
        // Falló la conexión
        messageLabel.setVisible(true);
        messageLabel.setText("Usuario o contraseña incorrectos. Intente nuevamente");
        return;
    }

        // Éxito en la conexión
        messageLabel.setVisible(false);
        System.out.println("Conectado a la base de datos");

        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/fxml/ventas_main.fxml"));
            Scene nuevaEscena = new Scene(loader.load());

            Stage stage = (Stage) usernameField.getScene().getWindow();
            stage.setTitle("Panel de Ventas");
            stage.setScene(nuevaEscena);
            stage.centerOnScreen();
            stage.show();
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error al cargar la nueva escena.");
        }
    }  
}
