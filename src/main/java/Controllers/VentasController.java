package Controllers;

import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.layout.Pane;
import javafx.scene.layout.StackPane;
import javafx.stage.Stage;
import javafx.scene.Scene;
import Controllers.LoginController;

public class VentasController {

    @FXML
    private StackPane contentPane;

    @FXML
    private void loadUsuarios() {
        loadUI("/usuarios.fxml");
    }

    @FXML
    private void loadProductos() {
        loadUI("/productos.fxml");
    }

    @FXML
    private void logout() {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("/login.fxml"));
            Scene scene = new Scene(loader.load());
            Stage stage = (Stage) contentPane.getScene().getWindow();
            stage.setScene(scene);
            stage.setTitle("Login");
            stage.show();
//            try {
//                LoginController.conn.close();
//                System.out.println("Conexion cerrada");
//            } catch (SQLException e) {
//                System.out.println("Error al cerrar la conexión");
//            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void loadUI(String fxml) {
        try {
            Pane pane = FXMLLoader.load(getClass().getResource(fxml));
            contentPane.getChildren().setAll(pane);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private void handleMenuAction(){
        
    }

}
