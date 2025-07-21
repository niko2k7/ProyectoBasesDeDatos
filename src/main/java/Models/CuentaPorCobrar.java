package Models;

public class CuentaPorCobrar {
    private String id;
    private  String fechaEmision;
    private  String fechaVencimiento;
    private  String plazo;
    private  String totalDeuda;
    private  String valorPagado;
    private  String estadoCobro;
    private  String documento;
    private  String nombre;

    public CuentaPorCobrar(String id, String fechaEmision, String fechaVencimiento, String plazo, String totalDeuda, String valorPagado, String estadoCobro, String documento, String nombre) {
        this.id = id;
        this.fechaEmision = fechaEmision;
        this.fechaVencimiento = fechaVencimiento;
        this.plazo = plazo;
        this.totalDeuda = totalDeuda;
        this.valorPagado = valorPagado;
        this.estadoCobro = estadoCobro;
        this.documento = documento;
        this.nombre = nombre;
    }

    public String getId() { return id; }
    public String getFechaEmision() { return fechaEmision; }
    public String getFechaVencimiento() { return fechaVencimiento; }
    public String getPlazo() { return plazo; }
    public String getTotalDeuda() { return totalDeuda; }
    public String getValorPagado() { return valorPagado; }
    public String getEstadoCobro() { return estadoCobro; }
    public String getDocumento() { return documento; }
    public String getNombre() { return nombre; }
}
