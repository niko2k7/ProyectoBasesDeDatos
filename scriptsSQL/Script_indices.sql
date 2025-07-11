USE proyecto_base_datos;
-- -----------------------------------------------------
-- Tabla ACTOR
-- -----------------------------------------------------

# útil para filtrar o agrupar actores por tipo (ej. "cliente", "proveedor", "empleado").
CREATE INDEX idx_actor_tipo ON ACTOR (act_tipo);
# optimiza consultas que clasifican o seleccionan actores según su condición legal (natural o jurídica).
CREATE INDEX idx_actor_estado_juridico ON ACTOR (act_estado_juridico);



-- -----------------------------------------------------
-- Tabla EMPLEADO
-- -----------------------------------------------------

# mejora la velocidad de búsquedas por tipo de puesto, especialmente en reportes de recursos humanos.
CREATE INDEX idx_empleado_puesto ON EMPLEADO (emp_puesto);



-- -----------------------------------------------------
-- Tabla PRODUCTO
-- -----------------------------------------------------

# útil para filtrar productos por tipo (materia prima, terminado, etc.), muy común en catálogos o inventarios.
CREATE INDEX idx_producto_tipo ON PRODUCTO (prod_tipo);



-- -----------------------------------------------------
-- Tabla FACTURA_VENTA
-- -----------------------------------------------------
# mejora rendimiento en reportes o análisis por fecha de venta.
CREATE INDEX idx_factura_venta_fecha ON FACTURA_VENTA (fven_fecha);
# acelera búsquedas de facturas emitidas a un cliente determinado.
CREATE INDEX idx_factura_venta_cliente ON FACTURA_VENTA (act_documento);



-- -----------------------------------------------------
-- Tabla DETALLE_FACTURA_VENTA
-- -----------------------------------------------------
# permite ubicar rápidamente en qué facturas se ha vendido un producto específico.
CREATE INDEX idx_dfv_producto ON DETALLE_FACTURA_VENTA (prod_id);
#mejora la eficiencia para listar todos los ítems de una factura.
CREATE INDEX idx_dfv_factura ON DETALLE_FACTURA_VENTA (fven_codigo);



-- -----------------------------------------------------
-- Tabla FACTURA_COMPRA
-- -----------------------------------------------------
# optimiza reportes de compras por períodos de tiempo.
CREATE INDEX idx_factura_compra_fecha ON FACTURA_COMPRA (fcom_fecha);
# útil para analizar compras hechas a un proveedor específico.
CREATE INDEX idx_factura_compra_proveedor ON FACTURA_COMPRA (act_documento);



-- -----------------------------------------------------
-- Tabla DETALLE_FACTURA_COMPRA
-- -----------------------------------------------------
# permite rastrear compras de un producto puntual.
CREATE INDEX idx_dfc_producto ON DETALLE_FACTURA_COMPRA (prod_id);
# mejora el rendimiento de consultas para listar productos asociados a una factura de compra.
CREATE INDEX idx_dfc_factura ON DETALLE_FACTURA_COMPRA (fcom_codigo);



-- -----------------------------------------------------
-- Tabla PAGO_SALARIO
-- -----------------------------------------------------
# muy útil para reportes de pagos mensuales, quincenales, etc.
CREATE INDEX idx_pago_salario_fecha ON PAGO_SALARIO (pag_fecha);



-- -----------------------------------------------------
-- Tabla CUENTA_POR_COBRAR
-- -----------------------------------------------------
# optimiza consultas sobre cuentas por cobrar según su fecha de emisión.
CREATE INDEX idx_cxc_fecha ON CUENTA_POR_COBRAR (cxc_fecha_emision);
# acelera la búsqueda de deudas por cliente.
CREATE INDEX idx_cxc_cliente ON CUENTA_POR_COBRAR (act_documento);



-- -----------------------------------------------------
-- Tabla CUENTA_POR_PAGAR
-- -----------------------------------------------------
# permite obtener fácilmente las cuentas pendientes según la fecha.
CREATE INDEX idx_cxp_fecha ON CUENTA_POR_PAGAR (cxp_fecha_emision);
# útil para consultar deudas asociadas a un proveedor específico.
CREATE INDEX idx_cxp_proveedor ON CUENTA_POR_PAGAR (act_documento);



-- -----------------------------------------------------
-- Tabla ARTICULO
-- -----------------------------------------------------
# mejora búsquedas en catálogos donde se filtra por marca y modelo, útil en sistemas de inventario o venta de artículos.
CREATE INDEX idx_articulo_marca_modelo ON ARTICULO (art_marca, art_modelo);



-- -----------------------------------------------------
-- Tabla SERVICIO
-- -----------------------------------------------------
# acelera búsquedas por nombre de servicio (consultas del tipo "buscar servicio de mantenimiento").
CREATE INDEX idx_servicio_nombre ON SERVICIO (serv_nombre);
# útil para saber qué empleado prestó o está asignado a un servicio específico.
CREATE INDEX idx_servicio_empleado ON SERVICIO (act_documento);



-- -----------------------------------------------------
-- Tabla SERVICIO_HAS_EMPLEADO
-- -----------------------------------------------------
# mejora consultas relacionadas con qué servicios ha realizado un empleado.
CREATE INDEX idx_she_empleado ON SERVICIO_HAS_EMPLEADO (act_documento);



-- -----------------------------------------------------
-- Tabla SERVICIO_HAS_MATERIAL_HERRAMIENTA
-- -----------------------------------------------------
# útil para listar materiales o herramientas usados en distintos servicios.
CREATE INDEX idx_shmh_herramienta ON SERVICIO_has_MATERIAL_HERRAMIENTA (mat_id);



-- -----------------------------------------------------
-- Tabla PLAZO_COBRO
-- -----------------------------------------------------
# optimiza la gestión de cuentas por cobrar según si están pendientes, pagadas, vencidas, etc.
CREATE INDEX idx_plazo_cobro_estado ON PLAZO_COBRO (plcob_estado_cobro);
# mejora consultas para encontrar cobros próximos a vencer o vencidos.
CREATE INDEX idx_plazo_cobro_fecha_venc ON PLAZO_COBRO (plcob_fecha_vencimiento);



-- -----------------------------------------------------
-- Tabla PLAZO_PAGO
-- -----------------------------------------------------
# útil para controlar pagos pendientes, realizados o atrasados.
CREATE INDEX idx_plazo_pago_estado ON PLAZO_PAGO (plpag_estado_pago);
# ayuda a prever vencimientos y planificar pagos futuros.
CREATE INDEX idx_plazo_pago_fecha_venc ON PLAZO_PAGO (plpag_fecha_vencimiento);
