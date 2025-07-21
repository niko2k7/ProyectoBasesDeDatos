package Controllers;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;

import DataBase.DataBaseConnection;
import Models.DetalleFacturaArticulo;
import Models.DetalleFacturaServicio;
import Models.Factura;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.cell.PropertyValueFactory;

public class VentasVerDetalleFacturasController {
    @FXML private TableView<DetalleFacturaArticulo> tablaDetalleFacturaArticulos;
    @FXML private TableColumn<DetalleFacturaArticulo, String> colArticuloId;
    @FXML private TableColumn<DetalleFacturaArticulo, String> colArticuloTipo;
    @FXML private TableColumn<DetalleFacturaArticulo, String> colArticuloMarca;
    @FXML private TableColumn<DetalleFacturaArticulo, String> colArticuloModelo;
    @FXML private TableColumn<DetalleFacturaArticulo, String> colArticuloPrecioUnitario;
    @FXML private TableColumn<DetalleFacturaArticulo, String> colArticuloCantidad;
    @FXML private TableColumn<DetalleFacturaArticulo, String> colArticuloSubtotal;
    
    @FXML private TableView<DetalleFacturaServicio> tablaDetalleFacturaServicios;
    @FXML private TableColumn<DetalleFacturaServicio, String> colServicioId;
    @FXML private TableColumn<DetalleFacturaServicio, String> colServicioNombre;
    @FXML private TableColumn<DetalleFacturaServicio, String> colServicioPrecio;
    @FXML private TableColumn<DetalleFacturaServicio, String> colServicioEmpleadoAsociado;

    @FXML private TextField txtDocumento;
    @FXML private TextField txtNombre;
    @FXML private TextField txtDireccion;
    @FXML private TextField txtTelefono;
    @FXML private TextField txtCorreo;
    @FXML private TextField txtEstadoJuridico;
    @FXML private TextField txtId;
    @FXML private TextField txtFecha;
    @FXML private TextField txtMetodoPago;
    @FXML private TextField txtTotal;

    private ObservableList<DetalleFacturaArticulo> detalleFacturaArticulos = FXCollections.observableArrayList();
    private ObservableList<DetalleFacturaServicio> detalleFacturaServicios = FXCollections.observableArrayList();

    @FXML
    public void initialize() {
        VentasContexto.getInstancia().setVerDetalleFacturasController(this);
        configurarColumnasTablaArticulos();
        configurarColumnasTablaServicios();
        tablaDetalleFacturaArticulos.setItems(detalleFacturaArticulos);
        tablaDetalleFacturaServicios.setItems(detalleFacturaServicios); 
    }

    private void configurarColumnasTablaArticulos() {
        colArticuloId.setCellValueFactory(new PropertyValueFactory<>("Id"));
        colArticuloTipo.setCellValueFactory(new PropertyValueFactory<>("Tipo"));
        colArticuloMarca.setCellValueFactory(new PropertyValueFactory<>("Marca"));
        colArticuloModelo.setCellValueFactory(new PropertyValueFactory<>("Modelo"));
        colArticuloPrecioUnitario.setCellValueFactory(new PropertyValueFactory<>("PrecioUnitario"));
        colArticuloCantidad.setCellValueFactory(new PropertyValueFactory<>("Cantidad"));
        colArticuloSubtotal.setCellValueFactory(new PropertyValueFactory<>("Subtotal"));
    }


    private void configurarColumnasTablaServicios() {
        colServicioId.setCellValueFactory(new PropertyValueFactory<>("Id"));
        colServicioNombre.setCellValueFactory(new PropertyValueFactory<>("Nombre"));
        colServicioPrecio.setCellValueFactory(new PropertyValueFactory<>("Precio"));
        colServicioEmpleadoAsociado.setCellValueFactory(new PropertyValueFactory<>("empleadoAsociado"));
    }
    
    public void cargarFactura(Factura factura) {
        try {
            Connection conn = DataBaseConnection.getActiveConnection();

            // Consulta al cliente basado en el documento
            CallableStatement stmt = conn.prepareCall("{CALL sp_obtener_datos_cliente(?)}");
            stmt.setString(1, factura.getDocumentoCliente());
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                txtNombre.setText(rs.getString("act_nombre"));
                txtDireccion.setText(rs.getString("act_direccion"));
                txtTelefono.setText(rs.getString("act_telefono"));
                txtCorreo.setText(rs.getString("act_correo"));
                txtEstadoJuridico.setText(rs.getString("act_estado_juridico"));
            }

            // Datos de la factura
            txtDocumento.setText(factura.getDocumentoCliente());
            txtId.setText(factura.getCodigo());
            txtFecha.setText(factura.getFecha());
            txtMetodoPago.setText(factura.getMetodoPago());
            txtTotal.setText(factura.getTotal());

            // Cargar artículos y servicios
            cargarArticulos(factura.getCodigo());
            cargarServicios(factura.getCodigo());

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void cargarArticulos(String codigoFactura){
        detalleFacturaArticulos.clear();
        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            CallableStatement stmt = conn.prepareCall("{CALL sp_cargar_articulos_factura(?)}");
            stmt.setString(1, codigoFactura);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                DetalleFacturaArticulo dfa = new DetalleFacturaArticulo(
                    rs.getString("prod_id"),
                    rs.getString("art_tipo"),
                    rs.getString("art_marca"),
                    rs.getString("art_modelo"),
                    rs.getString("dfv_precio_unitario"),
                    rs.getString("dfv_cantidad"),
                    rs.getString("dfv_subtotal")
                );
                System.out.println("Articulo: " + rs.getString("prod_id") + " - " + rs.getString("art_tipo"));

                detalleFacturaArticulos.add(dfa);
            }

            tablaDetalleFacturaArticulos.setItems(detalleFacturaArticulos);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void cargarServicios(String codigoFactura){
        detalleFacturaServicios.clear();
        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            CallableStatement stmt = conn.prepareCall("{CALL sp_cargar_servicios_factura(?)}");
            stmt.setString(1, codigoFactura);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                DetalleFacturaServicio dfs = new DetalleFacturaServicio(
                    rs.getString("prod_id"),
                    rs.getString("serv_nombre"),
                    rs.getString("prod_precio"),
                    rs.getString("act_nombre")
                );
                System.out.println("Servicio: " + rs.getString("prod_id") + " - " + rs.getString("serv_nombre"));

                detalleFacturaServicios.add(dfs);
            }

            tablaDetalleFacturaServicios.setItems(detalleFacturaServicios);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}  

