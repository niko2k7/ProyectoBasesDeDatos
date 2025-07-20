package Controllers;

import Models.Articulo;
import Models.Servicio;

public class VentasContexto {

    private static VentasContexto instancia;

    private VentasProductosController productoController;
    private VentasVerFacturasController verFacturaController;
    private VentasCrearFacturasController crearFacturaController;
    

    private VentasContexto() {}

    public static VentasContexto getInstancia() {
        if (instancia == null) {
            instancia = new VentasContexto();
        }
        return instancia;
    }

    public void setProductosController(VentasProductosController controller) {
        this.productoController = controller;
    }

    public void setVerFacturaController(VentasVerFacturasController controller) {
        this.verFacturaController = controller;
    }
    

    public void setCrearFacturaController(VentasCrearFacturasController controller) {
        this.crearFacturaController = controller;
    }

    public void recargarArticulos() {
        if (productoController != null) {
            productoController.cargarDatosArticuloDesdeBD();
        }
    }

    public void recargarFacturas() {
        if (verFacturaController != null) {
            verFacturaController.cargarDatosDesdeBD();
        }
    }
    public void agregarArticuloAFactura(Articulo articulo, int cantidad) {
        System.out.println("Se invoco agregarArticuloAFactura con cantidad = " + cantidad);
        if (crearFacturaController != null) {
            crearFacturaController.agregarDetalleArticulo(articulo, cantidad);
        } else {
            System.out.println("No hay controlador de factura activo");
        }
    }

    public void agregarServicioAFactura(Servicio servicio) {
    if (crearFacturaController != null) {
        crearFacturaController.agregarDetalleServicio(servicio);
    } else {
        System.out.println("No hay controlador de factura activo");
    }
}
}

