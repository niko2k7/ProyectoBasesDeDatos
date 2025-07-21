use proyecto_base_datos;

-- Este trigger modifica automaticamente el stock una vez se realiza una venta 
DROP TRIGGER IF EXISTS venta_stock;
DELIMITER // 
CREATE TRIGGER Venta_stock AFTER INSERT ON detalle_factura_venta
FOR EACH ROW
BEGIN
	UPDATE articulo SET art_cantidad_disponible = art_cantidad_disponible - new.dfv_cantidad 
    where articulo.prod_id = new.prod_id;
END // 
DELIMITER ;


-- Este trigger modifica automaticamente el stock una vez se realiza una compra  
DROP TRIGGER IF EXISTS compra_stock;
DELIMITER // 
CREATE TRIGGER compra_stock AFTER INSERT ON detalle_factura_compra
FOR EACH ROW
BEGIN
	UPDATE articulo SET art_cantidad_disponible = art_cantidad_disponible + new.dfc_cantidad 
    where articulo.prod_id = new.prod_id;
END // 
DELIMITER ;

-- este trigger se activa con cada insercion en actor, si la insercion es del tipo cliente o proveedor automaticamente
-- hace una insercion en estas tablas para mantener la integridad de los datos. Si es del tipo empleado lanza un error 
-- para que la insercion se haga desde un procedimiento almacenado. 
DROP TRIGGER IF EXISTS insert_actor;
DELIMITER // 
CREATE TRIGGER insert_actor AFTER INSERT ON actor
for each row 
BEGIN 

	declare msg varchar(255);

	CASE
    WHEN new.act_tipo='CLIENTE' THEN 
    INSERT INTO cliente values (new.act_documento);
    INSERT INTO cuenta_por_cobrar (cxc_fecha_emision,cxc_total_deuda,cxc_saldo,act_documento) VALUES 
    (curdate(), 0, 0, new.act_documento);
    WHEN new.act_tipo='PROVEEDOR' THEN
    INSERT INTO proveedor VALUES (new.act_documento);
    INSERT INTO cuenta_por_pagar (cxp_fecha_emision,cxp_total_deuda,cxp_saldo,act_documento) VALUES 
    (curdate(), 0, 0, new.act_documento);
    WHEN new.act_tipo='EMPLEADO' THEN 
    SET msg = 'Solo se pueden realizar inserciones de empleados a traves del procedimiento almacenado crear_empleado';
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END CASE;
END //
DELIMITER ;

-- checks para actor 

ALTER TABLE actor
ADD CONSTRAINT CHK_TELEFONO CHECK (act_telefono REGEXP '^[0-9]+$');

ALTER TABLE actor
ADD CONSTRAINT CHK_correo CHECK (act_correo LIKE '%@%.%');

-- actualizar total de una factura a partir de los subtotales del detalle 
DROP TRIGGER IF EXISTS total_factura;
delimiter // 
CREATE TRIGGER total_factura AFTER insert on detalle_factura_venta
FOR EACH ROW 
BEGIN 
	update factura_venta SET fven_total = fven_total + new.dfv_subtotal 
    WHERE factura_venta.fven_codigo = new.fven_codigo;
END // 
delimiter ;
DROP TRIGGER IF EXISTS total_factura_compra;
delimiter // 
CREATE TRIGGER total_factura_compra AFTER insert on detalle_factura_compra
FOR EACH ROW 
BEGIN 
	update factura_compra SET fcom_total = fcom_total + new.dfc_subtotal 
    WHERE factura_compra.fcom_codigo = new.fcom_codigo;
END // 
delimiter ;


-- automatizacion de plazo pago y factura compra 
DROP TRIGGER IF EXISTS plazos_factura;
DELIMITER // 
CREATE TRIGGER plazos_factura AFTER INSERT ON factura_compra
for each row
begin
	DECLARE cuenta int;
    SELECT cxp_id_cuenta into cuenta 
    FROM cuenta_por_pagar NATURAL JOIN actor where act_documento = new.act_documento;
    IF cuenta IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se encontró cuenta_por_pagar para este documento';
    END IF;
    if new.fcom_metodo_pago = 'Credito' THEN 
	insert into plazo_pago (cxp_id_cuenta, plpag_plazo, plpag_fecha_vencimiento, plpag_valor_cuota, plpag_valor_pagado, plpag_estado_pago) 
    VALUES
		(cuenta, 30, DATE_ADD(CURDATE(), INTERVAL 30 DAY), NEW.fcom_total/3, 0, 'En curso'),
        (cuenta, 60, DATE_ADD(CURDATE(), INTERVAL 60 DAY), NEW.fcom_total/3, 0, 'En curso'),
        (cuenta, 90, DATE_ADD(CURDATE(), INTERVAL 90 DAY), NEW.fcom_total/3, 0, 'En curso');
	END IF;
END// 
delimiter ;

-- actualizacion de factura 
DROP TRIGGER IF EXISTS plazos_factura_actualizar
DELIMITER //
CREATE TRIGGER plazos_factura_actualizar AFTER UPDATE ON factura_compra 
for each row 
	BEGIN
    DECLARE cuenta INT;
    SELECT cxp_id_cuenta into cuenta 
    FROM cuenta_por_pagar NATURAL JOIN actor where act_documento = new.act_documento;
    update plazo_pago SET plpag_valor_cuota = new.fcom_total/3 WHERE cxp_id_cuenta=cuenta;
    END // 
DELIMITER ;
