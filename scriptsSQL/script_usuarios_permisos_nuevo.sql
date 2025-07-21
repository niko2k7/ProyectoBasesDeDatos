-- Script para la creación de usuarios, roles y asignación de permisos en la base de datos 

-- 1. Eliminar usuarios y roles existentes si ya existen (para evitar errores en ejecuciones repetidas)
-- ¡ADVERTENCIA!: Esto eliminará los usuarios y roles si existen (usar con precaución).
DROP USER IF EXISTS 'admin_user'@'localhost';
DROP USER IF EXISTS 'gerente_user'@'localhost';
DROP USER IF EXISTS 'ventas_user'@'localhost';
DROP USER IF EXISTS 'contabilidad_user'@'localhost';
DROP USER IF EXISTS 'almacen_taller_user'@'localhost';

DROP ROLE IF EXISTS 'rol_administrador'@'localhost';
DROP ROLE IF EXISTS 'rol_gerente'@'localhost';
DROP ROLE IF EXISTS 'rol_ventas'@'localhost';
DROP ROLE IF EXISTS 'rol_contabilidad'@'localhost';
DROP ROLE IF EXISTS 'rol_almacen_taller'@'localhost';


-- 2. Crear los ROLES
CREATE ROLE 'rol_administrador'@'localhost';
CREATE ROLE 'rol_gerente'@'localhost';
CREATE ROLE 'rol_ventas'@'localhost';
CREATE ROLE 'rol_contabilidad'@'localhost';
CREATE ROLE 'rol_almacen_taller'@'localhost';


-- 3. Asignar permisos a cada ROL

-- 3.1. Permisos para 'rol_administrador'
-- Acceso total a todas las funcionalidades y datos del sistema.
GRANT ALL PRIVILEGES ON proyecto_base_datos.* TO 'rol_administrador'@'localhost';

-- 3.2. Permisos para 'rol_gerente'
-- Visión completa de operaciones (reportes, análisis). Solo lectura.
GRANT SELECT ON proyecto_base_datos.* TO 'rol_gerente'@'localhost';

-- 3.3. Permisos para 'rol_ventas'
-- Registro de facturas de venta, consulta de productos, gestión de clientes, seguimiento de cuentas por cobrar.
-- No acceso a costos de compra o salarios.
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.ACTOR TO 'rol_ventas'@'localhost';
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.CLIENTE TO 'rol_ventas'@'localhost';
GRANT SELECT, INSERT ON proyecto_base_datos.FACTURA_VENTA TO 'rol_ventas'@'localhost';
GRANT SELECT, INSERT ON proyecto_base_datos.DETALLE_FACTURA_VENTA TO 'rol_ventas'@'localhost';
GRANT SELECT ON proyecto_base_datos.PRODUCTO TO 'rol_ventas'@'localhost'; -- Solo consulta de productos (incluye precios de venta)
GRANT SELECT ON proyecto_base_datos.SERVICIO TO 'rol_ventas'@'localhost';   -- Para consultar stock
GRANT SELECT, UPDATE ON proyecto_base_datos.ARTICULO TO 'rol_ventas'@'localhost';   -- Para consultar stock
GRANT SELECT ON proyecto_base_datos.CUENTA_POR_COBRAR TO 'rol_ventas'@'localhost'; -- Creación de cuentas por cobrar al vender a crédito
GRANT SELECT ON proyecto_base_datos.PLAZO_COBRO TO 'rol_ventas'@'localhost'; -- Registrar plazos y actualizar estados de cuotas

-- Permisos de VISTAS específicos para 'rol_ventas'
GRANT SELECT ON proyecto_base_datos.Vista_Inventario_Consulta TO 'rol_ventas'@'localhost';
GRANT SELECT ON proyecto_base_datos.Vista_Cuentas_Cobrar_Resumen TO 'rol_ventas'@'localhost';

-- Permisos de PA
GRANT EXECUTE ON PROCEDURE sp_obtener_articulos TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_obtener_servicios TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_eliminar_articulo TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_eliminar_servicio TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_buscar_articulos_por_tipo TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_buscar_articulos_por_marca TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_buscar_articulos_por_modelo TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_filtrar_stock_critico TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_filtrar_sin_stock TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_obtener_facturas_venta TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_buscar_factura_por_codigo TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_buscar_facturas_por_fecha TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_buscar_facturas_por_intervalo TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_buscar_factura_por_documento TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_filtrar_facturas_efectivo TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_filtrar_facturas_tarjeta TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_filtrar_facturas_transferencia TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_obtener_datos_cliente TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_cargar_articulos_factura TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_cargar_servicios_factura TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_obtener_actor_por_documento TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_cargar_cuentas_por_cobrar TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_buscar_cuenta_por_id TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_buscar_cuenta_por_fecha_emision TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_buscar_cuenta_por_documento TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_filtrar_cuentas_en_curso TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_filtrar_cuentas_vencidas TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE sp_filtrar_cuentas_pagadas TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE proyecto_base_datos.sp_crear_factura_venta TO 'rol_ventas'@'localhost';
GRANT EXECUTE ON PROCEDURE proyecto_base_datos.sp_agregar_detalle_venta TO 'rol_ventas'@'localhost';









-- 3.4. Permisos para 'rol_contabilidad'
-- Gestión de cuentas por pagar, cuentas por cobrar, liquidación de empleados, reportes financieros.
-- Acceso detallado a transacciones monetarias.
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.ACTOR TO 'rol_contabilidad'@'localhost';
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.PROVEEDOR TO 'rol_contabilidad'@'localhost';
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.FACTURA_COMPRA TO 'rol_contabilidad'@'localhost';
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.DETALLE_FACTURA_COMPRA TO 'rol_contabilidad'@'localhost';
GRANT SELECT ON proyecto_base_datos.FACTURA_VENTA TO 'rol_contabilidad'@'localhost';
GRANT SELECT ON proyecto_base_datos.DETALLE_FACTURA_VENTA TO 'rol_contabilidad'@'localhost';
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.PAGO_SALARIO TO 'rol_contabilidad'@'localhost'; -- Liquidación de empleados
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.CUENTA_POR_COBRAR TO 'rol_contabilidad'@'localhost';
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.PLAZO_COBRO TO 'rol_contabilidad'@'localhost';
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.CUENTA_POR_PAGAR TO 'rol_contabilidad'@'localhost';
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.PLAZO_PAGO TO 'rol_contabilidad'@'localhost';
GRANT SELECT ON proyecto_base_datos.CLIENTE TO 'rol_contabilidad'@'localhost'; -- Consulta de clientes para conciliaciones

-- Permisos de VISTAS específicos para 'rol_contabilidad'
GRANT SELECT ON proyecto_base_datos.Vista_Ventas_Historico TO 'rol_contabilidad'@'localhost';
GRANT SELECT ON proyecto_base_datos.Vista_Cuentas_Cobrar_Resumen TO 'rol_contabilidad'@'localhost';
GRANT SELECT ON proyecto_base_datos.Vista_Cuentas_Pagar_Resumen TO 'rol_contabilidad'@'localhost';
GRANT SELECT ON proyecto_base_datos.Vista_Nomina_Resumen TO 'rol_contabilidad'@'localhost';

-- 3.5. Permisos para 'rol_almacen_taller'
-- Gestión y consulta de materiales y herramientas, registro de prestación de servicios.
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.MATERIAL_HERRAMIENTA TO 'rol_almacen_taller'@'localhost';
GRANT SELECT ON proyecto_base_datos.PRODUCTO TO 'rol_almacen_taller'@'localhost'; -- Para identificar productos para servicios
GRANT SELECT, UPDATE ON proyecto_base_datos.ARTICULO TO 'rol_almacen_taller'@'localhost'; -- Actualizar stock
GRANT SELECT ON proyecto_base_datos.SERVICIO TO 'rol_almacen_taller'@'localhost'; -- Consultar tipos de servicio
GRANT SELECT, INSERT ON proyecto_base_datos.SERVICIO_HAS_EMPLEADO TO 'rol_almacen_taller'@'localhost'; -- Registrar que un empleado prestó un servicio (si esta es la tabla de registro)
GRANT SELECT ON proyecto_base_datos.DETALLE_FACTURA_VENTA TO 'rol_almacen_taller'@'localhost'; -- Si necesitan verificar detalles de una venta de servicio

-- Permisos de VISTAS específicos para 'rol_almacen_taller'
GRANT SELECT ON proyecto_base_datos.Vista_Inventario_Consulta TO 'rol_almacen_taller'@'localhost';
GRANT SELECT ON proyecto_base_datos.Vista_Servicios_Realizados TO 'rol_almacen_taller'@'localhost';


-- 4. Crear los USUARIOS con contraseñas seguras
-- En un entorno real, usa contraseñas más complejas y considera restricciones de host si no es 'localhost'.
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'admin_pass_123';
CREATE USER 'gerente_user'@'localhost' IDENTIFIED BY 'gerente_pass_123';
CREATE USER 'ventas_user'@'localhost' IDENTIFIED BY 'ventas_pass_123';
CREATE USER 'contabilidad_user'@'localhost' IDENTIFIED BY 'contabilidad_pass_123';
CREATE USER 'almacen_taller_user'@'localhost' IDENTIFIED BY 'almacen_pass_123';


-- 5. Asignar los ROLES a los USUARIOS
GRANT 'rol_administrador'@'localhost' TO 'admin_user'@'localhost';
GRANT 'rol_gerente'@'localhost' TO 'gerente_user'@'localhost';
GRANT 'rol_ventas'@'localhost' TO 'ventas_user'@'localhost';
GRANT 'rol_contabilidad'@'localhost' TO 'contabilidad_user'@'localhost';
GRANT 'rol_almacen_taller'@'localhost' TO 'almacen_taller_user'@'localhost';


-- 6. Establecer el rol por defecto al iniciar sesión 
-- Esto permite que los usuarios tengan los permisos del rol automáticamente al conectarse.
SET DEFAULT ROLE ALL TO
    'admin_user'@'localhost',
    'gerente_user'@'localhost',
    'ventas_user'@'localhost',
    'contabilidad_user'@'localhost',
    'almacen_taller_user'@'localhost';


-- 7. Refrescar los privilegios para que los cambios surtan efecto
FLUSH PRIVILEGES;

