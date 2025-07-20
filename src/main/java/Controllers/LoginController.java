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
        String rol = obtenerRolActual();
        if (rol == null) {
            messageLabel.setVisible(true);
            messageLabel.setText("No se pudo determinar el rol del usuario.");
            return;
        }

        System.out.println("Rol activo: " + rol);

        FXMLLoader loader;
        switch (rol) {
            case "rol_administrador":
                loader = new FXMLLoader(getClass().getResource("/fxml/admin_main.fxml"));
                break;
            case "rol_gerente":
                loader = new FXMLLoader(getClass().getResource("/fxml/gerente_main.fxml"));
                break;
            case "rol_ventas":
                loader = new FXMLLoader(getClass().getResource("/fxml/ventas_main.fxml"));
                break;
            case "rol_contabilidad":
                loader = new FXMLLoader(getClass().getResource("/fxml/contabilidad_main.fxml"));
                break;
            case "rol_almacen_taller":
                loader = new FXMLLoader(getClass().getResource("/fxml/almacen_taller_main.fxml"));
                break;
            default:
                messageLabel.setVisible(true);
                messageLabel.setText("Rol desconocido: " + rol);
                return;
        }

        Scene nuevaEscena = new Scene(loader.load());
        Stage stage = (Stage) usernameField.getScene().getWindow();
        stage.setScene(nuevaEscena);
        stage.centerOnScreen();
        stage.show();

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error al cargar la nueva escena.");
        }
    } 

    private String obtenerRolActual() {
        try (var stmt = DataBaseConnection.getActiveConnection().createStatement();
            var rs = stmt.executeQuery("SELECT CURRENT_ROLE()")) {

            if (rs.next()) {
                String rolCompleto = rs.getString(1); // Ej: '`rol_ventas`@localhost'
                rolCompleto = rolCompleto.replace("`", ""); // Elimina las comillas invertidas
                return rolCompleto.split("@")[0]; // Te quedas con 'rol_ventas'
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
