-- Script para la creación de usuarios y asignación de permisos en la base de datos 'proyecto_base_datos'

-- 1. Eliminar usuarios existentes si ya existen (para evitar errores en ejecuciones repetidas)
-- ¡ADVERTENCIA!: Esto eliminará los usuarios si existen. Usar con precaución en entornos de producción.
DROP USER IF EXISTS 'admin_user'@'localhost';
DROP USER IF EXISTS 'gerente_user'@'localhost';
DROP USER IF EXISTS 'ventas_user'@'localhost';
DROP USER IF EXISTS 'contabilidad_user'@'localhost';
DROP USER IF EXISTS 'almacen_taller_user'@'localhost';


-- 2. Crear los usuarios con contraseñas seguras (ejemplo: 'password_segura')
-- En un entorno real, usa contraseñas más complejas y considera restricciones de host si no es 'localhost'.
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'admin_pass_123';
CREATE USER 'gerente_user'@'localhost' IDENTIFIED BY 'gerente_pass_123';
CREATE USER 'ventas_user'@'localhost' IDENTIFIED BY 'ventas_pass_123';
CREATE USER 'contabilidad_user'@'localhost' IDENTIFIED BY 'contabilidad_pass_123';
CREATE USER 'almacen_taller_user'@'localhost' IDENTIFIED BY 'almacen_pass_123';

-- 3. Asignar permisos a cada perfil

-- 3.1. Permisos para 'Administrador del Sistema'
-- Acceso total a todas las funcionalidades y datos del sistema.
GRANT ALL PRIVILEGES ON proyecto_base_datos.* TO 'admin_user'@'localhost';

-- 3.2. Permisos para 'Gerente/Dueño del Negocio'
-- Visión completa de operaciones (reportes, análisis). Solo lectura.
GRANT SELECT ON proyecto_base_datos.* TO 'gerente_user'@'localhost';

-- 3.3. Permisos para 'Personal de Ventas'
-- Registro de facturas de venta, consulta de productos, gestión de clientes, seguimiento de cuentas por cobrar.
-- No acceso a costos de compra o salarios.
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.ACTOR TO 'ventas_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.CLIENTE TO 'ventas_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.FACTURA_VENTA TO 'ventas_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.DETALLE_FACTURA_VENTA TO 'ventas_user'@'localhost';
GRANT SELECT ON proyecto_base_datos.PRODUCTO TO 'ventas_user'@'localhost'; -- Solo consulta de productos (incluye precios de venta)
GRANT SELECT ON proyecto_base_datos.ARTICULO TO 'ventas_user'@'localhost';   -- Para consultar stock
GRANT SELECT, INSERT ON proyecto_base_datos.CUENTA_POR_COBRAR TO 'ventas_user'@'localhost'; -- Creación de cuentas por cobrar al vender a crédito
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.PLAZO_COBRO TO 'ventas_user'@'localhost'; -- Registrar plazos y actualizar estados de cuotas

-- ***************************************************************
-- Permisos de VISTAS específicos para 'Personal de Ventas'
-- ***************************************************************
GRANT SELECT ON proyecto_base_datos.Vista_Inventario_Consulta TO 'ventas_user'@'localhost';
GRANT SELECT ON proyecto_base_datos.Vista_Cuentas_Cobrar_Resumen TO 'ventas_user'@'localhost';


-- 3.4. Permisos para 'Personal de Contabilidad/Finanzas'
-- Gestión de cuentas por pagar, cuentas por cobrar, liquidación de empleados, reportes financieros.
-- Acceso detallado a transacciones monetarias.
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.ACTOR TO 'contabilidad_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.PROVEEDOR TO 'contabilidad_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.FACTURA_COMPRA TO 'contabilidad_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.DETALLE_FACTURA_COMPRA TO 'contabilidad_user'@'localhost';
GRANT SELECT ON proyecto_base_datos.FACTURA_VENTA TO 'contabilidad_user'@'localhost';
GRANT SELECT ON proyecto_base_datos.DETALLE_FACTURA_VENTA TO 'contabilidad_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.PAGO_SALARIO TO 'contabilidad_user'@'localhost'; -- Liquidación de empleados
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.CUENTA_POR_COBRAR TO 'contabilidad_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.PLAZO_COBRO TO 'contabilidad_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.CUENTA_POR_PAGAR TO 'contabilidad_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.PLAZO_PAGO TO 'contabilidad_user'@'localhost';
GRANT SELECT ON proyecto_base_datos.CLIENTE TO 'contabilidad_user'@'localhost'; -- Consulta de clientes para conciliaciones

-- ***************************************************************
-- Permisos de VISTAS específicos para 'Personal de Contabilidad/Finanzas'
-- ***************************************************************
GRANT SELECT ON proyecto_base_datos.Vista_Ventas_Historico TO 'contabilidad_user'@'localhost';
GRANT SELECT ON proyecto_base_datos.Vista_Cuentas_Cobrar_Resumen TO 'contabilidad_user'@'localhost';
GRANT SELECT ON proyecto_base_datos.Vista_Cuentas_Pagar_Resumen TO 'contabilidad_user'@'localhost';
GRANT SELECT ON proyecto_base_datos.Vista_Nomina_Resumen TO 'contabilidad_user'@'localhost';


-- 3.5. Permisos para 'Personal de Almacén/Taller (Servicios y Materiales)'
-- Gestión y consulta de materiales y herramientas, registro de prestación de servicios.
GRANT SELECT, INSERT, UPDATE ON proyecto_base_datos.MATERIAL_HERRAMIENTA TO 'almacen_taller_user'@'localhost';
GRANT SELECT ON proyecto_base_datos.PRODUCTO TO 'almacen_taller_user'@'localhost'; -- Para identificar productos para servicios
GRANT SELECT, UPDATE ON proyecto_base_datos.ARTICULO TO 'almacen_taller_user'@'localhost'; -- Actualizar stock
GRANT SELECT ON proyecto_base_datos.SERVICIO TO 'almacen_taller_user'@'localhost'; -- Consultar tipos de servicio
GRANT SELECT, INSERT ON proyecto_base_datos.SERVICIO_HAS_EMPLEADO TO 'almacen_taller_user'@'localhost'; -- Registrar que un empleado prestó un servicio (si esta es la tabla de registro)
GRANT SELECT ON proyecto_base_datos.DETALLE_FACTURA_VENTA TO 'almacen_taller_user'@'localhost'; -- Si necesitan verificar detalles de una venta de servicio

-- ***************************************************************
-- Permisos de VISTAS específicos para 'Personal de Almacén/Taller'
-- ***************************************************************
GRANT SELECT ON proyecto_base_datos.Vista_Inventario_Consulta TO 'almacen_taller_user'@'localhost';
GRANT SELECT ON proyecto_base_datos.Vista_Servicios_Realizados TO 'almacen_taller_user'@'localhost';


-- 4. Refrescar los privilegios para que los cambios surtan efecto
FLUSH PRIVILEGES;
