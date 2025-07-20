package Controllers;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import DataBase.DataBaseConnection;
import Models.Articulo;
import Models.Servicio;
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

public class VentasProductosController {
    @FXML private TableView<Articulo> tablaArticulos;
    @FXML private TableColumn<Articulo, String> colArticuloId;
    @FXML private TableColumn<Articulo, String> colArticuloTipo;
    @FXML private TableColumn<Articulo, String> colArticuloMarca;
    @FXML private TableColumn<Articulo, String> colArticuloModelo;
    @FXML private TableColumn<Articulo, String> colArticuloPrecio;
    @FXML private TableColumn<Articulo, String> colArticuloStock;
    @FXML private TableColumn<Articulo, Void> colAccionArticulos;

    @FXML private TableView<Servicio> tablaServicios;
    @FXML private TableColumn<Servicio, String> colServicioId;
    @FXML private TableColumn<Servicio, String> colServicioNombre;
    @FXML private TableColumn<Servicio, String> colServicioPrecio;
    @FXML private TableColumn<Servicio, String> colServicioEmpleadoAsociado;
    @FXML private TableColumn<Servicio, Void> colAccionServicios;

    @FXML private TextField txtBuscarArticuloTipo;
    @FXML private TextField txtBuscarArticuloMarca;
    @FXML private TextField txtBuscarArticuloModelo;

    private ObservableList<Articulo> listaArticulos = FXCollections.observableArrayList();
    private ObservableList<Servicio> listaServicios = FXCollections.observableArrayList();

    @FXML
    public void initialize() {
        configurarColumnasTablaArticulos();
        cargarDatosArticuloDesdeBD(); 
        configurarColumnasTablaServicios();
        cargarDatosServicioDesdeBD(); 
        configurarColumnaAccionArticulos();
        configurarColumnaAccionServicios();
        VentasContexto.getInstancia().setProductosController(this);
    }

    private void configurarColumnasTablaArticulos() {
        colArticuloId.setCellValueFactory(new PropertyValueFactory<>("Id"));
        colArticuloTipo.setCellValueFactory(new PropertyValueFactory<>("Tipo"));
        colArticuloMarca.setCellValueFactory(new PropertyValueFactory<>("Marca"));
        colArticuloModelo.setCellValueFactory(new PropertyValueFactory<>("Modelo"));
        colArticuloPrecio.setCellValueFactory(new PropertyValueFactory<>("Precio"));
        colArticuloStock.setCellValueFactory(new PropertyValueFactory<>("Stock"));
    }

    private void configurarColumnaAccionArticulos() {
        Callback<TableColumn<Articulo, Void>, TableCell<Articulo, Void>> cellFactory = new Callback<>() {
            @Override
            public TableCell<Articulo, Void> call(final TableColumn<Articulo, Void> param) {
                return new TableCell<>() {
                    private final TextField txtCantidad = new TextField();
                    private final Button btnVender= new Button("Vender");
                    private final Button btnEliminar = new Button("Eliminar");

                    {
                        txtCantidad.setPromptText("Cant.");
                        txtCantidad.setPrefWidth(40);

                        btnVender.setOnAction(event -> {
                            Articulo articulo = getTableView().getItems().get(getIndex());
                            
                            try{
                                int cantidadCompra = Integer.parseInt(txtCantidad.getText());
                                int cantidadDisponible = Integer.parseInt(articulo.getStock());
                                if(cantidadCompra>0 && cantidadDisponible>=(cantidadCompra)){
                                    txtCantidad.setStyle("-fx-border-color: green;");
                                    VentasContexto.getInstancia().agregarArticuloAFactura(articulo, cantidadCompra);
                                    txtCantidad.clear();
                                }else{
                                    txtCantidad.setStyle("-fx-border-color: red;");
                                    System.out.println("no hay stock suficiente");
                                }
                            }catch(NumberFormatException e){
                                txtCantidad.setStyle("-fx-border-color: red;");
                                System.out.println("Ingrese un numero valido");
                            }
                        });

                        btnEliminar.setOnAction(event -> {
                            Articulo articulo = getTableView().getItems().get(getIndex());
                            eliminarArticulo(articulo); // Método que debes implementar
                        });
                    }

                    private final HBox hbox = new HBox(5, txtCantidad, btnVender, btnEliminar); // Espaciado entre botones

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
        colAccionArticulos.setCellFactory(cellFactory);
    }

    
    public void cargarDatosArticuloDesdeBD() {
        listaArticulos.clear();

        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            // Usar
                // CallableStatement stmt = conn.prepareCall("{call obtener_clientes}");
                // ResultSet = stmt.executeQuery();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(
                "SELECT prod_id, art_tipo, art_marca, art_modelo, prod_precio, art_cantidad_disponible FROM producto NATURAL JOIN articulo");

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

    private void configurarColumnasTablaServicios() {
        colServicioId.setCellValueFactory(new PropertyValueFactory<>("Id"));
        colServicioNombre.setCellValueFactory(new PropertyValueFactory<>("Nombre"));
        colServicioPrecio.setCellValueFactory(new PropertyValueFactory<>("Precio"));
        colServicioEmpleadoAsociado.setCellValueFactory(new PropertyValueFactory<>("empleadoAsociado"));
    }

    private void configurarColumnaAccionServicios() {
        Callback<TableColumn<Servicio, Void>, TableCell<Servicio, Void>> cellFactory = new Callback<>() {
            @Override
            public TableCell<Servicio, Void> call(final TableColumn<Servicio, Void> param) {
                return new TableCell<>() {
                    
                    private final Button btnVender= new Button("Añadir");
                    private final Button btnEliminar = new Button("Eliminar");

                    {
                        btnVender.setOnAction(event -> {
                            Servicio servicio = getTableView().getItems().get(getIndex());
                            VentasContexto.getInstancia().agregarServicioAFactura(servicio);
                        });

                        btnEliminar.setOnAction(event -> {
                            Servicio servicio = getTableView().getItems().get(getIndex());
                            eliminarServicio(servicio);
                        });

                        
                    }

                    private final HBox hbox = new HBox(5, btnVender, btnEliminar); // Espaciado entre botones

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
        colAccionServicios.setCellFactory(cellFactory);
    }

    public void cargarDatosServicioDesdeBD() {
        listaServicios.clear();

        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            // Usar
                // CallableStatement stmt = conn.prepareCall("{call obtener_clientes}");
                // ResultSet = stmt.executeQuery();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(
                "select prod_id, serv_nombre, prod_precio, act_nombre from producto natural join servicio natural join actor");

            while (rs.next()) {
                Servicio servicio = new Servicio(
                    rs.getString("prod_id"),
                    rs.getString("serv_nombre"),
                    rs.getString("prod_precio"),
                    rs.getString("act_nombre")
                );
                listaServicios.add(servicio);
            }

            tablaServicios.setItems(listaServicios);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    // Eliminación
    private void eliminarArticulo(Articulo articulo){
        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            PreparedStatement stmt = conn.prepareStatement(
            "DELETE FROM articulo WHERE prod_id=  ?"
            );
            stmt.setInt(1, Integer.parseInt(articulo.getId()));
            stmt.executeUpdate();
            // llamar trigger que borre lo relacionado al articulo, pero no dejará porque es interfaz de ventas y no tiene permiso de borrado
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Intento de borrado un articulo sin los permisos necesarios.");
        }
    }

    private void eliminarServicio(Servicio servicio){
        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            PreparedStatement stmt = conn.prepareStatement(
            "DELETE FROM servicio WHERE prod_id= ?"
            );
            stmt.setInt(1, Integer.parseInt(servicio.getId()));
            stmt.executeUpdate();
            // llamar trigger que borre lo relacionado al servicio, pero no dejará porque es interfaz de ventas y no tiene permiso de borrado
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Intento de borrado un servicio sin los permisos necesarios.");
        }
    }

    // Búsquedas
    @FXML
    private void buscarArticuloTipo(){
        listaArticulos.clear();

        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            // Usar
                // CallableStatement stmt = conn.prepareCall("{call obtener_clientes}");
                // ResultSet = stmt.executeQuery();
            PreparedStatement stmt = conn.prepareStatement(
            "SELECT prod_id, art_tipo, art_marca, art_modelo, prod_precio, art_cantidad_disponible " +
            "FROM producto NATURAL JOIN articulo WHERE art_tipo LIKE ?"
            );
            stmt.setString(1, "%" + txtBuscarArticuloTipo.getText() + "%"); // Búsqueda parcial

            ResultSet rs = stmt.executeQuery();

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
            txtBuscarArticuloTipo.clear();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    @FXML
    private void buscarArticuloMarca(){
        listaArticulos.clear();

        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            // Usar
                // CallableStatement stmt = conn.prepareCall("{call obtener_clientes}");
                // ResultSet = stmt.executeQuery();
            PreparedStatement stmt = conn.prepareStatement(
            "SELECT prod_id, art_tipo, art_marca, art_modelo, prod_precio, art_cantidad_disponible " +
            "FROM producto NATURAL JOIN articulo WHERE art_marca LIKE ?"
            );
            stmt.setString(1, "%" + txtBuscarArticuloMarca.getText() + "%"); // Búsqueda parcial

            ResultSet rs = stmt.executeQuery();

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
            txtBuscarArticuloMarca.clear();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    @FXML
    private void buscarArticuloModelo(){
        listaArticulos.clear();

        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            // Usar
                // CallableStatement stmt = conn.prepareCall("{call obtener_clientes}");
                // ResultSet = stmt.executeQuery();
            PreparedStatement stmt = conn.prepareStatement(
            "SELECT prod_id, art_tipo, art_marca, art_modelo, prod_precio, art_cantidad_disponible " +
            "FROM producto NATURAL JOIN articulo WHERE art_modelo LIKE ?"
            );
            stmt.setString(1, "%" + txtBuscarArticuloModelo.getText() + "%"); // Búsqueda parcial

            ResultSet rs = stmt.executeQuery();

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
            txtBuscarArticuloModelo.clear();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    // Filtros
    @FXML
    private void filtrarVerTodos(){
        cargarDatosArticuloDesdeBD();
    }

    @FXML
    private void filtrarStockCritico(){
        listaArticulos.clear();

        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            // Usar
                // CallableStatement stmt = conn.prepareCall("{call obtener_clientes}");
                // ResultSet = stmt.executeQuery();
            PreparedStatement stmt = conn.prepareStatement(
            "SELECT prod_id, art_tipo, art_marca, art_modelo, prod_precio, art_cantidad_disponible " +
            "FROM producto NATURAL JOIN articulo WHERE art_cantidad_disponible <= 10"
            );

            ResultSet rs = stmt.executeQuery();

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
            txtBuscarArticuloTipo.clear();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @FXML
    private void filtrarSinStock(){
        listaArticulos.clear();

        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            // Usar
                // CallableStatement stmt = conn.prepareCall("{call obtener_clientes}");
                // ResultSet = stmt.executeQuery();
            PreparedStatement stmt = conn.prepareStatement(
            "SELECT prod_id, art_tipo, art_marca, art_modelo, prod_precio, art_cantidad_disponible " +
            "FROM producto NATURAL JOIN articulo WHERE art_cantidad_disponible = 0"
            );

            ResultSet rs = stmt.executeQuery();

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
            txtBuscarArticuloTipo.clear();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
