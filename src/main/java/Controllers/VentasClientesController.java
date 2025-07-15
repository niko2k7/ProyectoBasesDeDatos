package Controllers;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import DataBase.DataBaseConnection;
import Models.Cliente;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.TableCell;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.HBox;
import javafx.util.Callback;


public class VentasClientesController {
    // Para cargar tabla
    @FXML private TableView<Cliente> tablaClientes;
    @FXML private TableColumn<Cliente, String> colDocumento;
    @FXML private TableColumn<Cliente, String> colNombre;
    @FXML private TableColumn<Cliente, String> colDireccion;
    @FXML private TableColumn<Cliente, String> colTelefono;
    @FXML private TableColumn<Cliente, String> colCorreo;
    @FXML private TableColumn<Cliente, String> colEstadoJuridico;
    @FXML private TableColumn<Cliente, Void> colAccion;
    // Para crear
    // Para actualizar
    @FXML private TextField crearClienteDocumento;
    @FXML private TextField crearClienteNombre;
    @FXML private TextField crearClienteDireccion;
    @FXML private TextField crearClienteTelefono;
    @FXML private TextField crearClienteCorreo;
    @FXML private TextField crearClienteEstadoJuridico;

    // Para actualizar
    @FXML private TextField actualizarClienteDocumento;
    @FXML private TextField actualizarClienteNombre;
    @FXML private TextField actualizarClienteDireccion;
    @FXML private TextField actualizarClienteTelefono;
    @FXML private TextField actualizarClienteCorreo;
    @FXML private TextField actualizarClienteEstadoJuridico;



    private ObservableList<Cliente> listaClientes = FXCollections.observableArrayList();

    @FXML
    public void initialize() {
        configurarColumnas();
        configurarColumnaAccion();
        cargarDatosDesdeBD();
        
    }

    private void configurarColumnas() {
        colDocumento.setCellValueFactory(new PropertyValueFactory<>("documento"));
        colNombre.setCellValueFactory(new PropertyValueFactory<>("nombre"));
        colDireccion.setCellValueFactory(new PropertyValueFactory<>("direccion"));
        colTelefono.setCellValueFactory(new PropertyValueFactory<>("telefono"));
        colCorreo.setCellValueFactory(new PropertyValueFactory<>("correo"));
        colEstadoJuridico.setCellValueFactory(new PropertyValueFactory<>("estadoJuridico"));
    }

    private void configurarColumnaAccion() {
        Callback<TableColumn<Cliente, Void>, TableCell<Cliente, Void>> cellFactory = new Callback<>() {
            @Override
            public TableCell<Cliente, Void> call(final TableColumn<Cliente, Void> param) {
                return new TableCell<>() {

                    private final Button btnEditar = new Button("Editar");
                    private final Button btnEliminar = new Button("Eliminar");

                    {
                        btnEditar.setOnAction(event -> {
                            Cliente cliente = getTableView().getItems().get(getIndex());
                            setCliente(cliente); // Llenar los campos de edición
                        });

                        btnEliminar.setOnAction(event -> {
                            Cliente cliente = getTableView().getItems().get(getIndex());
                            //eliminarCliente(cliente); // Método que debes implementar
                        });
                    }

                    private final HBox hbox = new HBox(10, btnEditar, btnEliminar); // Espaciado entre botones

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
    
    private void cargarDatosDesdeBD() {
        listaClientes.clear();

        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            // Usar
                // CallableStatement stmt = conn.prepareCall("{call obtener_clientes}");
                // ResultSet = stmt.executeQuery();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("select * from actor WHERE act_tipo = 'Cliente'");

            while (rs.next()) {
                Cliente cliente = new Cliente(
                    rs.getString("act_documento"),
                    rs.getString("act_nombre"),
                    rs.getString("act_direccion"),
                    rs.getString("act_telefono"),
                    rs.getString("act_correo"),
                    rs.getString("act_estado_juridico")
                );
                listaClientes.add(cliente);
            }

            tablaClientes.setItems(listaClientes);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @FXML
    private void crearCliente(){
        try {
        Connection conn = DataBaseConnection.getActiveConnection();
        PreparedStatement stmt = conn.prepareStatement(
            "INSERT INTO actor (act_documento, act_tipo, act_nombre, act_direccion, act_telefono, act_correo, act_estado_juridico) " +
            "VALUES (?, 'CLIENTE', ?, ?, ?, ?, ?)"
        );

        stmt.setInt(1, Integer.parseInt(crearClienteDocumento.getText())); // act_documento
        stmt.setString(2, crearClienteNombre.getText());                   // act_nombre
        stmt.setString(3, crearClienteDireccion.getText());               // act_direccion
        stmt.setString(4, crearClienteTelefono.getText());                // act_telefono
        stmt.setString(5, crearClienteCorreo.getText());                  // act_correo
        stmt.setString(6, crearClienteEstadoJuridico.getText());          // act_estado_juridico

        stmt.executeUpdate(); // Mejor que .execute() para INSERT

        cargarDatosDesdeBD(); // Para actualizar la tabla
    } catch (Exception e) {
        e.printStackTrace();
    }
    }

    public void setCliente(Cliente cliente) {
        actualizarClienteDocumento.setText(cliente.getDocumento());
        actualizarClienteNombre.setText(cliente.getNombre());
        actualizarClienteDireccion.setText(cliente.getDireccion());
        actualizarClienteTelefono.setText(cliente.getTelefono());
        actualizarClienteCorreo.setText(cliente.getCorreo());
        actualizarClienteEstadoJuridico.setText(cliente.getEstadoJuridico());
    }

    @FXML
    private void actualizarCliente(){
        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            // CallableStatement stmt = conn.prepareCall("{call actualizar_cliente(?, ?, ?, ?, ?, ?)}");
            PreparedStatement stmt = conn.prepareStatement(
                "UPDATE actor SET act_nombre = ?, act_direccion = ?, act_telefono = ?, act_correo = ?, act_estado_juridico = ? WHERE act_documento = ?"
            );

            stmt.setString(1, actualizarClienteNombre.getText());
            stmt.setString(2, actualizarClienteDireccion.getText());
            stmt.setString(3, actualizarClienteTelefono.getText());
            stmt.setString(4, actualizarClienteCorreo.getText());
            stmt.setString(5, actualizarClienteEstadoJuridico.getText());
            stmt.setString(6, actualizarClienteDocumento.getText()); // WHERE act_documento = ?

            stmt.executeUpdate(); // Mejor que .execute() para UPDATE

            cargarDatosDesdeBD();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
