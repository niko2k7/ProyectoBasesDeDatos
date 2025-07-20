package Controllers;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Locale;

import DataBase.DataBaseConnection;
import Models.Articulo;
import Models.DetalleFacturaArticulo;
import Models.DetalleFacturaServicio;
import Models.Servicio;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.cell.PropertyValueFactory;

public class VentasCrearFacturasController {
    @FXML private TableView<DetalleFacturaArticulo> tablaDetalleFacturaArticulos;
    @FXML private TableColumn<DetalleFacturaArticulo, String> colArticuloId;
    @FXML private TableColumn<DetalleFacturaArticulo, String> colArticuloTipo;
    @FXML private TableColumn<DetalleFacturaArticulo, String> colArticuloMarca;
    @FXML private TableColumn<DetalleFacturaArticulo, String> colArticuloModelo;
    @FXML private TableColumn<DetalleFacturaArticulo, String> colArticuloPrecioUnitario;
    @FXML private TableColumn<DetalleFacturaArticulo, String> colArticuloCantidad;
    @FXML private TableColumn<DetalleFacturaArticulo, String> colArticuloSubtotal;
    @FXML private TableColumn<DetalleFacturaArticulo, Void> colAccionArticulos;
    
    @FXML private TableView<DetalleFacturaServicio> tablaDetalleFacturaServicios;
    @FXML private TableColumn<DetalleFacturaServicio, String> colServicioId;
    @FXML private TableColumn<DetalleFacturaServicio, String> colServicioNombre;
    @FXML private TableColumn<DetalleFacturaServicio, String> colServicioPrecio;
    @FXML private TableColumn<DetalleFacturaServicio, String> colServicioEmpleadoAsociado;
    @FXML private TableColumn<DetalleFacturaServicio, Void> colAccionServicios;

    @FXML private TextField txtDocumento;
    @FXML private TextField txtNombre;
    @FXML private TextField txtDireccion;
    @FXML private TextField txtTelefono;
    @FXML private TextField txtCorreo;
    @FXML private TextField txtEstadoJuridico;
    @FXML private TextField txtMetodoPago;
    @FXML private TextField txtTotal;

    private ObservableList<DetalleFacturaArticulo> detalleFacturaArticulos = FXCollections.observableArrayList();
    private ObservableList<DetalleFacturaServicio> detalleFacturaServicios = FXCollections.observableArrayList();

    

    @FXML
    public void initialize() {
        VentasContexto.getInstancia().setCrearFacturaController(this);
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

    public void agregarDetalleArticulo(Articulo articulo, int cantidad) {
        try {
            // Obtener los datos como strings
            String id = articulo.getId();
            String tipo = articulo.getTipo();
            String marca = articulo.getMarca();
            String modelo = articulo.getModelo();
            String precio = articulo.getPrecio();

            // Convertir precio a double para cálculo
            double precioD = Double.parseDouble(precio.replace(",", "."));

            double subtotal = precioD * cantidad;

            // Formatear valores como String para el constructor de DetalleFacturaArticulo
            String precioStr = String.format("%.2f", precioD);
            String cantidadStr = String.valueOf(cantidad);
            String subtotalStr = String.format(Locale.US, "%.2f", subtotal);

            // Crear y agregar el detalle
            DetalleFacturaArticulo detalle = new DetalleFacturaArticulo(
                id, tipo, marca, modelo, precioStr, cantidadStr, subtotalStr
            );

            detalleFacturaArticulos.add(detalle);
            actualizarTotalFactura();
        } catch (NumberFormatException e) {
            System.err.println("Error al convertir el precio: " + e.getMessage());
            // Puedes agregar un mensaje en la UI o registrar el error según necesites
        }
    }


    private void configurarColumnasTablaServicios() {
        colServicioId.setCellValueFactory(new PropertyValueFactory<>("Id"));
        colServicioNombre.setCellValueFactory(new PropertyValueFactory<>("Nombre"));
        colServicioPrecio.setCellValueFactory(new PropertyValueFactory<>("Precio"));
        colServicioEmpleadoAsociado.setCellValueFactory(new PropertyValueFactory<>("empleadoAsociado"));
    }

    public void agregarDetalleServicio(Servicio servicio) {
        try {
            // Obtener los datos como strings
            String id = servicio.getId();
            String nombre = servicio.getNombre();
            String precioStr = servicio.getPrecio();
            String empleadoAsociado = servicio.getEmpleadoAsociado();

            // Crear y agregar el detalle
            DetalleFacturaServicio detalle = new DetalleFacturaServicio(
                id, nombre, precioStr, empleadoAsociado
            );
          
            detalleFacturaServicios.add(detalle);
            actualizarTotalFactura();
        } catch (NumberFormatException e) {
            System.err.println("Error al convertir el precio: " + e.getMessage());
            // Puedes agregar un mensaje en la UI o registrar el error según necesites
        }
    }

    public void actualizarTotalFactura() {
    double total = 0.0;

    // Sumar subtotales de artículos
        for (DetalleFacturaArticulo articulo : detalleFacturaArticulos) {
            try {
                double subtotal = Double.parseDouble(articulo.getSubtotal());
                total += subtotal;
            } catch (NumberFormatException e) {
                System.err.println("Error en subtotal artículo: " + e.getMessage());
            }
        }

        // Sumar precios de servicios
        for (DetalleFacturaServicio servicio : detalleFacturaServicios) {
            try {
                double precio = Double.parseDouble(servicio.getPrecio());
                total += precio;
            } catch (NumberFormatException e) {
                System.err.println("Error en precio servicio: " + e.getMessage());
            }
        }

        // Mostrar el total en el TextField
        txtTotal.setText(String.format("%.2f", total));
    }

    @FXML
    private void cargarCliente(){
        String documento = txtDocumento.getText();

            if (documento.isEmpty()) {
                System.out.println("⚠️ Debes ingresar un documento.");
                return;
            }

            try {
                Connection conn = DataBaseConnection.getActiveConnection();
                // Usar
                    // CallableStatement stmt = conn.prepareCall("{call obtener_clientes}");
                    // ResultSet = stmt.executeQuery();
                PreparedStatement stmt = conn.prepareStatement(
                "SELECT act_nombre, act_direccion, act_telefono, act_correo, act_estado_juridico "
                + "FROM actor WHERE act_documento = ?"
                );
                stmt.setString(1, documento);

                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                            txtNombre.setText(rs.getString("act_nombre"));
                            txtDireccion.setText(rs.getString("act_direccion"));
                            txtTelefono.setText(rs.getString("act_telefono"));
                            txtCorreo.setText(rs.getString("act_correo"));
                            txtEstadoJuridico.setText(rs.getString("act_estado_juridico"));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
            
    
    
    @FXML
    private void crearFactura() {
        Connection conn = null;

        try {
            conn = DataBaseConnection.getActiveConnection();
            conn.setAutoCommit(false);

            // Obtener datos del cliente y total
            int documentoCliente = Integer.parseInt(txtDocumento.getText());
            BigDecimal totalFactura = new BigDecimal(txtTotal.getText().replace(",", "."));

            // 1. Crear factura
            CallableStatement stmtFactura = conn.prepareCall("{call crear_factura_venta(?, ?, ?, ?, ?)}");
            stmtFactura.setDate(1, new java.sql.Date(System.currentTimeMillis()));
            stmtFactura.setBigDecimal(2, totalFactura);
            stmtFactura.setString(3, txtMetodoPago.getText());
            stmtFactura.setInt(4, documentoCliente);
            stmtFactura.registerOutParameter(5, Types.INTEGER);
            stmtFactura.execute();

            int idFactura = stmtFactura.getInt(5);

            // 2. Insertar detalles de artículos
            for (DetalleFacturaArticulo detalle : detalleFacturaArticulos) {
                CallableStatement stmtDetalle = conn.prepareCall("{call agregar_detalle_factura(?, ?, ?, ?, ?)}");
                stmtDetalle.setInt(1, idFactura);
                stmtDetalle.setInt(2, Integer.parseInt(detalle.getId()));
                stmtDetalle.setInt(3, Integer.parseInt(detalle.getCantidad()));
                stmtDetalle.setBigDecimal(4, new BigDecimal(detalle.getPrecioUnitario().replace(",", ".")));
                stmtDetalle.setBigDecimal(5, new BigDecimal(detalle.getSubtotal().replace(",", ".")));
                stmtDetalle.execute();
            }

            // 3. Insertar detalles de servicios
            for (DetalleFacturaServicio servicio : detalleFacturaServicios) {
                CallableStatement stmtDetalle = conn.prepareCall("{call agregar_detalle_factura(?, ?, ?, ?, ?)}");
                stmtDetalle.setInt(1, idFactura);
                stmtDetalle.setInt(2, Integer.parseInt(servicio.getId()));
                stmtDetalle.setInt(3, 1); // Servicios suelen tener cantidad 1
                stmtDetalle.setBigDecimal(4, new BigDecimal(servicio.getPrecio().replace(",", ".")));
                stmtDetalle.setBigDecimal(5, new BigDecimal(servicio.getPrecio().replace(",", "."))); // subtotal = precio
                stmtDetalle.execute();
            }

            conn.commit();
            System.out.println("Factura creada exitosamente.");

            // Limpiar campos
            txtDocumento.clear();
            txtNombre.clear();
            txtDireccion.clear();
            txtTelefono.clear();
            txtCorreo.clear();
            txtEstadoJuridico.clear();
            txtMetodoPago.clear();
            txtTotal.clear();

            // Limpiar tablas
            detalleFacturaArticulos.clear();
            detalleFacturaServicios.clear();

            //Actualizar tablas de productos y facturas.
            VentasContexto.getInstancia().recargarArticulos();
            VentasContexto.getInstancia().recargarFacturas();

        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            System.out.println("Error al crear la factura.");
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}  
