### Script para la creación de vistas en la base de datos 

USE proyecto_base_datos;

-- VISTAS PROPUESTAS

-- Vista_Inventario_Consulta
-- Propósito: Para el Personal de Ventas y Almacén/Taller,
--            permite consultar el stock y detalles de los artículos sin exponer costos de compra.
DROP VIEW IF EXISTS Vista_Inventario_Consulta;
CREATE VIEW Vista_Inventario_Consulta AS
SELECT
    P.prod_id AS ID_Producto,
    P.prod_precio AS Precio_Venta,
    A.art_tipo AS Tipo_Articulo,
    A.art_marca AS Marca_Articulo,
    A.art_modelo AS Modelo_Articulo,
    A.art_cantidad_disponible AS Cantidad_Disponible
FROM
    PRODUCTO AS P
JOIN
    ARTICULO AS A ON P.prod_id = A.prod_id
WHERE
    P.prod_tipo = 'ARTICULO';


-- Vista_Ventas_Historico
-- Propósito: Para el Gerente/Dueño del Negocio y Contabilidad/Finanzas,
--            ofrece una visión consolidada del historial de ventas, incluyendo
--            información del cliente y detalles del producto.
DROP VIEW IF EXISTS Vista_Ventas_Historico;
CREATE VIEW Vista_Ventas_Historico AS
SELECT
    FV.fven_codigo AS Codigo_Factura_Venta,
    FV.fven_fecha AS Fecha_Venta,
    FV.fven_total AS Total_Factura,
    FV.fven_metodo_pago AS Metodo_Pago,
    A_Cliente.act_nombre AS Nombre_Cliente,
    A_Cliente.act_documento AS Documento_Cliente,
    P.prod_id AS ID_Producto,
    COALESCE(Art.art_tipo, Serv.serv_nombre) AS Tipo_Producto_Vendido, -- Usa el tipo de Articulo o nombre de Servicio
    DFV.dfv_cantidad AS Cantidad_Vendida,
    DFV.dfv_precio_unitario AS Precio_Unitario_Venta,
    DFV.dfv_subtotal AS Subtotal_Linea
FROM
    FACTURA_VENTA AS FV
JOIN
    CLIENTE AS C ON FV.act_documento = C.act_documento
JOIN
    ACTOR AS A_Cliente ON C.act_documento = A_Cliente.act_documento
JOIN
    DETALLE_FACTURA_VENTA AS DFV ON FV.fven_codigo = DFV.fven_codigo
JOIN
    PRODUCTO AS P ON DFV.prod_id = P.prod_id
LEFT JOIN
    ARTICULO AS Art ON P.prod_id = Art.prod_id AND P.prod_tipo = 'ARTICULO'
LEFT JOIN
    SERVICIO AS Serv ON P.prod_id = Serv.prod_id AND P.prod_tipo = 'SERVICIO';


-- Vista_Cuentas_Cobrar_Resumen
-- Propósito: Para el Gerente/Dueño del Negocio, Personal de Ventas y Contabilidad/Finanzas,
--            proporciona un resumen de las cuentas por cobrar pendientes y pagadas.
DROP VIEW IF EXISTS Vista_Cuentas_Cobrar_Resumen;
CREATE VIEW Vista_Cuentas_Cobrar_Resumen AS
SELECT
    PC.plcob_id AS ID_Plazo_Cobro,
    CXC.cxc_id_cuenta AS ID_Cuenta_Por_Cobrar,
    A_Cliente.act_nombre AS Nombre_Cliente,
    A_Cliente.act_documento AS Documento_Cliente,
    CXC.cxc_total_deuda AS Deuda_Inicial_CXC,
    CXC.cxc_saldo AS Saldo_Pendiente_CXC,
    PC.plcob_fecha_vencimiento AS Fecha_Vencimiento_Cuota,
    PC.plcob_valor_cuota AS Valor_Cuota,
    PC.plcob_valor_pagado AS Valor_Pagado_Cuota,
    PC.plcob_estado_cobro AS Estado_Cobro_Cuota,
    PC.plcob_fecha_pago_final AS Fecha_Pago_Final_Cuota
FROM
    PLAZO_COBRO AS PC
JOIN
    CUENTA_POR_COBRAR AS CXC ON PC.cxc_id_cuenta = CXC.cxc_id_cuenta
JOIN
    CLIENTE AS C ON CXC.act_documento = C.act_documento
JOIN
    ACTOR AS A_Cliente ON C.act_documento = A_Cliente.act_documento;


-- Vista_Cuentas_Pagar_Resumen
-- Propósito: Para el Gerente/Dueño del Negocio y Contabilidad/Finanzas,
--            ofrece un resumen de las cuentas por pagar pendientes y pagadas.
DROP VIEW IF EXISTS Vista_Cuentas_Pagar_Resumen;
CREATE VIEW Vista_Cuentas_Pagar_Resumen AS
SELECT
    PP.plpag_id AS ID_Plazo_Pago,
    CXP.cxp_id_cuenta AS ID_Cuenta_Por_Pagar,
    A_Prov.act_nombre AS Nombre_Proveedor,
    A_Prov.act_documento AS Documento_Proveedor,
    CXP.cxp_total_deuda AS Deuda_Inicial_CXP,
    CXP.cxp_saldo AS Saldo_Pendiente_CXP,
    PP.plpag_fecha_vencimiento AS Fecha_Vencimiento_Cuota,
    PP.plpag_valor_cuota AS Valor_Cuota,
    PP.plpag_valor_pagado AS Valor_Pagado_Cuota,
    PP.plpag_estado_pago AS Estado_Pago_Cuota,
    PP.plpag_fecha_pago_final AS Fecha_Pago_Final_Cuota
FROM
    PLAZO_PAGO AS PP
JOIN
    CUENTA_POR_PAGAR AS CXP ON PP.cxp_id_cuenta = CXP.cxp_id_cuenta
JOIN
    PROVEEDOR AS Pr ON CXP.act_documento = Pr.act_documento
JOIN
    ACTOR AS A_Prov ON Pr.act_documento = A_Prov.act_documento;


-- Vista_Servicios_Realizados
-- Propósito: Para el Gerente/Dueño del Negocio y Personal de Almacén/Taller,
--            muestra los servicios que han sido vendidos y el empleado "responsable"
--            de ese tipo de servicio.
DROP VIEW IF EXISTS Vista_Servicios_Realizados;
CREATE VIEW Vista_Servicios_Realizados AS
SELECT
    FV.fven_fecha AS Fecha_Factura_Servicio,
    FV.fven_codigo AS Codigo_Factura_Venta,
    A_Cliente.act_nombre AS Nombre_Cliente,
    S.serv_nombre AS Nombre_Servicio,
    S.serv_descripcion AS Descripcion_Servicio,
    DFV.dfv_cantidad AS Cantidad_Servicios,
    DFV.dfv_subtotal AS Subtotal_Servicio,
    A_Empleado.act_nombre AS Empleado_Responsable_Servicio -- Empleado asociado al tipo de servicio
FROM
    FACTURA_VENTA AS FV
JOIN
    DETALLE_FACTURA_VENTA AS DFV ON FV.fven_codigo = DFV.fven_codigo
JOIN
    PRODUCTO AS P ON DFV.prod_id = P.prod_id
JOIN
    SERVICIO AS S ON P.prod_id = S.prod_id -- P.prod_tipo = 'SERVICIO' se infiere de la JOIN con SERVICIO
JOIN
    EMPLEADO AS E ON S.act_documento = E.act_documento
JOIN
    ACTOR AS A_Empleado ON E.act_documento = A_Empleado.act_documento
JOIN
    CLIENTE AS C ON FV.act_documento = C.act_documento
JOIN
    ACTOR AS A_Cliente ON C.act_documento = A_Cliente.act_documento
WHERE
    P.prod_tipo = 'SERVICIO';


-- Vista_Nomina_Resumen
-- Propósito: Para el Gerente/Dueño del Negocio y Contabilidad/Finanzas,
--            ofrece un resumen de las liquidaciones de pago a empleados.
DROP VIEW IF EXISTS Vista_Nomina_Resumen;
CREATE VIEW Vista_Nomina_Resumen AS
SELECT
    PS.pag_numero_pago AS Numero_Pago,
    PS.pag_fecha AS Fecha_Liquidacion,
    A.act_nombre AS Nombre_Empleado,
    E.emp_puesto AS Puesto_Empleado,
    PS.pag_salario_base AS Salario_Base,
    PS.pag_comisiones AS Porcentaje_Comisiones,
    PS.pag_anticipos AS Total_Anticipos,
    PS.pag_total AS Total_Pagado_Neto
FROM
    PAGO_SALARIO AS PS
JOIN
    EMPLEADO AS E ON PS.act_documento = E.act_documento
JOIN
    ACTOR AS A ON E.act_documento = A.act_documento;

