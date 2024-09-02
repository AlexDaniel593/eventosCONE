-- Insertar un nuevo cliente
INSERT INTO CLIENTES (INE_CLIENTE, CONTACTO_CLIENTE, NOMBRE_CLIENTE)
VALUES ('1234567890', '9876543210', 'Cliente Test 1');

-- Actualizar el nombre del proveedor con ID_PROVEEDOR = 1
UPDATE PROVEEDORES
SET NOMBRE_PROVEEDOR = 'Proveedor Actualizado'
WHERE ID_PROVEEDOR = 1;

-- Eliminar un cliente
DELETE FROM CLIENTES WHERE INE_CLIENTE = '1234567890';

-- Eliminar un cliente con datos asociados
DELETE FROM CLIENTES WHERE INE_CLIENTE = '1075946283';


-- verificar auditoria
SELECT * FROM AUDITORIA
