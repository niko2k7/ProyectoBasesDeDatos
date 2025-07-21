package Controllers;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import DataBase.DataBaseConnection;
import Models.Factura;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.TableCell;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.HBox;
import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.util.Callback;

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
        configurarColumnaAccion();
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

    private void configurarColumnaAccion(){
        Callback<TableColumn<Factura, Void>, TableCell<Factura, Void>> cellFactory = new Callback<>() {
            @Override
            public TableCell<Factura, Void> call(final TableColumn<Factura, Void> param) {
                return new TableCell<>() {

                    private final Button btnVerDetalle = new Button("VerDetalle");
                    private final Button btnEliminar = new Button("Eliminar");
                    {
                        btnVerDetalle.setOnAction(event -> {
                            Factura factura = getTableView().getItems().get(getIndex());
                            try {
                                FXMLLoader loader = new FXMLLoader(getClass().getResource("/fxml/ventas_ver_detalle_facturas.fxml"));
                                Parent root = loader.load();

                                VentasVerDetalleFacturasController controller = loader.getController();
                                controller.cargarFactura(factura); // Aquí le pasas la factura

                                Stage stage = new Stage();
                                stage.setTitle("Detalle de Factura #" + factura.getCodigo());
                                stage.setScene(new Scene(root));
                                stage.initModality(Modality.APPLICATION_MODAL);
                                stage.show();

                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        });

                        btnEliminar.setOnAction(event -> {
                            Factura factura = getTableView().getItems().get(getIndex());
                            //eliminarCliente(factura); // Método que debes implementar
                        });
                    }

                    private final HBox hbox = new HBox(10, btnVerDetalle, btnEliminar); // Espaciado entre botones

                    @Override
                    protected void updateItem(Void item, boolean empty) {
                        super.updateItem(item, empty);
                        if (empty) {
                            setGraphic(null);
                        } else {
                            setGraphic(hbox);
                        }
                    }
                };
            }
        };
        colAccion.setCellFactory(cellFactory);
    }

    public void cargarDatosDesdeBD() {
        listaFacturas.clear();

        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            
            CallableStatement stmt = conn.prepareCall("{call sp_obtener_facturas_venta()}");
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


    // Búsquedas
    @FXML
    private void buscarCodigo(){
        listaFacturas.clear();

        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            
            CallableStatement stmt = conn.prepareCall("{call sp_buscar_factura_por_codigo(?)}");
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
            CallableStatement stmt = conn.prepareCall("{call sp_buscar_facturas_por_fecha(?)}");
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
            CallableStatement stmt = conn.prepareCall("{call sp_buscar_facturas_por_intervalo(?, ?)}");
            stmt.setString(1, txtFechaPrimera.getText());
            stmt.setString(2, txtFechaSegunda.getText());
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
            CallableStatement stmt = conn.prepareCall("{call sp_buscar_factura_por_documento(?)}");
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
            CallableStatement stmt = conn.prepareCall("{call sp_filtrar_facturas_efectivo()}");
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
            CallableStatement stmt = conn.prepareCall("{call sp_filtrar_facturas_tarjeta()}");
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
            CallableStatement stmt = conn.prepareCall("{CALL sp_filtrar_facturas_transferencia()}");
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
