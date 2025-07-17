package Controllers;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import DataBase.DataBaseConnection;
import Models.Articulo;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.cell.PropertyValueFactory;

public class VentasProductosController {
    @FXML private TableView<Articulo> tablaArticulos;
    @FXML private TableColumn<Articulo, String> colArticuloId;
    @FXML private TableColumn<Articulo, String> colArticuloTipo;
    @FXML private TableColumn<Articulo, String> colArticuloMarca;
    @FXML private TableColumn<Articulo, String> colArticuloModelo;
    @FXML private TableColumn<Articulo, String> colArticuloPrecio;
    @FXML private TableColumn<Articulo, String> colArticuloStock;
    @FXML private TableColumn<Articulo, Void> colAccionArticulos;

    // @FXML private TableView<Servicio> tablaServicios;
    // @FXML private TableColumn<Servicio, String> colServicioId;
    // @FXML private TableColumn<Servicio, String> colServicioNombre;
    // @FXML private TableColumn<Servicio, String> colServicioPrecio;
    // @FXML private TableColumn<Servicio, String> colServicioEmpleadoAsociado;
    // @FXML private TableColumn<Servicio, Void> colAccionServProducto;

    @FXML private TextField txtBuscarArticulo;


    private ObservableList<Articulo> listaArticulos = FXCollections.observableArrayList();
    // private ObservableList<Servicio> listaServicios = FXCollections.observableArrayList();

    @FXML
    public void initialize() {
        configurarColumnasTablaArticulo();
        cargarDatosArticuloDesdeBD(); 
        // configurarColumnaAccion();
    }

    private void configurarColumnasTablaArticulo() {
        colArticuloId.setCellValueFactory(new PropertyValueFactory<>("id"));
        colArticuloTipo.setCellValueFactory(new PropertyValueFactory<>("tipo"));
        colArticuloMarca.setCellValueFactory(new PropertyValueFactory<>("marca"));
        colArticuloModelo.setCellValueFactory(new PropertyValueFactory<>("modelo"));
        colArticuloPrecio.setCellValueFactory(new PropertyValueFactory<>("precio"));
        colArticuloStock.setCellValueFactory(new PropertyValueFactory<>("stock"));
    }

     private void cargarDatosArticuloDesdeBD() {
        listaArticulos.clear();

        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            // Usar
                // CallableStatement stmt = conn.prepareCall("{call obtener_clientes}");
                // ResultSet = stmt.executeQuery();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(
                "select prod_id, art_tipo, art_marca, art_modelo, prod_precio, art_cantidad_disponible from producto natural join articulo");

            while (rs.next()) {
                Articulo articulo = new Articulo(
                    rs.getString("prod_id"),
                    rs.getString("art_tipo"),
                    rs.getString("art_marca"),
                    rs.getString("art_modelo"),
                    rs.getString("prod_precio"),
                    rs.getString("art_cantidad_disponible")
                );
                listaArticulos.add(articulo);
            }

            tablaArticulos.setItems(listaArticulos);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @FXML
    private void BuscarArticulo(){
        
    }

}
