### 12 consultas SQL complejas 

-- 1. Total de Ventas por Empleado en un Período Específico
-- Descripción: Obtener el total de ventas (sumatoria del total de Facturas de Venta)
--              agrupado por cada empleado, para un rango de fechas dado.

SELECT
    A.act_nombre AS NombreEmpleado,
    SUM(PS.pag_comisiones * PS.pag_salario_base / 100) AS TotalComisionesPagadas -- Asumiendo pag_comisiones es un porcentaje
FROM
    PAGO_SALARIO AS PS
JOIN
    EMPLEADO AS E ON PS.act_documento = E.act_documento
JOIN
    ACTOR AS A ON E.act_documento = A.act_documento
WHERE
    PS.pag_fecha >= '2024-01-01' AND PS.pag_fecha <= '2024-12-31' -- Rango de fechas de ejemplo
GROUP BY
    A.act_nombre
ORDER BY
    TotalComisionesPagadas DESC;


-- 2. Productos Más Vendidos por Cantidad en el Último Mes
-- Descripción: Listar los 5 productos más vendidos (por la cantidad total vendida)
--              en el último mes, incluyendo el nombre del producto y la cantidad total.
SELECT
    P.prod_id,
    S.serv_nombre AS NombreProducto, -- Si es un servicio
    A.art_tipo AS TipoArticulo,     -- Si es un artículo
    SUM(DFV.dfv_cantidad) AS CantidadTotalVendida
FROM
    DETALLE_FACTURA_VENTA AS DFV
JOIN
    FACTURA_VENTA AS FV ON DFV.fven_codigo = FV.fven_codigo
JOIN
    PRODUCTO AS P ON DFV.prod_id = P.prod_id
LEFT JOIN
    SERVICIO AS S ON P.prod_id = S.prod_id AND P.prod_tipo = 'SERVICIO' -- Para obtener el nombre del servicio
LEFT JOIN
    ARTICULO AS A ON P.prod_id = A.prod_id AND P.prod_tipo = 'ARTICULO' -- Para obtener el tipo de artículo
WHERE
    FV.fven_fecha >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH) -- Último mes
GROUP BY
    P.prod_id, S.serv_nombre, A.art_tipo
ORDER BY
    CantidadTotalVendida DESC
LIMIT 5;


-- 3. Clientes con Mayor Gasto Total en el Último Año
-- Descripción: Identificar los clientes que han gastado más en el último año,
--              mostrando su nombre y el monto total de sus compras.
SELECT
    A.act_nombre AS NombreCliente,
    SUM(FV.fven_total) AS GastoTotal
FROM
    FACTURA_VENTA AS FV
JOIN
    CLIENTE AS C ON FV.act_documento = C.act_documento
JOIN
    ACTOR AS A ON C.act_documento = A.act_documento
WHERE
    FV.fven_fecha >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR) -- Último año
GROUP BY
    A.act_nombre
ORDER BY
    GastoTotal DESC;


-- 4. Productos con Stock por Debajo de un Umbral
-- Descripción: Mostrar todos los productos cuyo stock actual sea menor que
--              un valor predefinido (por ejemplo, 10 unidades), incluyendo
--              su referencia, nombre y cantidad en stock.
SELECT
    P.prod_id,
    A.art_tipo AS TipoArticulo,
    A.art_marca AS Marca,
    A.art_modelo AS Modelo,
    A.art_cantidad_disponible AS StockActual
FROM
    ARTICULO AS A
JOIN
    PRODUCTO AS P ON A.prod_id = P.prod_id
WHERE
    A.art_cantidad_disponible < 10; -- Umbral de ejemplo


-- 5. Historial de Compras de un Producto Específico por Proveedor
-- Descripción: Para un producto dado, obtener el historial de todas las compras realizadas,
--              incluyendo la fecha de la factura, la cantidad comprada, el precio unitario
--              y el nombre del proveedor.
SELECT
    FC.fcom_fecha AS FechaFactura,
    DFC.dfc_cantidad AS CantidadComprada,
    DFC.dfc_precio_unitario AS PrecioUnitario,
    A.act_nombre AS NombreProveedor
FROM
    DETALLE_FACTURA_COMPRA AS DFC
JOIN
    FACTURA_COMPRA AS FC ON DFC.fcom_codigo = FC.fcom_codigo
JOIN
    PROVEEDOR AS P ON FC.act_documento = P.act_documento
JOIN
    ACTOR AS A ON P.act_documento = A.act_documento
WHERE
    DFC.prod_id = 1; -- ID de producto específico (ejemplo)


-- 6. Balance de Cuentas por Pagar (Pendientes y Pagadas)
-- Descripción: Obtener el total de dinero pendiente por pagar y el total ya pagado
--              a proveedores, agrupado por proveedor, mostrando el nombre del proveedor.
SELECT
    A.act_nombre AS NombreProveedor,
    SUM(CASE WHEN PP.plpag_estado_pago = 'EN CURSO' OR PP.plpag_estado_pago = 'VENCIDO' THEN PP.plpag_valor_cuota - PP.plpag_valor_pagado ELSE 0 END) AS TotalPendiente,
    SUM(CASE WHEN PP.plpag_estado_pago = 'PAGADO' THEN PP.plpag_valor_pagado ELSE 0 END) AS TotalPagado
FROM
    PLAZO_PAGO AS PP
JOIN
    CUENTA_POR_PAGAR AS CXP ON PP.cxp_id_cuenta = CXP.cxp_id_cuenta
JOIN
    PROVEEDOR AS PR ON CXP.act_documento = PR.act_documento
JOIN
    ACTOR AS A ON PR.act_documento = A.act_documento
GROUP BY
    A.act_nombre;


-- 7. Ingresos Totales por Venta de Servicios vs. Productos en un Período
-- Descripción: Comparar los ingresos totales generados por la venta de servicios
--              y los ingresos por la venta de productos en un rango de fechas.
SELECT
    'ARTICULO' AS TipoIngreso,
    SUM(DFV.dfv_subtotal) AS TotalIngresos
FROM
    DETALLE_FACTURA_VENTA AS DFV
JOIN
    FACTURA_VENTA AS FV ON DFV.fven_codigo = FV.fven_codigo
JOIN
    PRODUCTO AS P ON DFV.prod_id = P.prod_id
WHERE
    P.prod_tipo = 'ARTICULO'
    AND FV.fven_fecha >= '2024-01-01' AND FV.fven_fecha <= '2024-12-31' -- Rango de fechas de ejemplo
GROUP BY
    TipoIngreso
UNION ALL
SELECT
    'SERVICIO' AS TipoIngreso,
    SUM(DFV.dfv_subtotal) AS TotalIngresos
FROM
    DETALLE_FACTURA_VENTA AS DFV
JOIN
    FACTURA_VENTA AS FV ON DFV.fven_codigo = FV.fven_codigo
JOIN
    PRODUCTO AS P ON DFV.prod_id = P.prod_id
WHERE
    P.prod_tipo = 'SERVICIO'
    AND FV.fven_fecha >= '2024-01-01' AND FV.fven_fecha <= '2024-12-31' -- Rango de fechas de ejemplo
GROUP BY
    TipoIngreso;


-- 8. Resumen de Liquidaciones de Empleados por Año
-- Descripción: Obtener la suma total de salarios, comisiones y pagos adelantados
--              pagados a empleados por año.
SELECT
    YEAR(pag_fecha) AS AnioLiquidacion,
    SUM(pag_salario_base) AS TotalSalarioBase,
    SUM(pag_comisiones * pag_salario_base / 100) AS TotalComisiones, -- Asumiendo pag_comisiones es un porcentaje
    SUM(pag_anticipos) AS TotalAnticipos,
    SUM(pag_total) AS TotalPagado
FROM
    PAGO_SALARIO
GROUP BY
    AnioLiquidacion
ORDER BY
    AnioLiquidacion;


-- 9. Rentabilidad por Producto
-- Descripción: Calcula la ganancia neta de cada producto, restando el costo total de compra
--              (considerando todas las unidades vendidas) del ingreso total generado por sus ventas.
--              Esto permite identificar qué productos son los más y menos rentables.

SELECT
    P.prod_id,
    COALESCE(S.serv_nombre, A.art_tipo, 'Desconocido') AS NombreProducto,
    SUM(DFV.dfv_subtotal) AS IngresosTotales,
    SUM(DFV.dfv_cantidad * DFC_AVG.CostoPromedioCompra) AS CostoTotalUnidadesVendidas,
    SUM(DFV.dfv_subtotal) - SUM(DFV.dfv_cantidad * DFC_AVG.CostoPromedioCompra) AS GananciaNetaEstimada
FROM
    DETALLE_FACTURA_VENTA AS DFV
JOIN
    PRODUCTO AS P ON DFV.prod_id = P.prod_id
LEFT JOIN
    SERVICIO AS S ON P.prod_id = S.prod_id AND P.prod_tipo = 'SERVICIO'
LEFT JOIN
    ARTICULO AS A ON P.prod_id = A.prod_id AND P.prod_tipo = 'ARTICULO'
LEFT JOIN (
    -- Subconsulta para calcular el costo promedio de compra por producto
    SELECT
        prod_id,
        AVG(dfc_precio_unitario) AS CostoPromedioCompra
    FROM
        DETALLE_FACTURA_COMPRA
    GROUP BY
        prod_id
) AS DFC_AVG ON P.prod_id = DFC_AVG.prod_id
GROUP BY
    P.prod_id, S.serv_nombre, A.art_tipo
ORDER BY
    GananciaNetaEstimada DESC;


-- 10. Eficacia de los Servicios por Empleado
-- Descripción: Determina el valor total de los servicios prestados por cada empleado
--              y compáralo con sus salarios y comisiones para evaluar la contribución
--              individual y la rentabilidad de la fuerza laboral en servicios.

SELECT
    A.act_nombre AS NombreEmpleado,
    SUM(CASE WHEN P.prod_tipo = 'SERVICIO' THEN DFV.dfv_subtotal ELSE 0 END) AS IngresosServiciosGenerados,
    COALESCE(PS.pag_salario_base, 0) AS SalarioBase,
    COALESCE(PS.pag_comisiones * PS.pag_salario_base / 100, 0) AS ComisionesPagadas, -- Asumiendo pag_comisiones es un porcentaje
    (SUM(CASE WHEN P.prod_tipo = 'SERVICIO' THEN DFV.dfv_subtotal ELSE 0 END)) - COALESCE(PS.pag_salario_base, 0) - COALESCE(PS.pag_comisiones * PS.pag_salario_base / 100, 0) AS RentabilidadEstimada
FROM
    EMPLEADO AS E
JOIN
    ACTOR AS A ON E.act_documento = A.act_documento
LEFT JOIN
    SERVICIO AS S ON E.act_documento = S.act_documento -- Empleado principal asociado al servicio
LEFT JOIN
    DETALLE_FACTURA_VENTA AS DFV ON S.prod_id = DFV.prod_id -- Ventas de esos servicios
LEFT JOIN
    PRODUCTO AS P ON DFV.prod_id = P.prod_id
LEFT JOIN
    PAGO_SALARIO AS PS ON E.act_documento = PS.act_documento AND PS.pag_fecha >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR) -- Último año de liquidaciones
GROUP BY
    A.act_nombre, PS.pag_salario_base, PS.pag_comisiones
ORDER BY
    RentabilidadEstimada DESC;


-- 11. Proyección de cuentas por pagar
-- Descripción: Mostrar todas las facturas de compra con cuotas pendientes, agrupadas por proveedor,
--              y calcular el total por pagar en los próximos 30, 60 y 90 días.
SELECT
    A.act_nombre AS NombreProveedor,
    CXP.cxp_id_cuenta AS IDCuentaPorPagar,
    FC.fcom_codigo AS CodigoFacturaCompra,
    PP.plpag_fecha_vencimiento AS FechaVencimientoCuota,
    PP.plpag_valor_cuota - PP.plpag_valor_pagado AS MontoPendienteCuota,
    SUM(CASE WHEN PP.plpag_fecha_vencimiento BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY) THEN PP.plpag_valor_cuota - PP.plpag_valor_pagado ELSE 0 END) AS Proyeccion30Dias,
    SUM(CASE WHEN PP.plpag_fecha_vencimiento BETWEEN DATE_ADD(CURDATE(), INTERVAL 31 DAY) AND DATE_ADD(CURDATE(), INTERVAL 60 DAY) THEN PP.plpag_valor_cuota - PP.plpag_valor_pagado ELSE 0 END) AS Proyeccion60Dias,
    SUM(CASE WHEN PP.plpag_fecha_vencimiento BETWEEN DATE_ADD(CURDATE(), INTERVAL 61 DAY) AND DATE_ADD(CURDATE(), INTERVAL 90 DAY) THEN PP.plpag_valor_cuota - PP.plpag_valor_pagado ELSE 0 END) AS Proyeccion90Dias
FROM
    PLAZO_PAGO AS PP
JOIN
    CUENTA_POR_PAGAR AS CXP ON PP.cxp_id_cuenta = CXP.cxp_id_cuenta
JOIN
    PROVEEDOR AS PR ON CXP.act_documento = PR.act_documento
JOIN
    ACTOR AS A ON PR.act_documento = A.act_documento
LEFT JOIN
    FACTURA_COMPRA AS FC ON CXP.cxp_id_cuenta = FC.fcom_codigo -- Asumiendo que fcom_codigo es el id de la CXP o hay una FK
WHERE
    PP.plpag_estado_pago <> 'PAGADO' -- Solo cuotas pendientes
GROUP BY
    A.act_nombre, CXP.cxp_id_cuenta, FC.fcom_codigo, PP.plpag_fecha_vencimiento, (PP.plpag_valor_cuota - PP.plpag_valor_pagado)
ORDER BY
    A.act_nombre, PP.plpag_fecha_vencimiento;


-- 12. Clientes morosos
-- Descripción: Listar todos los clientes con cuentas por cobrar vencidas hace más de 15 días,
--              incluyendo contacto, total adeudado, y última fecha de pago registrada.
SELECT
    A.act_nombre AS NombreCliente,
    A.act_telefono AS TelefonoCliente,
    A.act_correo AS CorreoCliente,
    SUM(CPC.cxc_saldo) AS TotalAdeudado, -- Saldo actual de la cuenta por cobrar
    MAX(PC.plcob_fecha_pago_final) AS UltimaFechaPagoRegistrada -- Última fecha de pago de una cuota de esta cuenta
FROM
    CLIENTE AS C
JOIN
    ACTOR AS A ON C.act_documento = A.act_documento
JOIN
    CUENTA_POR_COBRAR AS CPC ON C.act_documento = CPC.act_documento
JOIN
    PLAZO_COBRO AS PC ON CPC.cxc_id_cuenta = PC.cxc_id_cuenta
WHERE
    PC.plcob_estado_cobro = 'VENCIDO'
    AND PC.plcob_fecha_vencimiento < DATE_SUB(CURDATE(), INTERVAL 15 DAY) -- Vencidas hace más de 15 días
GROUP BY
    A.act_nombre, A.act_telefono, A.act_correo
ORDER BY
    TotalAdeudado DESC;