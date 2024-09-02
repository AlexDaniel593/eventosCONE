-- CONSULTA 1
/*¿Cuáles son los nombres de los clientes con su respectivo contacto 
que aún no han pagado la totalidad de sus eventos?*/
SELECT DISTINCT
    c.NOMBRE_CLIENTE,
    c.CONTACTO_CLIENTE
FROM
    CLIENTES c
JOIN
    EVENTOS e ON c.INE_CLIENTE = e.INE_CLIENTE
JOIN
    COTIZACIONES co ON e.ID_EVENTO = co.ID_EVENTO
WHERE
    co.ESTADO_PAGO ILIKE 'pendiente'

-- CONSULTA 2
/*¿Cuáles son los nombres de los clientes de los eventos que han contratado 
servicios de iluminación?*/
SELECT DISTINCT
    c.NOMBRE_CLIENTE
FROM
    CLIENTES c
JOIN
    EVENTOS e ON c.INE_CLIENTE = e.INE_CLIENTE
JOIN
    COTIZACIONES co ON e.ID_EVENTO = co.ID_EVENTO
JOIN
    PROPORCIONA p ON co.ID_COTIZACION = p.ID_COTIZACION
JOIN
    PROVEEDORES pv ON p.ID_PROVEEDOR = pv.ID_PROVEEDOR
JOIN
    CATEGORIA_SERVICIO cs ON pv.ID_CATEGORIA = cs.ID_CATEGORIA
WHERE
    cs.SERVICIO_PROVEDOR ILIKE 'Iluminación'

-- CONSULTA 3
/*¿Cuáles son los eventos organizados por un cliente específico y su 
respectivo número de invitados? (4910287463)*/
SELECT 
    e.ID_EVENTO,
    e.NOMBRE_EVENTO,
    e.NUMERO_INVITADOS
FROM 
    EVENTOS e
WHERE 
    e.INE_CLIENTE = '4910287463'; 

-- CONSULTA 4
/*¿Cuál es el nombre de un cliente y el lugar donde ha agendado un evento, 
dada una fecha en específico?*/
SELECT 
    c.NOMBRE_CLIENTE,
    e.LUGAR_EVENTO
FROM 
    CLIENTES c
JOIN 
    EVENTOS e ON c.INE_CLIENTE = e.INE_CLIENTE
WHERE 
    e.FECHA_EVENTO = '2024-12-1';

-- CONSULTA 5
/*¿Cuáles son los eventos que tienen un número de invitados mayor a un número en específico?*/
SELECT 
    ID_EVENTO,
    NOMBRE_EVENTO,
    NUMERO_INVITADOS
FROM 
    EVENTOS
WHERE 
    NUMERO_INVITADOS > 100;
	
-- CONSULTA 6
/*Mostrar el nombre del evento y el monto de todas las cotizaciones pagadas en el último mes*/
SELECT 
    e.NOMBRE_EVENTO,
    c.MONTO_COTIZACION
FROM 
    COTIZACIONES c
JOIN 
    EVENTOS e ON c.ID_EVENTO = e.ID_EVENTO
WHERE 
    c.ESTADO_PAGO = 'Pagado'
    AND e.FECHA_EVENTO BETWEEN CURRENT_DATE - INTERVAL '1 month' AND CURRENT_DATE;


-- CONSULTA 7
--¿Cuál es el monto total de cotizaciones de cada evento?
SELECT 
    e.NOMBRE_EVENTO,
    SUM(c.MONTO_COTIZACION) AS MONTO_TOTAL
FROM 
    COTIZACIONES c
JOIN 
    EVENTOS e ON c.ID_EVENTO = e.ID_EVENTO
GROUP BY 
    e.ID_EVENTO, e.NOMBRE_EVENTO;


-- CONSULTA 8
/*¿Cuáles son los clientes que tienen eventos que contienen cotizaciones 
pendientes de pago y cuáles son estos eventos?*/
SELECT 
    cl.NOMBRE_CLIENTE,
    e.NOMBRE_EVENTO,
    c.ID_COTIZACION,
    c.MONTO_COTIZACION,
    c.ESTADO_PAGO
FROM 
    CLIENTES cl
JOIN 
    EVENTOS e ON cl.INE_CLIENTE = e.INE_CLIENTE
JOIN 
    COTIZACIONES c ON e.ID_EVENTO = c.ID_EVENTO
WHERE 
    c.ESTADO_PAGO <> 'Pagado'
ORDER BY 
    cl.NOMBRE_CLIENTE, e.NOMBRE_EVENTO;

-- CONSULTA 9
--¿Cuáles son los proveedores que han brindado un servicio específico en un lugar específico?
-- musica (5) en el Hotel Central
SELECT 
    p.NOMBRE_PROVEEDOR
FROM 
    PROVEEDORES p
JOIN 
    PROPORCIONA pr ON p.ID_PROVEEDOR = pr.ID_PROVEEDOR
JOIN 
    COTIZACIONES c ON pr.ID_COTIZACION = c.ID_COTIZACION
JOIN 
    EVENTOS e ON c.ID_EVENTO = e.ID_EVENTO
WHERE 
    p.ID_CATEGORIA = 5
    AND e.LUGAR_EVENTO = 'Hotel Central'; 

-- CONSULTA 10
/*Mostrar el nombre del evento, la fecha y el lugar de todos los eventos 
programados de hoy en adelante*/
SELECT 
    NOMBRE_EVENTO,
    FECHA_EVENTO,
    LUGAR_EVENTO
FROM 
    EVENTOS
WHERE 
    FECHA_EVENTO >= CURRENT_DATE
ORDER BY 
    FECHA_EVENTO;

