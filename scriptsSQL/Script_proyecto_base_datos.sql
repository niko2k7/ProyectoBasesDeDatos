SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS proyecto_base_datos;
CREATE SCHEMA IF NOT EXISTS proyecto_base_datos;
USE proyecto_base_datos;


-- -----------------------------------------------------
-- Tabla `ACTOR`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ACTOR;
CREATE TABLE IF NOT EXISTS ACTOR (
  act_documento 		INT NOT NULL COMMENT 'Cedula que tiene toda persona (o NIT en caso de empresa)',
  act_tipo 				ENUM('CLIENTE', 'EMPLEADO', 'PROVEEDOR') NOT NULL COMMENT 'Funciona como discriminador de tipo, es decir, para dictar si el actor es un cliente, empleado o proveedor.',
  act_nombre 			VARCHAR(45) NOT NULL COMMENT 'Nombre de la persona o empresa',
  act_direccion 		VARCHAR(45) NOT NULL COMMENT 'Direccion de la persona o empresa',
  act_telefono 			VARCHAR(13) NOT NULL COMMENT 'Telefono de la persona o empresa',
  act_correo 			VARCHAR(45) NOT NULL UNIQUE COMMENT 'Correo de la persona o empresa',
  act_estado_juridico 	ENUM('NATURAL', 'JURIDICA') NOT NULL COMMENT 'Estado juridico de la persona o empresa: natural o juridica. Lo ideal seria usar un ENUM',
  PRIMARY KEY (act_documento)
);


-- -----------------------------------------------------
-- Tabla `CLIENTE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS CLIENTE;
CREATE TABLE IF NOT EXISTS CLIENTE(
  act_documento 	INT NOT NULL,
  
  PRIMARY KEY(act_documento),
  FOREIGN KEY (act_documento) REFERENCES ACTOR (act_documento)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Tabla `PROVEEDOR`
-- -----------------------------------------------------
DROP TABLE IF EXISTS PROVEEDOR ;

CREATE TABLE IF NOT EXISTS PROVEEDOR (
  act_documento INT NOT NULL,
  
  PRIMARY KEY (act_documento),
  FOREIGN KEY (act_documento) REFERENCES ACTOR (act_documento)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Tabla `EMPLEADO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS EMPLEADO ;

CREATE TABLE IF NOT EXISTS EMPLEADO (
  act_documento 	INT NOT NULL,
  emp_puesto 		VARCHAR(45) NOT NULL COMMENT 'Puesto que representa la funcion del empleado',
  
  PRIMARY KEY (act_documento),
  FOREIGN KEY (act_documento) REFERENCES ACTOR (act_documento)
  ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Tabla `HORARIO_EMPLEADO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS HORARIO_EMPLEADO ;

CREATE TABLE IF NOT EXISTS HORARIO_EMPLEADO (
  hor_id 					INT NOT NULL COMMENT 'Id del horario que se asignara a cada empleado',
  act_documento 			INT NOT NULL,
  hor_num_dias_laborales 	TINYINT NOT NULL COMMENT 'Cuantos dias trabaja el empleado',
  hor_hora_inicio 			TIME NOT NULL COMMENT 'Hora en que inicia la jornada laboral',
  hor_hora_fin 				TIME NOT NULL COMMENT 'Hora en que acaba la jornada laboral',
  
  PRIMARY KEY (hor_id, act_documento),
  FOREIGN KEY (act_documento) REFERENCES EMPLEADO (act_documento)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Tabla `PRODUCTO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS PRODUCTO;

CREATE TABLE IF NOT EXISTS PRODUCTO (
  prod_id 		INT NOT NULL AUTO_INCREMENT COMMENT 'Id unico que sirve para identificar el producto',
  prod_tipo 	ENUM('ARTICULO', 'SERVICIO') NOT NULL COMMENT 'Funciona como discriminador de tipo, es decir, dicta si el producto es un servicio o un articulo. Lo ideal seria usar un ENUM',
  prod_precio 	DECIMAL(10,2) NOT NULL COMMENT 'Precio del producto',
  
  PRIMARY KEY (prod_id)
);


-- -----------------------------------------------------
-- Tabla `FACTURA_VENTA`
-- -----------------------------------------------------
DROP TABLE IF EXISTS FACTURA_VENTA;

CREATE TABLE IF NOT EXISTS FACTURA_VENTA (
  fven_codigo 		INT NOT NULL AUTO_INCREMENT COMMENT 'Codigo unico para identificar cada factura',
  fven_fecha 		DATE NOT NULL COMMENT 'Fecha en que se genera la factura',
  fven_total 		DECIMAL(10,2) NOT NULL COMMENT 'Valor total a pagar',
  fven_metodo_pago 	VARCHAR(45) NOT NULL COMMENT 'Metodo de pago usado al pagar',
  act_documento 	INT NOT NULL,
  
  PRIMARY KEY (fven_codigo),
  FOREIGN KEY (act_documento) REFERENCES CLIENTE (act_documento)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Tabla `DETALLE_FACTURA_VENTA`
-- -----------------------------------------------------
DROP TABLE IF EXISTS DETALLE_FACTURA_VENTA;

CREATE TABLE IF NOT EXISTS DETALLE_FACTURA_VENTA (
  fven_codigo 			INT NOT NULL,
  prod_id				INT NOT NULL,
  dfv_cantidad 			INT NOT NULL COMMENT 'Cantidad comprada de un producto por un cliente',
  dfv_precio_unitario 	DECIMAL(10,2) NOT NULL COMMENT 'Precio unitario del producto',
  dfv_subtotal 			DECIMAL(10,2) NOT NULL COMMENT 'Subtotal que sale de cantidad*precio_unitario',
  
  PRIMARY KEY (fven_codigo, prod_id),
  FOREIGN KEY (fven_codigo) REFERENCES FACTURA_VENTA (fven_codigo)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (prod_id) REFERENCES PRODUCTO (prod_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Tabla `FACTURA_COMPRA`
-- -----------------------------------------------------
DROP TABLE IF EXISTS FACTURA_COMPRA;

CREATE TABLE IF NOT EXISTS FACTURA_COMPRA (
  fcom_codigo 		INT NOT NULL AUTO_INCREMENT COMMENT 'Codigo unico para identificar cada factura',
  fcom_fecha	 	DATE NOT NULL COMMENT 'Fecha en que se genera la factura',
  fcom_total 		DECIMAL(10,2) NOT NULL COMMENT 'Valor total a pagar',
  fcom_metodo_pago 	VARCHAR(45) NOT NULL COMMENT 'Metodo de pago usado al pagar',
  act_documento 	INT NOT NULL,
  
  PRIMARY KEY (fcom_codigo),
  FOREIGN KEY (act_documento) REFERENCES PROVEEDOR (act_documento)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Tabla `DETALLE_FACTURA_COMPRA`
-- -----------------------------------------------------
DROP TABLE IF EXISTS DETALLE_FACTURA_COMPRA;

CREATE TABLE IF NOT EXISTS DETALLE_FACTURA_COMPRA (
  fcom_codigo 			INT NOT NULL,
  prod_id				INT NOT NULL,
  dfc_cantidad 			INT NOT NULL COMMENT 'Cantidad comprada de un producto por la empresa',
  dfc_precio_unitario 	DECIMAL(10,2) NOT NULL COMMENT 'Precio unitario del producto',
  dfc_subtotal 			DECIMAL(10,2) NOT NULL COMMENT 'Subtotal que sale de cantidad*precio_unitario',
  
  PRIMARY KEY (fcom_codigo, prod_id),
  FOREIGN KEY (fcom_codigo) REFERENCES FACTURA_COMPRA (fcom_codigo)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (prod_id) REFERENCES PRODUCTO (prod_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Tabla `PAGO_SALARIO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS PAGO_SALARIO;

CREATE TABLE IF NOT EXISTS PAGO_SALARIO (
  pag_numero_pago 	INT NOT NULL AUTO_INCREMENT COMMENT 'Numero de liquidacion unico para cada empleado',
  act_documento 	INT NOT NULL,
  pag_fecha 		DATE NOT NULL COMMENT 'Fecha en que se hizo la liquidacion',
  pag_salario_base 	DECIMAL(10,2) NOT NULL COMMENT 'Salario base del empleado',
  pag_comisiones 	TINYINT NOT NULL COMMENT 'Porcentaje por comisiones',
  pag_anticipos 	DECIMAL(10,2) NOT NULL COMMENT 'Cuanto se le hizo de anticipos al empleado que se restara de su salario',
  pag_total 		DECIMAL(10,2) NOT NULL COMMENT 'Total que se le pagara al empleado',
  
  PRIMARY KEY (pag_numero_pago),
  FOREIGN KEY (act_documento) REFERENCES EMPLEADO (act_documento)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Tabla `CUENTA_POR_COBRAR`
-- -----------------------------------------------------
DROP TABLE IF EXISTS CUENTA_POR_COBRAR;

CREATE TABLE IF NOT EXISTS CUENTA_POR_COBRAR (
  cxc_id_cuenta 		INT NOT NULL AUTO_INCREMENT COMMENT 'Id unico para identificar las cuentas por cobrar',
  cxc_fecha_emision 	DATE NOT NULL COMMENT 'Fecha en la que se genera la cuenta por cobrar',
  cxc_total_deuda 		DECIMAL(10,2) NOT NULL COMMENT 'Representa el valor total a pagar',
  cxc_saldo 			DECIMAL(10,2) NOT NULL COMMENT 'Dinero que el cliente tiene pendiente por pagar',
  act_documento 		INT NOT NULL,
  
  PRIMARY KEY (cxc_id_cuenta),
  FOREIGN KEY (act_documento) REFERENCES CLIENTE (act_documento)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Tabla `CUENTA_POR_PAGAR`
-- -----------------------------------------------------
DROP TABLE IF EXISTS CUENTA_POR_PAGAR;

CREATE TABLE IF NOT EXISTS CUENTA_POR_PAGAR (
  cxp_id_cuenta 		INT NOT NULL AUTO_INCREMENT COMMENT 'Id unico para identificar las cuentas por pagar',
  cxp_fecha_emision 	DATE NOT NULL COMMENT 'Fecha en la que se genera la cuenta por pagar',
  cxp_total_deuda 		DECIMAL(10,2) NOT NULL COMMENT 'Representa el valor total a pagar',
  cxp_saldo 			DECIMAL(10,2) NOT NULL COMMENT 'Dinero que la empresa tiene pendiente por pagar',
  act_documento 		INT NOT NULL,
  
  PRIMARY KEY (cxp_id_cuenta),
  FOREIGN KEY (act_documento) REFERENCES PROVEEDOR (act_documento)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Tabla `ARTICULO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS ARTICULO;

CREATE TABLE IF NOT EXISTS ARTICULO (
  prod_id 					INT NOT NULL,
  art_tipo 					VARCHAR(45) NOT NULL COMMENT 'Tipo del articulo',
  art_marca 				VARCHAR(45) NOT NULL COMMENT 'Marca del articulo',
  art_modelo 				VARCHAR(45) NOT NULL COMMENT 'Modelo del articulo',
  art_cantidad_disponible 	INT NOT NULL COMMENT 'Stock del articulo',
  
  PRIMARY KEY (prod_id),
  FOREIGN KEY (prod_id) REFERENCES PRODUCTO (prod_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Tabla `SERVICIO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS SERVICIO;

CREATE TABLE IF NOT EXISTS SERVICIO (
  prod_id 			INT NOT NULL,
  serv_nombre 		VARCHAR(45) NOT NULL COMMENT 'Nombre del servicio que se realiza',
  serv_descripcion 	VARCHAR(90) NOT NULL COMMENT 'Descripcion del servicio que se realiza',
  act_documento 	INT NOT NULL,
  
  PRIMARY KEY (prod_id),
  FOREIGN KEY (prod_id) REFERENCES PRODUCTO (prod_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (act_documento) REFERENCES EMPLEADO (act_documento)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Tabla `SERVICIO_HAS_EMPLADO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS SERVICIO_HAS_EMPLEADO;

CREATE TABLE IF NOT EXISTS SERVICIO_HAS_EMPLEADO (
  prod_id 			INT NOT NULL,
  act_documento		INT NOT NULL,
  
  PRIMARY KEY (prod_id, act_documento),
  FOREIGN KEY (prod_id) REFERENCES SERVICIO (prod_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (act_documento) REFERENCES EMPLEADO (act_documento)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- -----------------------------------------------------
-- Tabla `MATERIAL_HERRAMIENTA`
-- -----------------------------------------------------
DROP TABLE IF EXISTS MATERIAL_HERRAMIENTA;

CREATE TABLE IF NOT EXISTS MATERIAL_HERRAMIENTA (
  mat_id 			INT NOT NULL AUTO_INCREMENT COMMENT 'Id de las herramientas que usa la empresa ',
  mat_nombre 		VARCHAR(45) NOT NULL COMMENT 'Nombre de la herramienta',
  mat_descripcion 	VARCHAR(45) NOT NULL COMMENT 'Descripcion de para que se usa la herramienta',
  mat_cantidad 		INT NOT NULL COMMENT 'Cantidad que se tiene de esta herramienta',
  mat_costo 		DECIMAL(10,2) NOT NULL COMMENT 'Costo de la herramienta',
  
  PRIMARY KEY (mat_id)
);


-- -----------------------------------------------------
-- Tabla `SERVICIO_has_MATERIAL_HERRAMIENTA`
-- -----------------------------------------------------
DROP TABLE IF EXISTS SERVICIO_has_MATERIAL_HERRAMIENTA;

CREATE TABLE IF NOT EXISTS SERVICIO_has_MATERIAL_HERRAMIENTA (
  prod_id 	INT NOT NULL,
  mat_id 	INT NOT NULL,
  
  PRIMARY KEY (prod_id, mat_id),
  FOREIGN KEY (prod_id) REFERENCES SERVICIO (prod_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (mat_id) REFERENCES MATERIAL_HERRAMIENTA (mat_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Tabla `PLAZO_COBRO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS PLAZO_COBRO;

CREATE TABLE IF NOT EXISTS PLAZO_COBRO (
  plcob_id 					INT NOT NULL AUTO_INCREMENT COMMENT 'Id unico para identificar un plazo de cobro',
  cxc_id_cuenta 			INT NOT NULL,
  plcob_plazo 				INT NOT NULL COMMENT 'Plazo en dias que tiene el cliente para pagar la cuenta por cobrar',
  plcob_fecha_vencimiento 	DATE NOT NULL COMMENT 'Fecha de vencimiento que tiene la cuenta por cobrar dependiendo del plazo',
  plcob_valor_cuota 		DECIMAL(10,2) NOT NULL COMMENT 'Valor de la cuota que el cliente debe pagar cada mes',
  plcob_valor_pagado 		DECIMAL(10,2) NOT NULL COMMENT 'Valor total de los abonos que el cliente ha pagado',
  plcob_estado_cobro 		ENUM('PAGADO', 'EN CURSO', 'VENCIDO') NOT NULL COMMENT 'Estado del cobro: Pagado, Vencido, o En Curso. Lo ideal seria usasr un ENUM',
  plcob_fecha_pago_final 	DATE NULL COMMENT 'Fecha en que el cliente pago en su totalidad la cuenta por cobrar',
  
  PRIMARY KEY (plcob_id, cxc_id_cuenta),
  FOREIGN KEY (cxc_id_cuenta) REFERENCES CUENTA_POR_COBRAR (cxc_id_cuenta)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Tabla `PLAZO_PAGO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS PLAZO_PAGO;

CREATE TABLE IF NOT EXISTS PLAZO_PAGO (
  plpag_id 					INT NOT NULL AUTO_INCREMENT COMMENT 'Id unico para identificar un plazo de cobro',
  cxp_id_cuenta 			INT NOT NULL,
  plpag_plazo 				INT NOT NULL COMMENT 'Plazo en dias que tiene la empresa para pagar la cuenta por pagar',
  plpag_fecha_vencimiento 	DATE NOT NULL COMMENT 'Fecha de vencimiento que tiene la cuenta por pagar dependiendo del plazo',
  plpag_valor_cuota 		DECIMAL(10,2) NOT NULL COMMENT 'Valor de la cuota que la empresa debe pagar cada mes',
  plpag_valor_pagado 		DECIMAL(10,2) NOT NULL COMMENT 'Valor total de los abonos que la empresa ha pagado',
  plpag_estado_pago 		ENUM('PAGADO', 'EN CURSO', 'VENCIDO') NOT NULL COMMENT 'Estado del pago: Pagado, Vencido, o En Curso. Lo ideal seria usasr un ENUM',
  plpag_fecha_pago_final 	DATE NULL COMMENT 'Fecha en que la empresa pago en su totalidad la cuenta por pagar',
  
  PRIMARY KEY (plpag_id, cxp_id_cuenta),
  FOREIGN KEY (cxp_id_cuenta) REFERENCES CUENTA_POR_PAGAR (cxp_id_cuenta)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
