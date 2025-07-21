package Models;

public class Factura {
    private String codigo;
    private String fecha;
    private String total;
    private String metodoPago;
    private String documentoCliente;
    private String nombreCliente;

    //Constructor
    public Factura(String codigo, String fecha, String total, String metodoPago, String documentoCliente, String nombreCliente ) {
        this.codigo = codigo;
        this.total = total;
        this.fecha = fecha;
        this.metodoPago = metodoPago;
        this.documentoCliente = documentoCliente;
        this.nombreCliente = nombreCliente;
    }

    //Getters
    public String getCodigo() { return codigo; }    
    public String getFecha() { return fecha; }  
    public String getTotal() { return total; }  
    public String getMetodoPago() { return metodoPago; }  
    public String getDocumentoCliente() { return documentoCliente; }  
    public String getNombreCliente() { return nombreCliente; }

}
