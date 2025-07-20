package Controllers;

import Models.Articulo;
import Models.Servicio;

public class VentasContexto {

    private static VentasContexto instancia;

    private VentasCrearFacturasController crearFacturaController;

    private VentasContexto() {}

    public static VentasContexto getInstancia() {
        if (instancia == null) {
            instancia = new VentasContexto();
        }
        return instancia;
    }

    public void setCrearFacturaController(VentasCrearFacturasController controller) {
        this.crearFacturaController = controller;
    }

    public void agregarArticuloAFactura(Articulo articulo, int cantidad) {
        System.out.println("🟢 Se invocó agregarArticuloAFactura con cantidad = " + cantidad);
        if (crearFacturaController != null) {
            crearFacturaController.agregarDetalleArticulo(articulo, cantidad);
        } else {
            System.out.println("⚠️ No hay controlador de factura activo");
        }
    }

    public void agregarServicioAFactura(Servicio servicio) {
    if (crearFacturaController != null) {
        crearFacturaController.agregarDetalleServicio(servicio);
    } else {
        System.out.println("⚠️ No hay controlador de factura activo");
    }
}
}

