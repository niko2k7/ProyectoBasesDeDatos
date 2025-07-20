package Models;

public class DetalleFacturaServicio {
    private String id;
    private String nombre;
    private String precio;
    private String empleado_asociado;

    public DetalleFacturaServicio(String id, String nombre, String precio, String empleado_asociado ){
        this.id = id;
        this.nombre = nombre;
        this.precio = precio;
        this.empleado_asociado = empleado_asociado;
    }

    //Getters y setters.
    public String getId(){return id;}
    public String getNombre(){return nombre;}
    public String getPrecio(){return precio;}
    public String getEmpleadoAsociado(){return empleado_asociado;}
}
