package Controllers;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;

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
            CallableStatement stmt = conn.prepareCall("{CALL sp_cargar_cuentas_por_cobrar()}");
            ResultSet rs = stmt.executeQuery();

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
    private void buscarPorId() {
        listaCuentas.clear();
        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            CallableStatement stmt = conn.prepareCall("{CALL sp_buscar_cuenta_por_id(?)}");
            stmt.setString(1, txtId.getText());

            ResultSet rs = stmt.executeQuery();

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
            e.printStackTrace();
        }
    }


    @FXML
    private void buscarPorFechaEmision() {
        listaCuentas.clear();
        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            CallableStatement stmt = conn.prepareCall("{CALL sp_buscar_cuenta_por_fecha_emision(?)}");
            stmt.setString(1, txtFechaEmision.getText());

            ResultSet rs = stmt.executeQuery();

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
            e.printStackTrace();
        }
    }


    @FXML
    private void buscarPorDocumento() {
        listaCuentas.clear();
        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            CallableStatement stmt = conn.prepareCall("{CALL sp_buscar_cuenta_por_documento(?)}");
            stmt.setString(1, txtDocumento.getText());

            ResultSet rs = stmt.executeQuery();

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
            e.printStackTrace();
        }
    }

    @FXML
    private void filtrarVerTodas(){
        cargarDatosDesdeBD();
    }

    @FXML
    private void filtrarEnCurso() {
        listaCuentas.clear();

        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            CallableStatement stmt = conn.prepareCall("{CALL sp_filtrar_cuentas_en_curso()}");

            ResultSet rs = stmt.executeQuery();

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
            e.printStackTrace();
        }
    }


    @FXML
    private void filtrarVencidas() {
        listaCuentas.clear();

        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            CallableStatement stmt = conn.prepareCall("{CALL sp_filtrar_cuentas_vencidas()}");

            ResultSet rs = stmt.executeQuery();

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
            e.printStackTrace();
        }
    }


    @FXML
    private void filtrarPagadas() {
        listaCuentas.clear();

        try {
            Connection conn = DataBaseConnection.getActiveConnection();
            CallableStatement stmt = conn.prepareCall("{CALL sp_filtrar_cuentas_pagadas()}");

            ResultSet rs = stmt.executeQuery();

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
            e.printStackTrace();
        }
    }

}