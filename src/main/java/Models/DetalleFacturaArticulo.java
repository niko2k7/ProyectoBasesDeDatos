package Models;

public class DetalleFacturaArticulo {

    private String id;
    private String tipo;
    private String marca;
    private String modelo;
    private String precioUnitario;
    private String cantidad;
    private String subtotal;

    public DetalleFacturaArticulo(String id, String tipo, String marca, String modelo, String precioUnitario, String cantidad, String subtotal){
        this.id = id;
        this.tipo = tipo;
        this.marca = marca;
        this.modelo = modelo;
        this.precioUnitario = precioUnitario;
        this.cantidad = cantidad;
        this.subtotal = subtotal;
    }

    public String getId() {return id; }
    public String getTipo() {return tipo; }
    public String getMarca() {return marca; }
    public String getModelo() {return modelo; }
    public String getPrecioUnitario() {return precioUnitario; }
    public String getCantidad() {return cantidad; }
    public String getSubtotal() {return subtotal; }


}
