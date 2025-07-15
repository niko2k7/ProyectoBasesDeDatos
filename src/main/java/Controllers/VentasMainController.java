package Controllers;

import DataBase.DataBaseConnection;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.layout.BorderPane;
import javafx.stage.Stage;

public class VentasMainController {

    @FXML
    private BorderPane mainBorderPane;

    private void cargarVista(String archivoFXML) {
        try {
            Node nuevaVista = FXMLLoader.load(getClass().getResource("/fxml/" + archivoFXML));
            mainBorderPane.setCenter(nuevaVista);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    @FXML
    public void initialize() {
        cargarVista("ventas_main_content.fxml");
    }

    @FXML
    private void cargarVistaClientes() {
        cargarVista("ventas_clientes.fxml");
    }

    @FXML
    private void cargarVistaProductos() {
        cargarVista("ventas_productos.fxml");
    }

    @FXML
    private void cargarVistaFacturas() {
        cargarVista("ventas_facturas.fxml");
    }

    @FXML
    private void cargarLogin() {
        try {
        DataBaseConnection.disconnect();
        FXMLLoader loader = new FXMLLoader(getClass().getResource("/fxml/login.fxml"));
        Scene loginScene = new Scene(loader.load());

        // Obtener el Stage actual desde el BorderPane
        Stage stage = (Stage) mainBorderPane.getScene().getWindow();
        stage.setTitle("Login");
        stage.setScene(loginScene);
        stage.centerOnScreen();
        stage.show();

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("No se pudo volver al login.");
        }
    }
}