# Script de procedimientos almacenados, funciones, y transacciones

-- Procedimientos almacenados

-- Rentabilidad por Producto (Anterior consulta 9)
-- Descripción: Calcula la ganancia neta de cada producto, restando el costo total de compra
--              (considerando todas las unidades vendidas) del ingreso total generado por sus ventas.
--              Esto permite identificar qué productos son los más y menos rentables.
DROP PROCEDURE IF EXISTS ObtenerRentabilidadPorProducto;
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
DROP PROCEDURE IF EXISTS ObtenerEficaciaServiciosPorEmpleado;
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
DROP PROCEDURE IF EXISTS ProyeccionCuentasPorPagar;
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


##### Necesarios para la interfaz:
# Obtener
DROP PROCEDURE IF EXISTS sp_obtener_clientes;
DELIMITER //
CREATE PROCEDURE sp_obtener_clientes()
	BEGIN
		SELECT * FROM actor WHERE act_tipo = 'Cliente';
	END //
DELIMITER ;

# Insertar
DROP PROCEDURE IF EXISTS sp_insertar_cliente;
DELIMITER //
CREATE PROCEDURE sp_insertar_cliente (
    IN p_documento INT,
    IN p_nombre VARCHAR(100),
    IN p_direccion VARCHAR(200),
    IN p_telefono VARCHAR(20),
    IN p_correo VARCHAR(100),
    IN p_estado_juridico VARCHAR(20)
)
BEGIN
    INSERT INTO actor (
        act_documento,
        act_tipo,
        act_nombre,
        act_direccion,
        act_telefono,
        act_correo,
        act_estado_juridico
    )
    VALUES (
        p_documento,
        'CLIENTE',         -- Fijo
        p_nombre,
        p_direccion,
        p_telefono,
        p_correo,
        p_estado_juridico
    );
    
    -- FALTA EL TRIGGERS
END //
DELIMITER ;

# Actualizar
DROP PROCEDURE IF EXISTS sp_actualizar_actor;
DELIMITER //
CREATE PROCEDURE sp_actualizar_actor(
    IN p_documento INT,
    IN p_nombre VARCHAR(45),
    IN p_direccion VARCHAR(45),
    IN p_telefono VARCHAR(13),
    IN p_correo VARCHAR(45),
    IN p_estado_juridico ENUM('NATURAL', 'JURIDICA')
)
BEGIN
    UPDATE actor
    SET 
        act_nombre = p_nombre,
        act_direccion = p_direccion,
        act_telefono = p_telefono,
        act_correo = p_correo,
        act_estado_juridico = p_estado_juridico
    WHERE act_documento = p_documento;
END //
DELIMITER ;

# Borrar
DROP PROCEDURE IF EXISTS sp_eliminar_cliente;
DELIMITER //
CREATE PROCEDURE sp_eliminar_cliente(IN p_documento INT)
BEGIN
    DELETE FROM cliente WHERE act_documento = p_documento;
    DELETE FROM actor WHERE act_documento = p_documento AND act_tipo = 'CLIENTE';
END //
DELIMITER ;

##### Para agregar una factura junto con sus detalles de venta
DROP PROCEDURE IF EXISTS sp_crear_factura_venta;
DELIMITER //
CREATE PROCEDURE sp_crear_factura_venta(
    IN p_fecha DATE,
    IN p_total DECIMAL(10,2),
    IN p_metodo_pago VARCHAR(45),
    IN p_act_documento INT
)
BEGIN
    INSERT INTO FACTURA_VENTA (fven_fecha, fven_total, fven_metodo_pago, act_documento)
    VALUES (p_fecha, p_total, p_metodo_pago, p_act_documento);
    
    SELECT LAST_INSERT_ID() AS idFactura;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_agregar_detalle_factura;
DELIMITER //
CREATE PROCEDURE sp_agregar_detalle_factura(
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
    -- HACER CON TRIGGER Y TRANSACCION
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_obtener_articulos;
DELIMITER //
CREATE PROCEDURE sp_obtener_articulos()
BEGIN
    SELECT prod_id, art_tipo, art_marca, art_modelo, prod_precio, art_cantidad_disponible
    FROM producto NATURAL JOIN articulo;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_obtener_servicios;
DELIMITER //
CREATE PROCEDURE sp_obtener_servicios()
BEGIN
    SELECT prod_id, serv_nombre, prod_precio, act_nombre
    FROM producto
    NATURAL JOIN servicio
    NATURAL JOIN actor;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_eliminar_articulo;
DELIMITER //
CREATE PROCEDURE sp_eliminar_articulo(IN p_prod_id INT)
BEGIN
    DELETE FROM articulo WHERE prod_id = p_prod_id;
    -- Aquí podrías agregar más lógica si quieres borrar registros relacionados o lanzar errores si hay dependencias
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_eliminar_servicio;
DELIMITER //
CREATE PROCEDURE sp_eliminar_servicio(IN p_prod_id INT)
BEGIN
    DELETE FROM servicio WHERE prod_id = p_prod_id;
    -- Aquí también puedes dejar que un TRIGGER se encargue de limpiar referencias en tablas relacionadas si es necesario.
END //
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_buscar_articulos_por_tipo;
DELIMITER //
CREATE PROCEDURE sp_buscar_articulos_por_tipo(IN p_tipo_busqueda VARCHAR(100))
BEGIN
    SELECT 
        prod_id, art_tipo, art_marca, art_modelo, prod_precio, art_cantidad_disponible
    FROM 
        producto 
    NATURAL JOIN 
        articulo
    WHERE 
        art_tipo LIKE CONCAT('%', p_tipo_busqueda, '%');
END //
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_buscar_articulos_por_marca;
DELIMITER //
CREATE PROCEDURE sp_buscar_articulos_por_marca(IN p_marca_busqueda VARCHAR(100))
BEGIN
    SELECT 
        prod_id, art_tipo, art_marca, art_modelo, prod_precio, art_cantidad_disponible
    FROM 
        producto 
    NATURAL JOIN 
        articulo
    WHERE 
        art_marca LIKE CONCAT('%', p_marca_busqueda, '%');
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_buscar_articulos_por_modelo;
DELIMITER //
CREATE PROCEDURE sp_buscar_articulos_por_modelo(IN p_modelo_busqueda VARCHAR(100))
BEGIN
    SELECT 
        prod_id, art_tipo, art_marca, art_modelo, prod_precio, art_cantidad_disponible
    FROM 
        producto 
    NATURAL JOIN 
        articulo
    WHERE 
        art_modelo LIKE CONCAT('%', p_modelo_busqueda, '%');
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_filtrar_stock_critico;
DELIMITER //
CREATE PROCEDURE sp_filtrar_stock_critico()
BEGIN
    SELECT 
        prod_id, art_tipo, art_marca, art_modelo, prod_precio, art_cantidad_disponible
    FROM 
        producto 
    NATURAL JOIN 
        articulo
    WHERE 
        art_cantidad_disponible <= 10;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_filtrar_sin_stock;
DELIMITER //
CREATE PROCEDURE sp_filtrar_sin_stock()
BEGIN
    SELECT 
        prod_id, art_tipo, art_marca, art_modelo, prod_precio, art_cantidad_disponible
    FROM 
        producto 
    NATURAL JOIN 
        articulo
    WHERE 
        art_cantidad_disponible = 0;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_obtener_facturas_venta;
DELIMITER //
CREATE PROCEDURE sp_obtener_facturas_venta()
BEGIN
    SELECT 
        fven_codigo, fven_fecha, fven_total, fven_metodo_pago, act_documento, act_nombre
    FROM 
        factura_venta
    NATURAL JOIN actor;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_buscar_factura_por_codigo;
DELIMITER //
CREATE PROCEDURE sp_buscar_factura_por_codigo(IN p_fven_codigo INT)
BEGIN
    SELECT 
        fven_codigo, fven_fecha, fven_total, fven_metodo_pago, act_documento, act_nombre
    FROM 
        factura_venta
    NATURAL JOIN actor
    WHERE 
        fven_codigo = p_fven_codigo;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_buscar_facturas_por_fecha;
DELIMITER //
CREATE PROCEDURE sp_buscar_facturas_por_fecha(IN p_fecha VARCHAR(20))
BEGIN
    SELECT 
        fven_codigo, fven_fecha, fven_total, fven_metodo_pago, act_documento, act_nombre
    FROM 
        factura_venta
    NATURAL JOIN 
        actor
    WHERE 
        fven_fecha LIKE p_fecha;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_buscar_facturas_por_intervalo;
DELIMITER //
CREATE PROCEDURE sp_buscar_facturas_por_intervalo(IN p_fecha1 DATE, IN p_fecha2 DATE)
BEGIN
    SELECT 
        fven_codigo, fven_fecha, fven_total, fven_metodo_pago, act_documento, act_nombre
    FROM 
        factura_venta
    NATURAL JOIN 
        actor
    WHERE 
        fven_fecha BETWEEN LEAST(p_fecha1, p_fecha2) AND GREATEST(p_fecha1, p_fecha2);
END //
DELIMITER ;




DROP PROCEDURE IF EXISTS sp_buscar_factura_por_documento;
DELIMITER //
CREATE PROCEDURE sp_buscar_factura_por_documento(IN p_documento VARCHAR(100))
BEGIN
    SELECT 
        fven_codigo, fven_fecha, fven_total, fven_metodo_pago, act_documento, act_nombre
    FROM 
        factura_venta 
    NATURAL JOIN 
        actor
    WHERE 
        act_documento LIKE CONCAT('%', p_documento, '%');
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_filtrar_facturas_efectivo;
DELIMITER //
CREATE PROCEDURE sp_filtrar_facturas_efectivo()
BEGIN
    SELECT 
        fven_codigo, fven_fecha, fven_total, fven_metodo_pago, act_documento, act_nombre
    FROM 
        factura_venta
    NATURAL JOIN actor
    WHERE 
        fven_metodo_pago LIKE '%efectivo%';
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_filtrar_facturas_tarjeta;
DELIMITER //
CREATE PROCEDURE sp_filtrar_facturas_tarjeta()
BEGIN
    SELECT 
        fven_codigo, fven_fecha, fven_total, fven_metodo_pago, act_documento, act_nombre
    FROM 
        factura_venta
    NATURAL JOIN actor
    WHERE 
        fven_metodo_pago LIKE '%tarjeta%';
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_filtrar_facturas_transferencia;
DELIMITER //
CREATE PROCEDURE sp_filtrar_facturas_transferencia()
BEGIN
    SELECT 
        fven_codigo, fven_fecha, fven_total, fven_metodo_pago, act_documento, act_nombre
    FROM 
        factura_venta
    NATURAL JOIN actor
    WHERE 
        fven_metodo_pago LIKE '%transferencia%';
END //
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_obtener_datos_cliente;
DELIMITER //
CREATE PROCEDURE sp_obtener_datos_cliente(IN p_documento VARCHAR(20))
BEGIN
    SELECT 
        act_nombre, 
        act_direccion, 
        act_telefono, 
        act_correo, 
        act_estado_juridico
    FROM actor
    WHERE act_documento = p_documento;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_cargar_articulos_factura;
DELIMITER //
CREATE PROCEDURE sp_cargar_articulos_factura(IN p_codigo_factura VARCHAR(20))
BEGIN
    SELECT 
        dfv.prod_id, 
        art_tipo, 
        art_marca, 
        art_modelo, 
        dfv_precio_unitario, 
        dfv_cantidad, 
        dfv_subtotal
    FROM detalle_factura_venta AS dfv
    JOIN articulo AS a ON dfv.prod_id = a.prod_id
    WHERE dfv.fven_codigo = p_codigo_factura;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_cargar_servicios_factura;
DELIMITER //
CREATE PROCEDURE sp_cargar_servicios_factura(IN p_codigo_factura VARCHAR(20))
BEGIN
    SELECT  
        dfv.prod_id, 
        serv_nombre, 
        prod_precio, 
        act_nombre
    FROM detalle_factura_venta AS dfv
    JOIN servicio AS s ON dfv.prod_id = s.prod_id
    JOIN producto AS p ON p.prod_id = s.prod_id
    JOIN actor AS a ON s.act_documento = a.act_documento
    WHERE dfv.fven_codigo = p_codigo_factura;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_obtener_actor_por_documento;
DELIMITER //
CREATE PROCEDURE sp_obtener_actor_por_documento(
    IN p_documento INT
)
BEGIN
    SELECT act_nombre, act_direccion, act_telefono, act_correo, act_estado_juridico
    FROM actor
    WHERE act_documento = p_documento;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_cargar_cuentas_por_cobrar;
DELIMITER //
CREATE PROCEDURE sp_cargar_cuentas_por_cobrar()
BEGIN
    SELECT  
        cuenta_por_cobrar.cxc_id_cuenta, 
        cxc_fecha_emision, 
        plcob_fecha_vencimiento, 
        plcob_plazo, 
        cxc_total_deuda, 
        plcob_valor_pagado, 
        plcob_estado_cobro, 
        actor.act_documento, 
        actor.act_nombre
    FROM CUENTA_POR_COBRAR 
    JOIN PLAZO_COBRO ON CUENTA_POR_COBRAR.cxc_id_cuenta = PLAZO_COBRO.cxc_id_cuenta 
    JOIN ACTOR ON CUENTA_POR_COBRAR.act_documento = actor.act_documento;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_buscar_cuenta_por_id;
DELIMITER //
CREATE PROCEDURE sp_buscar_cuenta_por_id(IN p_id_cuenta VARCHAR(20))
BEGIN
    SELECT  
        cuenta_por_cobrar.cxc_id_cuenta, 
        cxc_fecha_emision, 
        plcob_fecha_vencimiento, 
        plcob_plazo, 
        cxc_total_deuda, 
        plcob_valor_pagado, 
        plcob_estado_cobro, 
        actor.act_documento, 
        actor.act_nombre
    FROM CUENTA_POR_COBRAR 
    JOIN PLAZO_COBRO ON CUENTA_POR_COBRAR.cxc_id_cuenta = PLAZO_COBRO.cxc_id_cuenta 
    JOIN ACTOR ON CUENTA_POR_COBRAR.act_documento = actor.act_documento
    WHERE cuenta_por_cobrar.cxc_id_cuenta = p_id_cuenta;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_buscar_cuenta_por_fecha_emision;
DELIMITER //
CREATE PROCEDURE sp_buscar_cuenta_por_fecha_emision(IN p_fecha DATE)
BEGIN
    SELECT  
        cuenta_por_cobrar.cxc_id_cuenta, 
        cxc_fecha_emision, 
        plcob_fecha_vencimiento, 
        plcob_plazo, 
        cxc_total_deuda, 
        plcob_valor_pagado, 
        plcob_estado_cobro, 
        actor.act_documento, 
        actor.act_nombre
    FROM CUENTA_POR_COBRAR 
    JOIN PLAZO_COBRO ON CUENTA_POR_COBRAR.cxc_id_cuenta = PLAZO_COBRO.cxc_id_cuenta 
    JOIN ACTOR ON CUENTA_POR_COBRAR.act_documento = actor.act_documento
    WHERE cxc_fecha_emision = p_fecha;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_buscar_cuenta_por_documento;
DELIMITER //
CREATE PROCEDURE sp_buscar_cuenta_por_documento(IN p_documento VARCHAR(20))
BEGIN
    SELECT  
        cuenta_por_cobrar.cxc_id_cuenta, 
        cxc_fecha_emision, 
        plcob_fecha_vencimiento, 
        plcob_plazo, 
        cxc_total_deuda, 
        plcob_valor_pagado, 
        plcob_estado_cobro, 
        actor.act_documento, 
        actor.act_nombre
    FROM CUENTA_POR_COBRAR 
    JOIN PLAZO_COBRO ON CUENTA_POR_COBRAR.cxc_id_cuenta = PLAZO_COBRO.cxc_id_cuenta 
    JOIN ACTOR ON CUENTA_POR_COBRAR.act_documento = actor.act_documento
    WHERE actor.act_documento = p_documento;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_filtrar_cuentas_en_curso;
DELIMITER //
CREATE PROCEDURE sp_filtrar_cuentas_en_curso()
BEGIN
    SELECT  
        cuenta_por_cobrar.cxc_id_cuenta, 
        cxc_fecha_emision, 
        plcob_fecha_vencimiento, 
        plcob_plazo, 
        cxc_total_deuda, 
        plcob_valor_pagado, 
        plcob_estado_cobro, 
        actor.act_documento, 
        actor.act_nombre
    FROM CUENTA_POR_COBRAR 
    JOIN PLAZO_COBRO ON CUENTA_POR_COBRAR.cxc_id_cuenta = PLAZO_COBRO.cxc_id_cuenta 
    JOIN ACTOR ON CUENTA_POR_COBRAR.act_documento = actor.act_documento
    WHERE plcob_estado_cobro = 'En curso';
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_filtrar_cuentas_vencidas;
DELIMITER //
CREATE PROCEDURE sp_filtrar_cuentas_vencidas()
BEGIN
    SELECT  
        cuenta_por_cobrar.cxc_id_cuenta, 
        cxc_fecha_emision, 
        plcob_fecha_vencimiento, 
        plcob_plazo, 
        cxc_total_deuda, 
        plcob_valor_pagado, 
        plcob_estado_cobro, 
        actor.act_documento, 
        actor.act_nombre
    FROM CUENTA_POR_COBRAR 
    JOIN PLAZO_COBRO ON CUENTA_POR_COBRAR.cxc_id_cuenta = PLAZO_COBRO.cxc_id_cuenta 
    JOIN ACTOR ON CUENTA_POR_COBRAR.act_documento = actor.act_documento
    WHERE plcob_estado_cobro = 'Vencido';
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_filtrar_cuentas_pagadas;
DELIMITER //
CREATE PROCEDURE sp_filtrar_cuentas_pagadas()
BEGIN
    SELECT  
        cuenta_por_cobrar.cxc_id_cuenta, 
        cxc_fecha_emision, 
        plcob_fecha_vencimiento, 
        plcob_plazo, 
        cxc_total_deuda, 
        plcob_valor_pagado, 
        plcob_estado_cobro, 
        actor.act_documento, 
        actor.act_nombre
    FROM CUENTA_POR_COBRAR 
    JOIN PLAZO_COBRO ON CUENTA_POR_COBRAR.cxc_id_cuenta = PLAZO_COBRO.cxc_id_cuenta 
    JOIN ACTOR ON CUENTA_POR_COBRAR.act_documento = actor.act_documento
    WHERE plcob_estado_cobro = 'Pagada';
END //
DELIMITER ;






