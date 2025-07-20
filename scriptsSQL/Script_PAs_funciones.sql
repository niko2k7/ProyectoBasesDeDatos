# Script de procedimientos almacenados, funciones, y transacciones

-- Procedimientos almacenados

-- Rentabilidad por Producto (Anterior consulta 9)
-- Descripción: Calcula la ganancia neta de cada producto, restando el costo total de compra
--              (considerando todas las unidades vendidas) del ingreso total generado por sus ventas.
--              Esto permite identificar qué productos son los más y menos rentables.
DELIMITER //

CREATE PROCEDURE ObtenerRentabilidadPorProducto()
BEGIN
    SELECT
        P.prod_id,
        CASE
            WHEN P.prod_tipo = 'SERVICIO' THEN S.serv_nombre
            ELSE P.prod_modelo -- Asumo que para artículos/productos se usa el modelo o marca como 'nombre' si no hay una columna de nombre específica.
        END AS NombreProducto,
        SUM(DFV.detfven_subtotal) AS IngresosTotales,
        SUM(DFV.detfven_cantidad * DFC_AVG.CostoPromedioCompra) AS CostoTotalUnidadesVendidas,
        SUM(DFV.detfven_subtotal) - SUM(DFV.detfven_cantidad * DFC_AVG.CostoPromedioCompra) AS GananciaNetaEstimada
    FROM
        DETALLE_FACTURA_VENTA AS DFV
    JOIN
        PRODUCTO AS P ON DFV.prod_id = P.prod_id
    LEFT JOIN
        SERVICIO AS S ON P.prod_id = S.serv_id AND P.prod_tipo = 'SERVICIO' -- Asumiendo prod_id es serv_id para servicios
    LEFT JOIN (
        -- Subconsulta para calcular el costo promedio de compra por producto
        SELECT
            prod_id,
            AVG(detfcom_precio_unitario) AS CostoPromedioCompra
        FROM
            DETALLE_FACTURA_COMPRA
        GROUP BY
            prod_id
    ) AS DFC_AVG ON P.prod_id = DFC_AVG.prod_id
    GROUP BY
        P.prod_id, NombreProducto -- Se agrupa por el ID y el nombre derivado
    ORDER BY
        GananciaNetaEstimada DESC;
END //

DELIMITER ;


-- Eficacia de los Servicios por Empleado (Anterior consulta 10)
-- Descripción: Determina el valor total de los servicios prestados por cada empleado
--              y compáralo con sus salarios y comisiones para evaluar la contribución
--              individual y la rentabilidad de la fuerza laboral en servicios.
DELIMITER //

CREATE PROCEDURE ObtenerEficaciaServiciosPorEmpleado()
BEGIN
    SELECT
        A.act_nombre AS NombreEmpleado,
        SUM(CASE WHEN P.prod_tipo = 'SERVICIO' THEN DFV.detfven_subtotal ELSE 0 END) AS IngresosServiciosGenerados,
        COALESCE(LE.liq_salario_base, 0) AS SalarioBaseTotal, -- Puede ser la suma de varios pagos si no se agrupa por liquidación
        COALESCE(LE.liq_comisiones, 0) AS ComisionesPagadasTotal, -- Puede ser la suma de varios pagos si no se agrupa por liquidación
        (SUM(CASE WHEN P.prod_tipo = 'SERVICIO' THEN DFV.detfven_subtotal ELSE 0 END)) - COALESCE(LE.liq_salario_base, 0) - COALESCE(LE.liq_comisiones, 0) AS RentabilidadEstimada
    FROM
        EMPLEADO AS E
    JOIN
        ACTOR AS A ON E.emp_id = A.act_documento -- Asumo emp_id es el act_documento
    LEFT JOIN
        LIQUIDACION_EMPLEADO AS LE ON E.emp_id = LE.emp_id -- Asumo LIQUIDACION_EMPLEADO tiene emp_id
    LEFT JOIN
        SERVICIO AS S ON E.emp_id = S.emp_id -- ASUMPCIÓN CLAVE: Que SERVICIO tiene un FK a EMPLEADO (emp_id)
    LEFT JOIN
        DETALLE_FACTURA_VENTA AS DFV ON S.serv_id = DFV.prod_id -- Asumiendo que S.serv_id es el prod_id en DETALLE_FACTURA_VENTA para servicios
    LEFT JOIN
        PRODUCTO AS P ON DFV.prod_id = P.prod_id
    WHERE
        -- Filtrar por un período si es necesario, o sumar todos los ingresos/gastos
        (LE.liq_fecha >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR) OR LE.liq_fecha IS NULL) -- Para incluir empleados sin liquidaciones en el último año
    GROUP BY
        A.act_nombre, LE.liq_salario_base, LE.liq_comisiones -- Agrupar por nombre y los valores de liquidación si se quiere ver por liquidación específica
    ORDER BY
        RentabilidadEstimada DESC;
END //

DELIMITER ;


-- Proyección de cuentas por pagar (Anterior consulta 11)
-- Descripción: Mostrar todas las facturas de compra con cuotas pendientes, agrupadas por proveedor,
--              y calcular el total por pagar en los próximos 30, 60 y 90 días.
DELIMITER //

CREATE PROCEDURE ProyeccionCuentasPorPagar()
BEGIN
    SELECT
        A.act_nombre AS NombreProveedor,
        CXP.cxp_id AS IDCuentaPorPagar, -- Usamos cxp_id según tus entidades
        FC.fcom_código AS CodigoFacturaCompra,
        PP.plpag_fecha_vencimiento AS FechaVencimientoCuota,
        (PP.plpag_valor_cuota - PP.plpag_valor_pagado) AS MontoPendienteCuota,
        SUM(CASE WHEN PP.plpag_fecha_vencimiento BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY) THEN (PP.plpag_valor_cuota - PP.plpag_valor_pagado) ELSE 0 END) AS Proyeccion30Dias,
        SUM(CASE WHEN PP.plpag_fecha_vencimiento BETWEEN DATE_ADD(CURDATE(), INTERVAL 31 DAY) AND DATE_ADD(CURDATE(), INTERVAL 60 DAY) THEN (PP.plpag_valor_cuota - PP.plpag_valor_pagado) ELSE 0 END) AS Proyeccion60Dias,
        SUM(CASE WHEN PP.plpag_fecha_vencimiento BETWEEN DATE_ADD(CURDATE(), INTERVAL 61 DAY) AND DATE_ADD(CURDATE(), INTERVAL 90 DAY) THEN (PP.plpag_valor_cuota - PP.plpag_valor_pagado) ELSE 0 END) AS Proyeccion90Dias
    FROM
        PLAZO_PAGO AS PP
    JOIN
        CUENTA_POR_PAGAR AS CXP ON PP.cxp_id = CXP.cxp_id -- Usamos cxp_id
    JOIN
        PROVEEDOR AS PR ON CXP.cxp_id_participante = PR.prov_id -- Asumo cxp_id_participante en CUENTA_POR_PAGAR es prov_id del PROVEEDOR
    JOIN
        ACTOR AS A ON PR.prov_id = A.act_documento -- Asumo prov_id es act_documento
    LEFT JOIN
        FACTURA_COMPRA AS FC ON CXP.fcom_código = FC.fcom_código -- Asumo CUENTA_POR_PAGAR tiene un fcom_código o se relaciona con FACTURA_COMPRA así
    WHERE
        PP.plpag_estado_pago <> 'PAGADO' -- Solo cuotas pendientes
    GROUP BY
        A.act_nombre, CXP.cxp_id, FC.fcom_código, PP.plpag_fecha_vencimiento, (PP.plpag_valor_cuota - PP.plpag_valor_pagado)
    ORDER BY
        A.act_nombre, PP.plpag_fecha_vencimiento;
END //

DELIMITER ;

select * from factura_venta;



##### Para agregar una factura junto con sus detalles de venta
DROP PROCEDURE IF EXISTS crear_factura_venta;
DELIMITER //
CREATE PROCEDURE crear_factura_venta(
    IN p_fecha DATE,
    IN p_total DECIMAL(10,2),
    IN p_metodo_pago VARCHAR(45),
    IN p_act_documento INT,
    OUT p_fven_codigo INT
)
BEGIN
    INSERT INTO FACTURA_VENTA (fven_fecha, fven_total, fven_metodo_pago, act_documento)
    VALUES (p_fecha, p_total, p_metodo_pago, p_act_documento);

    SET p_fven_codigo = LAST_INSERT_ID();
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS agregar_detalle_factura;
DELIMITER //
CREATE PROCEDURE agregar_detalle_factura(
    IN p_fven_codigo INT,
    IN p_prod_id INT,
    IN p_cantidad INT,
    IN p_precio_unitario DECIMAL(10,2),
    IN p_subtotal DECIMAL(10,2)
)
BEGIN
    INSERT INTO DETALLE_FACTURA_VENTA (
        fven_codigo, prod_id, dfv_cantidad, dfv_precio_unitario, dfv_subtotal
    ) VALUES (
        p_fven_codigo, p_prod_id, p_cantidad, p_precio_unitario, p_subtotal
    );

    UPDATE articulo
    SET art_cantidad_disponible = art_cantidad_disponible - p_cantidad
    WHERE prod_id = p_prod_id;
END //
DELIMITER ;




