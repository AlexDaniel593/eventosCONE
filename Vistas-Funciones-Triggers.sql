/*==============================================================*/
/*                            VISTAS                            */
/*==============================================================*/

-- Vista de Eventos desde la Fecha Actual
-- Muestra todos los eventos a partir de la fecha actual, ordenados por fecha, 
-- para facilitar la planificación y el seguimiento.
CREATE VIEW VISTA_EVENTOS_DESDE_FECHA_ACTUAL AS
SELECT 
    ID_EVENTO,
    NOMBRE_EVENTO,
    FECHA_EVENTO,
    LUGAR_EVENTO,
    AFORO_LUGAR_EVENTO
FROM 
    EVENTOS
WHERE 
    FECHA_EVENTO >= CURRENT_DATE
ORDER BY 
    FECHA_EVENTO;


-- Vista de Proveedores con Cotizaciones Pendientes
-- Muestra los proveedores que tienen cotizaciones pendientes de pago.
CREATE VIEW VISTA_PROVEEDORES_COTIZACIONES_PENDIENTES AS
SELECT 
    pr.ID_PROVEEDOR,
    pr.NOMBRE_PROVEEDOR,
    c.ID_COTIZACION,
    c.DESCRIPCION_COTIZACION,
    c.MONTO_COTIZACION,
    c.ESTADO_PAGO
FROM 
    PROVEEDORES pr
    JOIN PROPORCIONA po ON pr.ID_PROVEEDOR = po.ID_PROVEEDOR
    JOIN COTIZACIONES c ON po.ID_COTIZACION = c.ID_COTIZACION
WHERE 
    c.ESTADO_PAGO = 'Pendiente';




/*==============================================================*/
/*                          FUNCIONES                           */
/*==============================================================*/

-- Funcion para mostrar eventos y cotizaciones asociadas para un cliente especifico
CREATE OR REPLACE FUNCTION obtener_eventos_cotizaciones_cliente(p_ine_cliente CHAR(10))
RETURNS TABLE (
    id_evento INT,
    nombre_evento VARCHAR,
    fecha_evento DATE,
    id_cotizacion INT,
    descripcion_cotizacion VARCHAR,
    monto_cotizacion MONEY
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        e.ID_EVENTO,
        e.NOMBRE_EVENTO,
        e.FECHA_EVENTO,
        c.ID_COTIZACION,
        c.DESCRIPCION_COTIZACION,
        c.MONTO_COTIZACION
    FROM
        EVENTOS e
        LEFT JOIN COTIZACIONES c ON e.ID_EVENTO = c.ID_EVENTO
    WHERE
        e.INE_CLIENTE = p_ine_cliente;
END;
$$ LANGUAGE plpgsql;

-- ejemplo
SELECT * FROM obtener_eventos_cotizaciones_cliente('1075946283');



-- Función que Devuelve los Eventos Futuros de un Cliente especifico
CREATE OR REPLACE FUNCTION obtener_eventos_futuros_cliente(p_ine_cliente CHAR(10))
RETURNS TABLE (
    id_evento INT,
    nombre_evento VARCHAR,
    fecha_evento DATE
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.ID_EVENTO AS id_evento,
        e.NOMBRE_EVENTO AS nombre_evento,
        e.FECHA_EVENTO AS fecha_evento
    FROM 
        EVENTOS e
    WHERE 
        e.INE_CLIENTE = p_ine_cliente
      AND e.FECHA_EVENTO >= CURRENT_DATE
    ORDER BY 
        e.FECHA_EVENTO;
END;
$$ LANGUAGE plpgsql;

-- ejemplo
SELECT * FROM obtener_eventos_futuros_cliente('1075946283')


/*==============================================================*/
/*                           TRIGGERS                           */
/*==============================================================*/

-- Trigger para la eliminación de datos cuando se elimine un cliente 

-- Creamos la funcion para eliminar datos en cascada
CREATE OR REPLACE FUNCTION eliminar_datos_cliente()
RETURNS TRIGGER AS $$
BEGIN
    -- Eliminar la relación en la tabla PROPORCIONA
    DELETE FROM PROPORCIONA
    WHERE ID_COTIZACION IN (
        SELECT ID_COTIZACION
        FROM COTIZACIONES
        WHERE ID_EVENTO IN (
            SELECT ID_EVENTO
            FROM EVENTOS
            WHERE INE_CLIENTE = OLD.INE_CLIENTE
        )
    );

    -- Eliminar cotizaciones asociadas a los eventos del cliente
    DELETE FROM COTIZACIONES
    WHERE ID_EVENTO IN (
        SELECT ID_EVENTO
        FROM EVENTOS
        WHERE INE_CLIENTE = OLD.INE_CLIENTE
    );

    -- Eliminar eventos del cliente
    DELETE FROM EVENTOS
    WHERE INE_CLIENTE = OLD.INE_CLIENTE;

    -- Retornar el registro del cliente para permitir su eliminación
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Creacion del Trigger
CREATE TRIGGER trigger_eliminar_datos_cliente
BEFORE DELETE ON CLIENTES
FOR EACH ROW
EXECUTE FUNCTION eliminar_datos_cliente();

-- Ejemplo Eliminar el cliente
DELETE FROM CLIENTES WHERE INE_CLIENTE = '1075946283';




-- Trigger para verificar aforo

-- Creamos la funcion para verificar el aforo del evento
CREATE OR REPLACE FUNCTION verificar_aforo_evento()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica si el aforo del lugar es menor que el número de invitados
    IF NEW.NUMERO_INVITADOS > NEW.AFORO_LUGAR_EVENTO THEN
        RAISE EXCEPTION 'El número de invitados (%), supera el aforo del lugar (%)', 
                        NEW.NUMERO_INVITADOS, NEW.AFORO_LUGAR_EVENTO;
    END IF;

    -- Si todo está bien, permite la inserción
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Creacion del trigger
CREATE TRIGGER trigger_verificar_aforo_evento
BEFORE INSERT ON EVENTOS
FOR EACH ROW
EXECUTE FUNCTION verificar_aforo_evento();

-- Ejemplo con el cliente "3648291765" (INE)
-- Permite el ingreso del evento
INSERT INTO EVENTOS (
    INE_CLIENTE, NOMBRE_EVENTO, FECHA_EVENTO, LUGAR_EVENTO, AFORO_LUGAR_EVENTO, NUMERO_INVITADOS,
TEMATICA_EVENTO) VALUES (
    '3648291765', 'Evento A', '2024-09-15', 'Lugar A', 100, 80, 'Tematica A'
);

-- NO permite el ingreso del evento (SUPERA EL AFORO)
INSERT INTO EVENTOS (
    INE_CLIENTE, NOMBRE_EVENTO, FECHA_EVENTO, LUGAR_EVENTO, AFORO_LUGAR_EVENTO, NUMERO_INVITADOS,
TEMATICA_EVENTO) VALUES (
    '1234567890', 'Evento B', '2024-09-20', 'Lugar B', 50, 60, 'Tematica B'
);





