package Controllers;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import DataBase.DataBaseConnection;
import Models.Factura;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.cell.PropertyValueFactory;

public class VentasVerFacturasController {
    @FXML private TableView<Factura> tablaFacturas;
    @FXML private TableColumn<Factura, String> colCodigo;
    @FXML private TableColumn<Factura, String> colFecha;
    @FXML private TableColumn<Factura, String> colTotal;
    @FXML private TableColumn<Factura, String> colMetodoPago;
    @FXML private TableColumn<Factura, String> colDocumentoCliente;
    @FXML private TableColumn<Factura, String> colNombreCliente;
    @FXML private TableColumn<Factura, Void> colAccion;

    private ObservableList<Factura> listaFacturas = FXCollections.observableArrayList();

    @FXML private TextField txtCodigo;
    @FXML private TextField txtDocumentoCliente;
    @FXML private TextField txtFechaPrimera;
    @FXML private TextField txtFechaSegunda;
    @FXML private TextField txtFechaUnica;

    @FXML
    public void initialize() {
        configurarColumnas();
        cargarDatosDesdeBD(); 
        // configurarColumnaAccion();
        VentasContexto.getInstancia().setVerFacturaController(this);
    }

    private void configurarColumnas() {
        colCodigo.setCellValueFactory(new PropertyValueFactory<>("Codigo"));
        colFecha.setCellValueFactory(new PropertyValueFactory<>("Fecha"));
        colTotal.setCellValueFactory(new PropertyValueFactory<>("Total"));
        colMetodoPago.setCellValueFactory(new PropertyValueFactory<>("MetodoPago"));
        colDocumentoCliente.setCellValueFactory(new PropertyValueFactory<>("DocumentoCliente"));
        colNombreCliente.setCellValueFactory(new PropertyValueFactory<>("NombreCliente"));
    }

    public void cargarDatosDesdeBD() {
        listaFacturas.clear();

        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            // Usar
                // CallableStatement stmt = conn.prepareCall("{call obtener_clientes}");
                // ResultSet = stmt.executeQuery();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(
                "select fven_codigo, fven_fecha, fven_total, fven_metodo_pago, act_documento, act_nombre from factura_venta natural join actor;");

            while (rs.next()) {
                Factura factura = new Factura(
                    rs.getString("fven_codigo"),
                    rs.getString("fven_fecha"),
                    rs.getString("fven_total"),
                    rs.getString("fven_metodo_pago"),
                    rs.getString("act_documento"),
                    rs.getString("act_nombre")
                );
                listaFacturas.add(factura);
            }

            tablaFacturas.setItems(listaFacturas);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    // Búsquedas
    @FXML
    private void buscarCodigo(){
        listaFacturas.clear();

        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            
            // Usar
                // CallableStatement stmt = conn.prepareCall("{call obtener_clientes}");
                // ResultSet = stmt.executeQuery();
            PreparedStatement stmt = conn.prepareStatement(
            "select fven_codigo, fven_fecha, fven_total, fven_metodo_pago, act_documento, act_nombre "+
            "from factura_venta natural join actor where fven_codigo = ?;"
            );
            stmt.setInt(1, Integer.parseInt(txtCodigo.getText()));

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Factura factura = new Factura(
                    rs.getString("fven_codigo"),
                    rs.getString("fven_fecha"),
                    rs.getString("fven_total"),
                    rs.getString("fven_metodo_pago"),
                    rs.getString("act_documento"),
                    rs.getString("act_nombre")
                );
                listaFacturas.add(factura);
            }

            tablaFacturas.setItems(listaFacturas);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @FXML
    private void buscarFecha(){
        listaFacturas.clear();

        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            
            // Usar
                // CallableStatement stmt = conn.prepareCall("{call obtener_clientes}");
                // ResultSet = stmt.executeQuery();
            PreparedStatement stmt = conn.prepareStatement(
            "select fven_codigo, fven_fecha, fven_total, fven_metodo_pago, act_documento, act_nombre "+
            "from factura_venta natural join actor where fven_fecha LIKE ?;"
            );
            stmt.setString(1, txtFechaUnica.getText());
            
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Factura factura = new Factura(
                    rs.getString("fven_codigo"),
                    rs.getString("fven_fecha"),
                    rs.getString("fven_total"),
                    rs.getString("fven_metodo_pago"),
                    rs.getString("act_documento"),
                    rs.getString("act_nombre")
                );
                listaFacturas.add(factura);
            }

            tablaFacturas.setItems(listaFacturas);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @FXML
    private void buscarIntervaloFechas(){
        listaFacturas.clear();

        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            
            // Usar
                // CallableStatement stmt = conn.prepareCall("{call obtener_clientes}");
                // ResultSet = stmt.executeQuery();
            PreparedStatement stmt = conn.prepareStatement(
            "select fven_codigo, fven_fecha, fven_total, fven_metodo_pago, act_documento, act_nombre from factura_venta natural join actor "+
            "where fven_fecha between '?' and '?' or fven_fecha between '?' and '?'"
            );
            stmt.setString(1, txtFechaPrimera.getText());
            stmt.setString(2, txtFechaSegunda.getText());
            stmt.setString(3, txtFechaSegunda.getText());
            stmt.setString(4, txtFechaPrimera.getText());
            
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Factura factura = new Factura(
                    rs.getString("fven_codigo"),
                    rs.getString("fven_fecha"),
                    rs.getString("fven_total"),
                    rs.getString("fven_metodo_pago"),
                    rs.getString("act_documento"),
                    rs.getString("act_nombre")
                );
                listaFacturas.add(factura);
            }

            tablaFacturas.setItems(listaFacturas);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @FXML
    private void buscarDocumentoCliente(){
        listaFacturas.clear();

        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            
            // Usar
                // CallableStatement stmt = conn.prepareCall("{call obtener_clientes}");
                // ResultSet = stmt.executeQuery();
            PreparedStatement stmt = conn.prepareStatement(
            "select fven_codigo, fven_fecha, fven_total, fven_metodo_pago, act_documento, act_nombre "+
            "from factura_venta natural join actor where act_documento LIKE ?;"
            );
            stmt.setString(1, txtDocumentoCliente.getText());
            
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Factura factura = new Factura(
                    rs.getString("fven_codigo"),
                    rs.getString("fven_fecha"),
                    rs.getString("fven_total"),
                    rs.getString("fven_metodo_pago"),
                    rs.getString("act_documento"),
                    rs.getString("act_nombre")
                );
                listaFacturas.add(factura);
            }

            tablaFacturas.setItems(listaFacturas);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    // Filtros
    @FXML
    private void filtrarVerTodos(){
        cargarDatosDesdeBD();
    }

    @FXML
    private void filtrarPagosEfectivo(){
        listaFacturas.clear();

        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            // Usar
                // CallableStatement stmt = conn.prepareCall("{call obtener_clientes}");
                // ResultSet = stmt.executeQuery();
            PreparedStatement stmt = conn.prepareStatement(
            "select fven_codigo, fven_fecha, fven_total, fven_metodo_pago, act_documento, act_nombre "+
            "from factura_venta natural join actor where fven_metodo_pago like '%efectivo%';"
            );

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Factura factura = new Factura(
                    rs.getString("fven_codigo"),
                    rs.getString("fven_fecha"),
                    rs.getString("fven_total"),
                    rs.getString("fven_metodo_pago"),
                    rs.getString("act_documento"),
                    rs.getString("act_nombre")
                );
                listaFacturas.add(factura);
            }

            tablaFacturas.setItems(listaFacturas);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @FXML
    private void filtrarPagosTarjeta(){
        listaFacturas.clear();

        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            // Usar
                // CallableStatement stmt = conn.prepareCall("{call obtener_clientes}");
                // ResultSet = stmt.executeQuery();
            PreparedStatement stmt = conn.prepareStatement(
            "select fven_codigo, fven_fecha, fven_total, fven_metodo_pago, act_documento, act_nombre "+
            "from factura_venta natural join actor where fven_metodo_pago like '%tarjeta%';"
            );

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Factura factura = new Factura(
                    rs.getString("fven_codigo"),
                    rs.getString("fven_fecha"),
                    rs.getString("fven_total"),
                    rs.getString("fven_metodo_pago"),
                    rs.getString("act_documento"),
                    rs.getString("act_nombre")
                );
                listaFacturas.add(factura);
            }

            tablaFacturas.setItems(listaFacturas);
        } catch (Exception e) {
            e.printStackTrace();
        }
    
    }

    @FXML
    private void filtrarPagosTransferencia(){
        listaFacturas.clear();

        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            // Usar
                // CallableStatement stmt = conn.prepareCall("{call obtener_clientes}");
                // ResultSet = stmt.executeQuery();
            PreparedStatement stmt = conn.prepareStatement(
            "select fven_codigo, fven_fecha, fven_total, fven_metodo_pago, act_documento, act_nombre "+
            "from factura_venta natural join actor where fven_metodo_pago like '%transferencia%';"
            );

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Factura factura = new Factura(
                    rs.getString("fven_codigo"),
                    rs.getString("fven_fecha"),
                    rs.getString("fven_total"),
                    rs.getString("fven_metodo_pago"),
                    rs.getString("act_documento"),
                    rs.getString("act_nombre")
                );
                listaFacturas.add(factura);
            }

            tablaFacturas.setItems(listaFacturas);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
