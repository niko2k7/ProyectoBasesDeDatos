package Controllers;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import DataBase.DataBaseConnection;
import Models.CuentaPorCobrar;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.cell.PropertyValueFactory;

public class VentasCuentasPorCobrarController {
    @FXML private TableView<CuentaPorCobrar> tablaCuentasPorCobrar;
    @FXML private TableColumn<CuentaPorCobrar, String> colId;
    @FXML private TableColumn<CuentaPorCobrar, String> colFechaEmision;
    @FXML private TableColumn<CuentaPorCobrar, String> colFechaVencimiento;
    @FXML private TableColumn<CuentaPorCobrar, String> colPlazo;
    @FXML private TableColumn<CuentaPorCobrar, String> colTotalDeuda;
    @FXML private TableColumn<CuentaPorCobrar, String> colTotalPagado;
    @FXML private TableColumn<CuentaPorCobrar, String> colEstadoCobro;
    @FXML private TableColumn<CuentaPorCobrar, String> colDocumento;
    @FXML private TableColumn<CuentaPorCobrar, String> colNombre;

    @FXML private TextField txtId;
    @FXML private TextField txtFechaEmision;
    @FXML private TextField txtDocumento;

    private ObservableList<CuentaPorCobrar> listaCuentas = FXCollections.observableArrayList();

    @FXML
    public void initialize(){
        configurarColumnasTabla();
        cargarDatosDesdeBD();
    }

    private void configurarColumnasTabla() {
        colId.setCellValueFactory(new PropertyValueFactory<>("id"));
        colFechaEmision.setCellValueFactory(new PropertyValueFactory<>("fechaEmision"));
        colFechaVencimiento.setCellValueFactory(new PropertyValueFactory<>("fechaVencimiento"));
        colPlazo.setCellValueFactory(new PropertyValueFactory<>("plazo"));
        colTotalDeuda.setCellValueFactory(new PropertyValueFactory<>("totalDeuda"));
        colTotalPagado.setCellValueFactory(new PropertyValueFactory<>("valorPagado"));
        colEstadoCobro.setCellValueFactory(new PropertyValueFactory<>("estadoCobro"));
        colDocumento.setCellValueFactory(new PropertyValueFactory<>("documento"));
        colNombre.setCellValueFactory(new PropertyValueFactory<>("nombre"));
    }

    private void cargarDatosDesdeBD(){
        listaCuentas.clear();
        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(
                "SELECT  cuenta_por_cobrar.cxc_id_cuenta, cxc_fecha_emision, plcob_fecha_vencimiento, plcob_plazo, cxc_total_deuda, plcob_valor_pagado, plcob_estado_cobro, actor.act_documento, actor.act_nombre " +
                "FROM CUENTA_POR_COBRAR JOIN PLAZO_COBRO ON CUENTA_POR_COBRAR.cxc_id_cuenta = PLAZO_COBRO.cxc_id_cuenta JOIN ACTOR ON CUENTA_POR_COBRAR.act_documento = actor.act_documento;");

            while (rs.next()) {
                CuentaPorCobrar cxc = new CuentaPorCobrar(
                    rs.getString("cxc_id_cuenta"),
                    rs.getString("cxc_fecha_emision"),
                    rs.getString("plcob_fecha_vencimiento"),
                    rs.getString("plcob_plazo"),
                    rs.getString("cxc_total_deuda"),
                    rs.getString("plcob_valor_pagado"),
                    rs.getString("plcob_estado_cobro"),
                    rs.getString("act_documento"),
                    rs.getString("act_nombre")
                );
                listaCuentas.add(cxc);
            }

            tablaCuentasPorCobrar.setItems(listaCuentas);
        } catch (Exception e) {
        }
    }

    // Búsquedas
    @FXML
    private void buscarPorId(){

    }
    @FXML
    private void buscarPorFechaEmision(){

    }
    @FXML
    private void buscarPorDocumento(){

    }
    @FXML
    private void filtrarVerTodas(){
        
    }
    @FXML
    private void filtrarEnCurso(){

    }
    @FXML
    private void filtrarVencidas(){
        
    }
    @FXML
    private void filtrarPagadas(){
        
    }
}