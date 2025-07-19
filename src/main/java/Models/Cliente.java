package Models;

public class Cliente {
    private String documento;
    private String nombre;
    private String direccion;
    private String telefono;
    private String correo;
    private String estadoJuridico;

    public Cliente(String documento, String nombre, String direccion, String telefono, String correo, String estadoJuridico) {
        this.documento = documento;
        this.nombre = nombre;
        this.direccion = direccion;
        this.telefono = telefono;
        this.correo = correo;
        this.estadoJuridico = estadoJuridico;
    }

    // Getters
    public String getDocumento() { return documento; }
    public String getNombre() { return nombre; }
    public String getDireccion() { return direccion; }
    public String getTelefono() { return telefono; }
    public String getCorreo() { return correo; }
    public String getEstadoJuridico() { return estadoJuridico; }
}
