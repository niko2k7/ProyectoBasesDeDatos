package Controllers;

import java.util.Locale;

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

    }
    
    @FXML
    private void crearFactura(){

    }
}  
