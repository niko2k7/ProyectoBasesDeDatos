-- Insertar en ACTOR
INSERT INTO ACTOR (act_documento, act_tipo, act_nombre, act_direccion, act_telefono, act_correo, act_estado_juridico) VALUES
(1060654586, 'CLIENTE', 'Carlos Gómez', 'Cra 10 #15-20', '3012345678', 'carlos.gomez@mail.com', 'NATURAL'),
(1070919081, 'CLIENTE', 'Laura Torres', 'Cll 45 #33-21', '3123456789', 'laura.torres@mail.com', 'NATURAL'),
(1084037531, 'CLIENTE', 'Pedro Martínez', 'Cra 11 #22-34', '3131234567', 'pedro.martinez@mail.com', 'NATURAL'),
(1088332181, 'CLIENTE', 'Ana Rodríguez', 'Cll 12 #45-67', '3145678910', 'ana.rodriguez@mail.com', 'NATURAL'),
(1089720081, 'CLIENTE', 'Sofía Morales', 'Cra 5 #50-80', '3156789012', 'sofia.morales@mail.com', 'NATURAL'),
(1091681318, 'EMPLEADO', 'José Pérez', 'Cll 8 #30-22', '3167890123', 'jose.perez@mail.com', 'NATURAL'),
(1093229202, 'EMPLEADO', 'María López', 'Cra 20 #40-50', '3178901234', 'maria.lopez@mail.com', 'NATURAL'),
(1115086181, 'EMPLEADO', 'Daniel Ruiz', 'Cll 17 #55-60', '3189012345', 'daniel.ruiz@mail.com', 'NATURAL'),
(1124860764, 'EMPLEADO', 'Valentina Castro', 'Cra 9 #60-70', '3190123456', 'valentina.castro@mail.com', 'NATURAL'),
(1127772276, 'EMPLEADO', 'Julián Mendoza', 'Cll 3 #25-35', '3201234567', 'julian.mendoza@mail.com', 'NATURAL'),
(860005223, 'PROVEEDOR', 'Insumos XYZ S.A.S', 'Zona Industrial #1', '3212345678', 'contacto@insumosxyz.com', 'JURIDICA'),
(890300431, 'PROVEEDOR', 'Servicios Integrales LTDA', 'Av. Principal #123', '3223456789', 'ventas@serviciosintegrales.com', 'JURIDICA'),
(890301690, 'PROVEEDOR', 'Distribuciones ABC', 'Parque Empresarial 4', '3234567890', 'pedidos@distribucionesabc.com', 'JURIDICA'),
(890300546, 'PROVEEDOR', 'Herramientas Plus', 'Zona Franca', '3245678901', 'soporte@herramientasplus.com', 'JURIDICA'),
(860001860, 'PROVEEDOR', 'ConstruMarket', 'Cra 7 #80-90', '3256789012', 'info@construmarket.com', 'JURIDICA'),
(860002067, 'PROVEEDOR', 'Maderas El Roble', 'Km 5 Vía Norte', '3267890123', 'maderas@elroble.com', 'JURIDICA'),
(860050956, 'PROVEEDOR', 'Tecnologías Gama S.A', 'Cll 100 #50-20', '3278901234', 'contacto@tecnologiasgama.com', 'JURIDICA');

-- Insertar en CLIENTE
INSERT INTO CLIENTE (act_documento) VALUES
(1060654586),
(1070919081),
(1084037531),
(1088332181),
(1089720081);

-- Insertar en EMPLEADO
INSERT INTO EMPLEADO (act_documento, emp_puesto) VALUES
(1091681318, 'Vendedor'),
(1093229202, 'Técnico'),
(1115086181, 'Administrador'),
(1124860764, 'Auxiliar'),
(1127772276, 'Contador');

-- Insertar en PROVEEDOR
INSERT INTO PROVEEDOR (act_documento) VALUES
(860005223),
(890300431),
(890301690),
(890300546),
(860001860),
(860002067),
(860050956);

-- Insertar en HORARIO_EMPLEADO
INSERT INTO HORARIO_EMPLEADO (hor_id, act_documento, hor_num_dias_laborales, hor_hora_inicio, hor_hora_fin) VALUES
(1, 1091681318, 5, '08:00:00', '17:00:00'),
(2, 1093229202, 6, '09:00:00', '18:00:00'),
(3, 1115086181, 5, '07:00:00', '16:00:00'),
(4, 1124860764, 6, '10:00:00', '19:00:00'),
(5, 1127772276, 5, '08:30:00', '17:30:00');

-- Insertar en PRODUCTO
INSERT INTO PRODUCTO (prod_tipo, prod_precio) VALUES
('SERVICIO', 50000.00),	-- Instalación
('SERVICIO', 120000.00), -- Mantenimiento
('ARTICULO', 320000.00), -- Llanta 175/70 R13
('ARTICULO', 450000.00), -- Llanta 195/60 R15
('ARTICULO', 580000.00), -- Llanta 225/50 R17
('ARTICULO', 750000.00), -- Llanta 245/45 R19
('ARTICULO', 900000.00), -- Llanta 265/35 R20
('ARTICULO', 500000.00), -- Rin 14 pulgadas
('ARTICULO', 850000.00), -- Rin 17 pulgadas reforzado
('ARTICULO', 1200000.00), -- Rin 20 pulgadas
('ARTICULO', 700000.00), -- Llanta SUV 235/60 R18
('ARTICULO', 820000.00), -- Llanta 4x4 275/70 R18
('ARTICULO', 1600000.00), -- Rin 4x4 20 pulgadas
('ARTICULO', 2000000.00), -- Rin de lujo 22 pulgadas
('ARTICULO', 2800000.00), -- Rin deportivo 24 pulgadas
('ARTICULO', 3500000.00), -- Rin SUV de lujo 26 pulgadas
('ARTICULO', 280000.00), -- ID 17
('ARTICULO', 360000.00), -- 18
('ARTICULO', 420000.00), -- 19
('ARTICULO', 510000.00), -- 20
('ARTICULO', 630000.00), -- 21
('ARTICULO', 700000.00), -- 22
('ARTICULO', 760000.00), -- 23
('ARTICULO', 820000.00), -- 24
('ARTICULO', 950000.00), -- 25
('ARTICULO', 1100000.00), -- 26
('ARTICULO', 250000.00), -- 27
('ARTICULO', 300000.00), -- 28
('ARTICULO', 550000.00), -- 29
('ARTICULO', 600000.00), -- 30
('ARTICULO', 750000.00), -- 31
('SERVICIO', 65000.00),  -- ID 32
('SERVICIO', 95000.00),  -- 33
('SERVICIO', 150000.00), -- 34
('SERVICIO', 200000.00), -- 35
('SERVICIO', 175000.00); -- 36


-- Insertar en ARTICULO
INSERT INTO ARTICULO (prod_id, art_tipo, art_marca, art_modelo, art_cantidad_disponible) VALUES
(3, 'Llanta', 'Firestone', '175/70 R13', 50),
(4, 'Llanta', 'Michelin', '195/60 R15', 40),
(5, 'Llanta', 'Continental', '225/50 R17', 30),
(6, 'Llanta', 'Pirelli', '245/45 R19', 25),
(7, 'Llanta', 'Yokohama', '265/35 R20', 15),
(8, 'Rin', 'Replica', '14 Pulgadas', 20),
(9, 'Rin', 'Enkei', '17 Pulgadas Reforzado', 15),
(10, 'Rin', 'BBS', '20 Pulgadas', 10),
(11, 'Llanta', 'Goodyear', 'SUV 235/60 R18', 20),
(12, 'Llanta', 'BFGoodrich', '4x4 275/70 R18', 12),
(13, 'Rin', 'American Racing', '4x4 20 Pulgadas', 8),
(14, 'Rin', 'Fuel Off-Road', 'De lujo 22 Pulgadas', 5),
(15, 'Rin', 'Vossen', 'Deportivo 24 Pulgadas', 3),
(16, 'Rin', 'Lexani', 'SUV de lujo 26 Pulgadas', 2),
(17, 'Llanta', 'Kumho', '175/65 R14', 35),
(18, 'Llanta', 'Toyo', '185/70 R14', 25),
(19, 'Llanta', 'Falken', '195/55 R16', 30),
(20, 'Llanta', 'Maxxis', '205/60 R16', 20),
(21, 'Rin', 'Speedline', '15 Pulgadas', 18),
(22, 'Rin', 'OZ Racing', '18 Pulgadas', 10),
(23, 'Rin', 'Borbet', '21 Pulgadas', 7),
(24, 'Llanta', 'Nexen', '215/55 R17', 22),
(25, 'Llanta', 'Bridgestone', '225/60 R17', 15),
(26, 'Rin', 'MSW', '22 Pulgadas Negro Mate', 5),
(27, 'Llanta', 'Hankook', '195/65 R15', 30),
(28, 'Rin', 'Momo', '16 Pulgadas', 25),
(29, 'Llanta', 'GT Radial', '205/55 R16', 20),
(30, 'Rin', 'Rial', '17 Pulgadas Plata', 12),
(31, 'Rin', 'Mak', '19 Pulgadas Grafito', 8);


-- Insertar en SERVICIO
INSERT INTO SERVICIO (prod_id, serv_nombre, serv_descripcion, act_documento) VALUES
(1, 'Instalación', 'Servicio de instalación de productos', 1093229202),
(2, 'Mantenimiento', 'Servicio de mantenimiento preventivo', 1093229202),
(32, 'Balanceo', 'Balanceo de ruedas para mayor estabilidad', 1091681318),
(33, 'Alineación', 'Alineación de dirección y suspensión', 1124860764),
(34, 'Cambio de válvulas', 'Reemplazo de válvulas defectuosas', 1093229202),
(35, 'Inspección técnica', 'Revisión general del vehículo', 1115086181),
(36, 'Revisión de frenos', 'Diagnóstico y ajuste del sistema de frenos', 1127772276);

-- Insertar en SERVICIO_HAS_EMPLEADO
INSERT INTO SERVICIO_HAS_EMPLEADO (prod_id, act_documento) VALUES
(1, 1093229202),
(2, 1093229202),
(32, 1091681318),
(33, 1124860764),
(34, 1093229202),
(35, 1115086181),
(36, 1127772276);

-- Insertar en MATERIAL_HERRAMIENTA
INSERT INTO MATERIAL_HERRAMIENTA (mat_nombre, mat_descripcion, mat_cantidad, mat_costo) VALUES
('Destornillador', 'Para ajuste de tornillos', 20, 5000.00),
('Broca', 'Para perforaciones', 100, 2000.00),
('Llave Inglesa', 'Ajuste de tuercas', 50, 15000.00);

-- Insertar en SERVICIO_has_MATERIAL_HERRAMIENTA
INSERT INTO SERVICIO_has_MATERIAL_HERRAMIENTA (prod_id, mat_id) VALUES
(1, 1), (1, 2), (2, 2), (2, 3);

-- Insertar en FACTURA_VENTA
INSERT INTO FACTURA_VENTA (fven_fecha, fven_total, fven_metodo_pago, act_documento) VALUES
('2025-06-15', 200000.00, 'Efectivo', 1060654586),
('2025-06-16', 350000.00, 'Tarjeta', 1070919081),
('2025-07-01', 680000.00, 'Efectivo', 1084037531),  -- Factura 3
('2025-07-02', 950000.00, 'Tarjeta', 1088332181),   -- Factura 4
('2025-07-03', 1300000.00, 'Transferencia', 1089720081); -- Factura 5

-- Insertar en DETALLE_FACTURA_VENTA
INSERT INTO DETALLE_FACTURA_VENTA (fven_codigo, prod_id, dfv_cantidad, dfv_precio_unitario, dfv_subtotal) VALUES
-- Factura 1
(1, 1, 1, 150000.00, 150000.00),
(1, 4, 1, 50000.00, 50000.00),

-- Factura 2
(2, 2, 1, 250000.00, 250000.00),
(2, 5, 1, 120000.00, 120000.00),

-- Factura 3
(3, 17, 1, 280000.00, 280000.00),
(3, 32, 1, 65000.00, 65000.00),
(3, 33, 1, 95000.00, 95000.00),
(3, 27, 1, 250000.00, 250000.00),

-- Factura 4
(4, 18, 1, 360000.00, 360000.00),
(4, 34, 1, 150000.00, 150000.00),
(4, 28, 1, 300000.00, 300000.00),
(4, 36, 1, 175000.00, 175000.00),

-- Factura 5
(5, 19, 1, 420000.00, 420000.00),
(5, 35, 1, 200000.00, 200000.00),
(5, 29, 1, 550000.00, 550000.00),
(5, 30, 1, 130000.00, 130000.00);

-- Insertar en FACTURA_COMPRA
INSERT INTO FACTURA_COMPRA (fcom_fecha, fcom_total, fcom_metodo_pago, act_documento) VALUES
('2025-06-10', 450000.00, 'Transferencia', 860005223);

-- Insertar en DETALLE_FACTURA_COMPRA
INSERT INTO DETALLE_FACTURA_COMPRA (fcom_codigo, prod_id, dfc_cantidad, dfc_precio_unitario, dfc_subtotal) VALUES
(1, 1, 3, 150000.00, 450000.00);

-- Insertar en PAGO_SALARIO
INSERT INTO PAGO_SALARIO (act_documento, pag_fecha, pag_salario_base, pag_comisiones, pag_anticipos, pag_total) VALUES
(1091681318, '2025-06-30', 1200000.00, 5, 50000.00, 1150000.00);

-- Insertar en CUENTA_POR_COBRAR
INSERT INTO CUENTA_POR_COBRAR (cxc_fecha_emision, cxc_total_deuda, cxc_saldo, act_documento) VALUES
('2025-06-15', 200000.00, 50000.00, 1060654586);

-- Insertar en CUENTA_POR_PAGAR
INSERT INTO CUENTA_POR_PAGAR (cxp_fecha_emision, cxp_total_deuda, cxp_saldo, act_documento) VALUES
('2025-06-10', 450000.00, 150000.00, 860005223);

-- Insertar en PLAZO_COBRO
INSERT INTO PLAZO_COBRO (cxc_id_cuenta, plcob_plazo, plcob_fecha_vencimiento, plcob_valor_cuota, plcob_valor_pagado, plcob_estado_cobro, plcob_fecha_pago_final) VALUES
(1, 30, '2025-07-15', 50000.00, 150000.00, 'EN CURSO', NULL);

-- Insertar en PLAZO_PAGO
INSERT INTO PLAZO_PAGO (cxp_id_cuenta, plpag_plazo, plpag_fecha_vencimiento, plpag_valor_cuota, plpag_valor_pagado, plpag_estado_pago, plpag_fecha_pago_final) VALUES
(1, 30, '2025-07-10', 150000.00, 300000.00, 'EN CURSO', NULL);

