package Models;

public class Articulo {
    private String id;
    private String tipo;
    private String marca;
    private String modelo;
    private String precio;
    private String stock;

    public Articulo(String id, String tipo, String marca, String modelo, String precio, String stock) {
        this.id = id;
        this.tipo = tipo;
        this.marca = marca;
        this.modelo = modelo;
        this.precio = precio;
        this.stock = stock;
    }


    // Getters y setters
    public String getId() { return id; }
    public String getTipo() { return tipo; }
    public String getMarca() { return marca; }
    public String getModelo() { return modelo; }
    public String getPrecio() { return precio; }
    public String getStock() { return stock;}
}
