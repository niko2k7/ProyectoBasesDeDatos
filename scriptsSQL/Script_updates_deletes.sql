USE proyecto_base_datos;
-- ALGUNOS EJEMPLOS DE UPDATE QUE PODRÍAN SER ÚTILES 

-- -----------------------------------------------------
-- Tabla ACTOR
-- -----------------------------------------------------
UPDATE ACTOR SET act_documento = '1122923772' WHERE act_documento = 1122123771;
UPDATE ACTOR SET act_nombre = 'nombre' WHERE act_documento = 1122123771;
UPDATE ACTOR SET act_direccion = 'direccion' WHERE act_documento = 1122123771;
UPDATE ACTOR SET act_telefono = '3201234567' WHERE act_documento = 1122123771;
UPDATE ACTOR SET act_correo = 'correo' WHERE act_documento = 1122123771;


-- -----------------------------------------------------
-- Tabla CLIENTE
-- -----------------------------------------------------
# Cambia el documento del cliente de 1001 a 1002
UPDATE CLIENTE SET act_documento = 1002 WHERE act_documento = 1001;

# Cambia el documento del cliente de 1002 a 1003
UPDATE CLIENTE SET act_documento = 1003 WHERE act_documento = 1002;

-- -----------------------------------------------------
-- Tabla PROVEEDOR
-- -----------------------------------------------------
# Cambia el documento del proveedor de 2001 a 2002
UPDATE PROVEEDOR SET act_documento = 2002 WHERE act_documento = 2001;

# Cambia el documento del proveedor de 2002 a 2003
UPDATE PROVEEDOR SET act_documento = 2003 WHERE act_documento = 2002;

-- -----------------------------------------------------
-- Tabla EMPLEADO
-- -----------------------------------------------------
# Asigna el puesto "Gerente de Ventas" al empleado con documento 3001
UPDATE EMPLEADO SET emp_puesto = 'Gerente de Ventas' WHERE act_documento = 3001;

# Asigna el puesto "Asistente Administrativo" al empleado con documento 3002
UPDATE EMPLEADO SET emp_puesto = 'Asistente Administrativo' WHERE act_documento = 3002;

-- -----------------------------------------------------
-- Tabla HORARIO_EMPLEADO
-- -----------------------------------------------------
# Establece el horario laboral de 8 a.m. a 5 p.m. para el horario 1 del empleado 3001
UPDATE HORARIO_EMPLEADO SET hor_hora_inicio = '08:00:00', hor_hora_fin = '17:00:00' WHERE hor_id = 1 AND act_documento = 3001;

# Cambia el número de días laborales a 6 para el horario 2 del empleado 3002
UPDATE HORARIO_EMPLEADO SET hor_num_dias_laborales = 6 WHERE hor_id = 2 AND act_documento = 3002;

-- -----------------------------------------------------
-- Tabla PRODUCTO
-- -----------------------------------------------------
# Incrementa en 10% el precio de los productos tipo ARTICULO
UPDATE PRODUCTO SET prod_precio = prod_precio * 1.1 WHERE prod_tipo = 'ARTICULO';

# Establece el precio del producto con ID 9999 a 0 (posiblemente desactivado o gratuito)
UPDATE PRODUCTO SET prod_precio = 0 WHERE prod_id = 9999;

-- -----------------------------------------------------
-- Tabla FACTURA_VENTA
-- -----------------------------------------------------
# Cambia el método de pago a "TRANSFERENCIA" en la factura de venta 1
UPDATE FACTURA_VENTA SET fven_metodo_pago = 'TRANSFERENCIA' WHERE fven_codigo = 1;

# Actualiza el total de la factura de venta 2 a 150000
UPDATE FACTURA_VENTA SET fven_total = 150000 WHERE fven_codigo = 2;

-- -----------------------------------------------------
-- Tabla DETALLE_FACTURA_VENTA
-- -----------------------------------------------------
# Cambia la cantidad del producto 10 a 5 en la factura de venta 1
UPDATE DETALLE_FACTURA_VENTA SET dfv_cantidad = 5 WHERE fven_codigo = 1 AND prod_id = 10;

# Establece el precio unitario del producto 15 en la factura 2 a 20000
UPDATE DETALLE_FACTURA_VENTA SET dfv_precio_unitario = 20000 WHERE fven_codigo = 2 AND prod_id = 15;

-- -----------------------------------------------------
-- Tabla FACTURA_COMPRA
-- -----------------------------------------------------
# Cambia el método de pago a "EFECTIVO" en la factura de compra 1
UPDATE FACTURA_COMPRA SET fcom_metodo_pago = 'EFECTIVO' WHERE fcom_codigo = 1;

# Actualiza el total de la factura de compra 2 a 500000
UPDATE FACTURA_COMPRA SET fcom_total = 500000 WHERE fcom_codigo = 2;

-- -----------------------------------------------------
-- Tabla DETALLE_FACTURA_COMPRA
-- -----------------------------------------------------
# Cambia la cantidad del producto 20 a 100 en la factura de compra 1
UPDATE DETALLE_FACTURA_COMPRA SET dfc_cantidad = 100 WHERE fcom_codigo = 1 AND prod_id = 20;

# Establece el subtotal del producto 25 en la factura de compra 2 a 200000
UPDATE DETALLE_FACTURA_COMPRA SET dfc_subtotal = 200000 WHERE fcom_codigo = 2 AND prod_id = 25;

-- -----------------------------------------------------
-- Tabla PAGO_SALARIO
-- -----------------------------------------------------
# Actualiza los anticipos a 30000 en el pago salarial número 1
UPDATE PAGO_SALARIO SET pag_anticipos = 30000 WHERE pag_numero_pago = 1;

# Establece las comisiones a 15 en el pago salarial número 2
UPDATE PAGO_SALARIO SET pag_comisiones = 15 WHERE pag_numero_pago = 2;

-- -----------------------------------------------------
-- Tabla CUENTA_POR_COBRAR
-- -----------------------------------------------------
# Establece el saldo en 0 para la cuenta por cobrar 1 (ya cobrada)
UPDATE CUENTA_POR_COBRAR SET cxc_saldo = 0 WHERE cxc_id_cuenta = 1;

# Actualiza el total de deuda a 120000 para la cuenta por cobrar 2
UPDATE CUENTA_POR_COBRAR SET cxc_total_deuda = 120000 WHERE cxc_id_cuenta = 2;

-- -----------------------------------------------------
-- Tabla CUENTA_POR_PAGAR
-- -----------------------------------------------------
# Resta 50000 al saldo de la cuenta por pagar 1
UPDATE CUENTA_POR_PAGAR SET cxp_saldo = cxp_saldo - 50000 WHERE cxp_id_cuenta = 1;

# Establece el total de deuda a 300000 para la cuenta por pagar 2
UPDATE CUENTA_POR_PAGAR SET cxp_total_deuda = 300000 WHERE cxp_id_cuenta = 2;

-- -----------------------------------------------------
-- Tabla ARTICULO
-- -----------------------------------------------------
# Disminuye la cantidad disponible del artículo con ID 1 en 10 unidades
UPDATE ARTICULO SET art_cantidad_disponible = art_cantidad_disponible - 10 WHERE prod_id = 1;

# Cambia la marca del artículo con ID 2 a "NuevaMarca"
UPDATE ARTICULO SET art_marca = 'NuevaMarca' WHERE prod_id = 2;

-- -----------------------------------------------------
-- Tabla SERVICIO
-- -----------------------------------------------------
# Cambia el nombre del servicio con ID 3 a "Mantenimiento Avanzado"
UPDATE SERVICIO SET serv_nombre = 'Mantenimiento Avanzado' WHERE prod_id = 3;

# Actualiza la descripción del servicio con ID 4
UPDATE SERVICIO SET serv_descripcion = 'Revisión general y ajuste técnico' WHERE prod_id = 4;

-- -----------------------------------------------------
-- Tabla SERVICIO_HAS_EMPLEADO
-- -----------------------------------------------------
# Asigna el empleado 3004 al servicio 3 (antes era 3001)
UPDATE SERVICIO_HAS_EMPLEADO SET act_documento = 3004 WHERE prod_id = 3 AND act_documento = 3001;

# Asigna el empleado 3005 al servicio 4 (antes era 3002)
UPDATE SERVICIO_HAS_EMPLEADO SET act_documento = 3005 WHERE prod_id = 4 AND act_documento = 3002;

-- -----------------------------------------------------
-- Tabla MATERIAL_HERRAMIENTA
-- -----------------------------------------------------
# Disminuye en 2 la cantidad del material con ID 1
UPDATE MATERIAL_HERRAMIENTA SET mat_cantidad = mat_cantidad - 2 WHERE mat_id = 1;

# Cambia el costo del material con ID 2 a 150000
UPDATE MATERIAL_HERRAMIENTA SET mat_costo = 150000 WHERE mat_id = 2;

-- -----------------------------------------------------
-- Tabla SERVICIO_has_MATERIAL_HERRAMIENTA
-- -----------------------------------------------------
# Reemplaza el material 1 por el material 3 en el servicio 3
UPDATE SERVICIO_has_MATERIAL_HERRAMIENTA SET mat_id = 3 WHERE prod_id = 3 AND mat_id = 1;

# Reemplaza el material 2 por el material 4 en el servicio 4
UPDATE SERVICIO_has_MATERIAL_HERRAMIENTA SET mat_id = 4 WHERE prod_id = 4 AND mat_id = 2;

-- -----------------------------------------------------
-- Tabla PLAZO_COBRO
-- -----------------------------------------------------
# Marca como "PAGADO" el plazo de cobro 1 y actualiza la fecha final al día actual
UPDATE PLAZO_COBRO SET plcob_estado_cobro = 'PAGADO', plcob_fecha_pago_final = CURRENT_DATE WHERE plcob_id = 1 AND cxc_id_cuenta = 1;

# Actualiza el valor pagado a 75000 en el plazo de cobro 2
UPDATE PLAZO_COBRO SET plcob_valor_pagado = 75000 WHERE plcob_id = 2 AND cxc_id_cuenta = 2;

-- -----------------------------------------------------
-- Tabla PLAZO_PAGO
-- -----------------------------------------------------
# Cambia el estado de pago del plazo 1 a "EN CURSO"
UPDATE PLAZO_PAGO SET plpag_estado_pago = 'EN CURSO' WHERE plpag_id = 1 AND cxp_id_cuenta = 1;

# Establece el valor pagado a 200000 en el plazo de pago 2
UPDATE PLAZO_PAGO SET plpag_valor_pagado = 200000 WHERE plpag_id = 2 AND cxp_id_cuenta = 2;



-- ALGUNOS EJEMPLOS DE DELETE QUE PODRÍAN SER ÚTILES

-- -----------------------------------------------------
-- Tabla ACTOR
-- -----------------------------------------------------
# Elimina el actor con documento 9999 (posiblemente un registro de prueba)
DELETE FROM ACTOR WHERE act_documento = 9999;

# Elimina los actores cuyo número de teléfono está vacío o nulo
DELETE FROM ACTOR WHERE act_telefono IS NULL OR act_telefono = '';

-- -----------------------------------------------------
-- Tabla CLIENTE
-- -----------------------------------------------------
# Elimina el cliente con documento 8888 (registro de prueba o incorrecto)
DELETE FROM CLIENTE WHERE act_documento = 8888;

# Elimina todos los clientes que no han realizado compras (no tienen facturas)
DELETE FROM CLIENTE WHERE act_documento NOT IN (
    SELECT act_documento FROM FACTURA_VENTA
);

-- -----------------------------------------------------
-- Tabla PROVEEDOR
-- -----------------------------------------------------
# Elimina al proveedor con documento 7777
DELETE FROM PROVEEDOR WHERE act_documento = 7777;

# Elimina proveedores sin facturas de compra registradas
DELETE FROM PROVEEDOR WHERE act_documento NOT IN (
    SELECT act_documento FROM FACTURA_COMPRA
);

-- -----------------------------------------------------
-- Tabla EMPLEADO
-- -----------------------------------------------------
# Elimina el empleado con documento 6666
DELETE FROM EMPLEADO WHERE act_documento = 6666;

# Elimina empleados inactivos (por ejemplo, sin pagos registrados)
DELETE FROM EMPLEADO WHERE act_documento NOT IN (
    SELECT act_documento FROM PAGO_SALARIO
);

-- -----------------------------------------------------
-- Tabla HORARIO_EMPLEADO
-- -----------------------------------------------------
# Elimina el horario con ID 10 del empleado 3001
DELETE FROM HORARIO_EMPLEADO WHERE hor_id = 10 AND act_documento = 3001;

# Elimina todos los horarios con menos de 3 días laborales asignados
DELETE FROM HORARIO_EMPLEADO WHERE hor_num_dias_laborales < 3;

-- -----------------------------------------------------
-- Tabla PRODUCTO
-- -----------------------------------------------------
# Elimina el producto con ID 9999 (registro de prueba o descontinuado)
DELETE FROM PRODUCTO WHERE prod_id = 9999;

# Elimina todos los productos con precio igual a cero
DELETE FROM PRODUCTO WHERE prod_precio = 0;

-- -----------------------------------------------------
-- Tabla FACTURA_VENTA
-- -----------------------------------------------------
# Elimina la factura de venta con código 1000 (posiblemente prueba)
DELETE FROM FACTURA_VENTA WHERE fven_codigo = 1000;

# Elimina facturas de venta sin detalles asociados
DELETE FROM FACTURA_VENTA WHERE fven_codigo NOT IN (
    SELECT DISTINCT fven_codigo FROM DETALLE_FACTURA_VENTA
);

-- -----------------------------------------------------
-- Tabla DETALLE_FACTURA_VENTA
-- -----------------------------------------------------
# Elimina el detalle del producto 10 en la factura 1
DELETE FROM DETALLE_FACTURA_VENTA WHERE fven_codigo = 1 AND prod_id = 10;

# Elimina todos los detalles con cantidad igual a 0
DELETE FROM DETALLE_FACTURA_VENTA WHERE dfv_cantidad = 0;

-- -----------------------------------------------------
-- Tabla FACTURA_COMPRA
-- -----------------------------------------------------
# Elimina la factura de compra con código 2000
DELETE FROM FACTURA_COMPRA WHERE fcom_codigo = 2000;

# Elimina facturas de compra sin detalles asociados
DELETE FROM FACTURA_COMPRA WHERE fcom_codigo NOT IN (
    SELECT DISTINCT fcom_codigo FROM DETALLE_FACTURA_COMPRA
);

-- -----------------------------------------------------
-- Tabla DETALLE_FACTURA_COMPRA
-- -----------------------------------------------------
# Elimina el detalle del producto 20 en la factura de compra 1
DELETE FROM DETALLE_FACTURA_COMPRA WHERE fcom_codigo = 1 AND prod_id = 20;

# Elimina todos los detalles con subtotal igual a 0
DELETE FROM DETALLE_FACTURA_COMPRA WHERE dfc_subtotal = 0;

-- -----------------------------------------------------
-- Tabla PAGO_SALARIO
-- -----------------------------------------------------
# Elimina el pago salarial con número 999 (registro inválido)
DELETE FROM PAGO_SALARIO WHERE pag_numero_pago = 999;

# Elimina pagos con valor neto en cero (posiblemente erróneos)
DELETE FROM PAGO_SALARIO WHERE pag_valor_neto = 0;

-- -----------------------------------------------------
-- Tabla CUENTA_POR_COBRAR
-- -----------------------------------------------------
# Elimina la cuenta por cobrar con ID 12345
DELETE FROM CUENTA_POR_COBRAR WHERE cxc_id_cuenta = 12345;

# Elimina cuentas por cobrar totalmente pagadas
DELETE FROM CUENTA_POR_COBRAR WHERE cxc_saldo = 0;

-- -----------------------------------------------------
-- Tabla CUENTA_POR_PAGAR
-- -----------------------------------------------------
# Elimina la cuenta por pagar con ID 54321
DELETE FROM CUENTA_POR_PAGAR WHERE cxp_id_cuenta = 54321;

# Elimina cuentas por pagar sin deuda registrada
DELETE FROM CUENTA_POR_PAGAR WHERE cxp_total_deuda = 0;

-- -----------------------------------------------------
-- Tabla ARTICULO
-- -----------------------------------------------------
# Elimina el artículo con ID 5
DELETE FROM ARTICULO WHERE prod_id = 5;

# Elimina artículos sin stock disponible
DELETE FROM ARTICULO WHERE art_cantidad_disponible <= 0;

-- -----------------------------------------------------
-- Tabla SERVICIO
-- -----------------------------------------------------
# Elimina el servicio con ID 6
DELETE FROM SERVICIO WHERE prod_id = 6;

# Elimina servicios sin descripción registrada
DELETE FROM SERVICIO WHERE serv_descripcion IS NULL OR serv_descripcion = '';

-- -----------------------------------------------------
-- Tabla SERVICIO_HAS_EMPLEADO
-- -----------------------------------------------------
# Elimina la asignación del empleado 3001 al servicio 3
DELETE FROM SERVICIO_HAS_EMPLEADO WHERE prod_id = 3 AND act_documento = 3001;

# Elimina todas las asignaciones de servicio del empleado 9999
DELETE FROM SERVICIO_HAS_EMPLEADO WHERE act_documento = 9999;

-- -----------------------------------------------------
-- Tabla MATERIAL_HERRAMIENTA
-- -----------------------------------------------------
# Elimina el material con ID 100
DELETE FROM MATERIAL_HERRAMIENTA WHERE mat_id = 100;

# Elimina materiales sin stock o cantidad negativa
DELETE FROM MATERIAL_HERRAMIENTA WHERE mat_cantidad <= 0;

-- -----------------------------------------------------
-- Tabla SERVICIO_has_MATERIAL_HERRAMIENTA
-- -----------------------------------------------------
# Elimina la relación del material 3 con el servicio 3
DELETE FROM SERVICIO_has_MATERIAL_HERRAMIENTA WHERE prod_id = 3
