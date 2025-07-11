USE proyecto_base_datos;
-- ALGUNOS EJEMPLOS DE UPDATE QUE PODRÍAN SER ÚTILES 

-- -----------------------------------------------------
-- Tabla ACTOR
-- -----------------------------------------------------
-- Actualizar atributos de la tabla actor.
UPDATE actor SET act_documento = 1122923772 WHERE act_documento = 1122123771; -- Se actualiza en cascada.
UPDATE actor SET act_nombre = 'nombre' WHERE act_documento = 1122123771;
UPDATE actor SET act_direccion = 'direccion' WHERE act_documento = 1122123771;
UPDATE actor SET act_telefono = '3201234567' WHERE act_documento = 1122123771;
UPDATE actor SET act_correo = 'correo' WHERE act_documento = 1122123771;

-- Borrar un actor. No tiene sentido borrar un solo atributo porque son no null
DELETE FROM actor WHERE act_documento = 1122923772; -- Se borra sin afectar ninguna otra tabla.

-- -----------------------------------------------------
-- Tabla CLIENTE
-- -----------------------------------------------------
-- No tiene atributos aparte de la FK, solo delete
DELETE FROM CLIENTE WHERE act_documento = 1122123771;

-- -----------------------------------------------------
-- Tabla PROVEEDOR
-- -----------------------------------------------------
-- No tiene atributos aparte de la FK, solo delete
DELETE FROM PROVEEDOR WHERE act_documento = 1122123771;
-- -----------------------------------------------------
-- Tabla EMPLEADO
-- -----------------------------------------------------
-- Actualizar el puesto de un empleado
UPDATE empleado SET emp_puesto = 'Gerente de Ventas' WHERE act_documento = 1122923772;
-- Borrar un empleado
DELETE FROM EMPLEADO WHERE act_documento = 1122123771;

-- -----------------------------------------------------
-- Tabla HORARIO_EMPLEADO
-- -----------------------------------------------------
UPDATE HORARIO_EMPLEADO SET hor_num_dias_laborales = 5 WHERE hor_id = 1 AND act_documento = 1122123771;
UPDATE HORARIO_EMPLEADO SET hor_hora_inicio = '08:00:00' WHERE hor_id = 1 AND act_documento = 1122123771;
UPDATE HORARIO_EMPLEADO SET hor_hora_fin = '17:00:00' WHERE hor_id = 1 AND act_documento = 1122123771;

DELETE FROM HORARIO_EMPLEADO WHERE hor_id = 1 AND act_documento = 1122123771;


-- -----------------------------------------------------
-- Tabla PRODUCTO
-- -----------------------------------------------------
UPDATE PRODUCTO SET prod_tipo = 'SERVICIO' WHERE prod_id = 1;
UPDATE PRODUCTO SET prod_precio = 150000.00 WHERE prod_id = 1;

DELETE FROM PRODUCTO WHERE prod_id = 1;


-- -----------------------------------------------------
-- Tabla FACTURA_VENTA
-- -----------------------------------------------------
UPDATE FACTURA_VENTA SET fven_fecha = '2025-07-11' WHERE fven_codigo = 1;
UPDATE FACTURA_VENTA SET fven_total = 500000.00 WHERE fven_codigo = 1;
UPDATE FACTURA_VENTA SET fven_metodo_pago = 'Transferencia' WHERE fven_codigo = 1;

DELETE FROM FACTURA_VENTA WHERE fven_codigo = 1;



-- -----------------------------------------------------
-- Tabla DETALLE_FACTURA_VENTA
-- -----------------------------------------------------
UPDATE DETALLE_FACTURA_VENTA SET dfv_cantidad = 10 WHERE fven_codigo = 1 AND prod_id = 1;
UPDATE DETALLE_FACTURA_VENTA SET dfv_precio_unitario = 50000.00 WHERE fven_codigo = 1 AND prod_id = 1;
UPDATE DETALLE_FACTURA_VENTA SET dfv_subtotal = 500000.00 WHERE fven_codigo = 1 AND prod_id = 1;

DELETE FROM DETALLE_FACTURA_VENTA WHERE fven_codigo = 1 AND prod_id = 1;


-- -----------------------------------------------------
-- Tabla FACTURA_COMPRA
-- -----------------------------------------------------
UPDATE FACTURA_COMPRA SET fcom_fecha = '2025-07-11' WHERE fcom_codigo = 1;
UPDATE FACTURA_COMPRA SET fcom_total = 600000.00 WHERE fcom_codigo = 1;
UPDATE FACTURA_COMPRA SET fcom_metodo_pago = 'Efectivo' WHERE fcom_codigo = 1;

DELETE FROM FACTURA_COMPRA WHERE fcom_codigo = 1;

-- -----------------------------------------------------
-- Tabla DETALLE_FACTURA_COMPRA
-- -----------------------------------------------------
UPDATE DETALLE_FACTURA_COMPRA SET dfc_cantidad = 20 WHERE fcom_codigo = 1 AND prod_id = 1;
UPDATE DETALLE_FACTURA_COMPRA SET dfc_precio_unitario = 30000.00 WHERE fcom_codigo = 1 AND prod_id = 1;
UPDATE DETALLE_FACTURA_COMPRA SET dfc_subtotal = 600000.00 WHERE fcom_codigo = 1 AND prod_id = 1;

DELETE FROM DETALLE_FACTURA_COMPRA WHERE fcom_codigo = 1 AND prod_id = 1;

-- -----------------------------------------------------
-- Tabla PAGO_SALARIO
-- -----------------------------------------------------
UPDATE PAGO_SALARIO SET pag_fecha = '2025-07-11' WHERE pag_numero_pago = 1;
UPDATE PAGO_SALARIO SET pag_salario_base = 1200000.00 WHERE pag_numero_pago = 1;
UPDATE PAGO_SALARIO SET pag_comisiones = 10 WHERE pag_numero_pago = 1;
UPDATE PAGO_SALARIO SET pag_anticipos = 200000.00 WHERE pag_numero_pago = 1;
UPDATE PAGO_SALARIO SET pag_total = 1000000.00 WHERE pag_numero_pago = 1;

DELETE FROM PAGO_SALARIO WHERE pag_numero_pago = 1;

-- -----------------------------------------------------
-- Tabla CUENTA_POR_COBRAR
-- -----------------------------------------------------
UPDATE CUENTA_POR_COBRAR SET cxc_fecha_emision = '2025-07-11' WHERE cxc_id_cuenta = 1;
UPDATE CUENTA_POR_COBRAR SET cxc_total_deuda = 800000.00 WHERE cxc_id_cuenta = 1;
UPDATE CUENTA_POR_COBRAR SET cxc_saldo = 300000.00 WHERE cxc_id_cuenta = 1;

DELETE FROM CUENTA_POR_COBRAR WHERE cxc_id_cuenta = 1;

-- -----------------------------------------------------
-- Tabla CUENTA_POR_PAGAR
-- -----------------------------------------------------
UPDATE CUENTA_POR_PAGAR SET cxp_fecha_emision = '2025-07-11' WHERE cxp_id_cuenta = 1;
UPDATE CUENTA_POR_PAGAR SET cxp_total_deuda = 1000000.00 WHERE cxp_id_cuenta = 1;
UPDATE CUENTA_POR_PAGAR SET cxp_saldo = 500000.00 WHERE cxp_id_cuenta = 1;

DELETE FROM CUENTA_POR_PAGAR WHERE cxp_id_cuenta = 1;

-- -----------------------------------------------------
-- Tabla ARTICULO
-- -----------------------------------------------------
# Disminuye la cantidad disponible del artículo con ID 1 en 10 unidades
UPDATE ARTICULO SET art_tipo = 'Nuevo tipo' WHERE prod_id = 1;
UPDATE ARTICULO SET art_marca = 'Nueva marca' WHERE prod_id = 1;
UPDATE ARTICULO SET art_modelo = 'Nuevo modelo' WHERE prod_id = 1;
UPDATE ARTICULO SET art_cantidad_disponible = 100 WHERE prod_id = 1;

DELETE FROM ARTICULO WHERE prod_id = 1;

-- -----------------------------------------------------
-- Tabla SERVICIO
-- -----------------------------------------------------
UPDATE SERVICIO SET serv_nombre = 'Instalación' WHERE prod_id = 1;
UPDATE SERVICIO SET serv_descripcion = 'Instalación completa del equipo' WHERE prod_id = 1;

DELETE FROM SERVICIO WHERE prod_id = 1;

-- -----------------------------------------------------
-- Tabla SERVICIO_HAS_EMPLEADO
-- -----------------------------------------------------
DELETE FROM SERVICIO_HAS_EMPLEADO WHERE prod_id = 1 AND act_documento = 1122123771;

-- -----------------------------------------------------
-- Tabla MATERIAL_HERRAMIENTA
-- -----------------------------------------------------
UPDATE MATERIAL_HERRAMIENTA SET mat_nombre = 'Taladro' WHERE mat_id = 1;
UPDATE MATERIAL_HERRAMIENTA SET mat_descripcion = 'Herramienta para perforar' WHERE mat_id = 1;
UPDATE MATERIAL_HERRAMIENTA SET mat_cantidad = 10 WHERE mat_id = 1;
UPDATE MATERIAL_HERRAMIENTA SET mat_costo = 150000.00 WHERE mat_id = 1;

DELETE FROM MATERIAL_HERRAMIENTA WHERE mat_id = 1;


-- -----------------------------------------------------
-- Tabla SERVICIO_has_MATERIAL_HERRAMIENTA
-- -----------------------------------------------------
DELETE FROM SERVICIO_HAS_MATERIAL_HERRAMIENTA WHERE prod_id = 1 AND mat_id = 1;


-- -----------------------------------------------------
-- Tabla PLAZO_COBRO
-- -----------------------------------------------------
UPDATE PLAZO_COBRO SET plcob_plazo = 30 WHERE plcob_id = 1 AND cxc_id_cuenta = 1;
UPDATE PLAZO_COBRO SET plcob_fecha_vencimiento = '2025-08-11' WHERE plcob_id = 1 AND cxc_id_cuenta = 1;
UPDATE PLAZO_COBRO SET plcob_valor_cuota = 100000.00 WHERE plcob_id = 1 AND cxc_id_cuenta = 1;
UPDATE PLAZO_COBRO SET plcob_valor_pagado = 50000.00 WHERE plcob_id = 1 AND cxc_id_cuenta = 1;
UPDATE PLAZO_COBRO SET plcob_estado_cobro = 'EN CURSO' WHERE plcob_id = 1 AND cxc_id_cuenta = 1;
UPDATE PLAZO_COBRO SET plcob_fecha_pago_final = '2025-09-11' WHERE plcob_id = 1 AND cxc_id_cuenta = 1;

DELETE FROM PLAZO_COBRO WHERE plcob_id = 1 AND cxc_id_cuenta = 1;


-- -----------------------------------------------------
-- Tabla PLAZO_PAGO
-- -----------------------------------------------------
UPDATE PLAZO_PAGO SET plpag_plazo = 45 WHERE plpag_id = 1 AND cxp_id_cuenta = 1;
UPDATE PLAZO_PAGO SET plpag_fecha_vencimiento = '2025-08-25' WHERE plpag_id = 1 AND cxp_id_cuenta = 1;
UPDATE PLAZO_PAGO SET plpag_valor_cuota = 200000.00 WHERE plpag_id = 1 AND cxp_id_cuenta = 1;
UPDATE PLAZO_PAGO SET plpag_valor_pagado = 100000.00 WHERE plpag_id = 1 AND cxp_id_cuenta = 1;
UPDATE PLAZO_PAGO SET plpag_estado_pago = 'EN CURSO' WHERE plpag_id = 1 AND cxp_id_cuenta = 1;
UPDATE PLAZO_PAGO SET plpag_fecha_pago_final = '2025-09-25' WHERE plpag_id = 1 AND cxp_id_cuenta = 1;

DELETE FROM PLAZO_PAGO WHERE plpag_id = 1 AND cxp_id_cuenta = 1;

